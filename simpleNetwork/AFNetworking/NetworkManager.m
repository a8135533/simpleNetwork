//
//  NetworkManager.m
//  simpleNetwork
//
//  Created by wangxin on 15/11/23.
//  Copyright © 2015年 wangxin. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "ParseCenter.h"

@implementation NetworkManager

+ (NSString *)URLCachePath
{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *cacheDirectorys = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *URLCachePath = [cacheDirectorys[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/NSURLCache", bundleIdentifier]];
    //NSLog(@"URLCachePath:%@", URLCachePath);
    return URLCachePath;
}


- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        self.requestSerializer.timeoutInterval = 60;
        
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        self.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        
        [self.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"System"];
        NSString* sNowVersion= [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        [self.requestSerializer setValue:sNowVersion forHTTPHeaderField:@"versionName"];
    }
    return self;
}
+ (instancetype)shareManager
{
    static NetworkManager *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:[NetworkManager URLCachePath]];
        [NSURLCache setSharedURLCache:URLCache];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        _shareManager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:kAppBaseURLString]];
    });
    return _shareManager;
}

- (void) httpGet: (NSString *)url
      parameters: (id)parameters
      identifier:(int)identifier
           block:(void (^)(id responseObject,NSError *error))block
{
    [self connectNetWorkWithUrl:url type:@"GET" parameters:parameters imageData:nil identifier:identifier block:block];
}

-(void) httpGetImage:(NSString *)url identifier:(int)identifier block:(void (^)(id responseObject,NSError *error))block
{
    [self connectNetWorkWithUrl:url type:@"GETIMAGE" parameters:nil imageData:nil identifier:identifier block:block];
}

-(void) httpGetImage:(NSString *)url parameters:(id)parameters identifier:(int)identifier block:(void (^)(id responseObject,NSError *error))block
{
    [self connectNetWorkWithUrl:url type:@"GETIMAGE" parameters:parameters imageData:nil identifier:identifier block:block];
}

- (void) httpPost: (NSString *)url
       parameters: (id)parameters
       identifier:(int)identifier
            block:(void (^)(id responseObject,NSError *error))block
{
    
    [self connectNetWorkWithUrl:url type:@"POST" parameters:parameters imageData:nil identifier:identifier block:block];
}


- (void) httpPost: (NSString *)url
       parameters: (id)parameters
        imageData:(NSData *)imageData
       identifier:(int)identifier
            block:(void (^)(id responseObject,NSError *error))block
{
    
    [self connectNetWorkWithUrl:url type:@"PostImage" parameters:parameters imageData:imageData identifier:identifier block:block];
}


- (void) connectNetWorkWithUrl:(NSString *) URLString
                          type:(id)type
                    parameters:(id)parameters
                     imageData:(NSData *)imageData
                    identifier:(int)identifier
                         block:(void (^)(id responseObject,NSError *error))block
{
    [self.requestSerializer setValue:@"testtoken" forHTTPHeaderField:@"token"];
    [self.requestSerializer setValue:@"testuid" forHTTPHeaderField:@"uid"];
    __weak __typeof(self)weakSelf = self;
    if([type isEqualToString:@"POST"]){
        [self POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf handleSuccessTask:task responseObject:responseObject identifier:identifier block:block];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf handleFailureTask:task identifier:identifier error:error  block:block];
        }];
        
    }
    else if ([type isEqualToString:@"GET"]){
        
        [self GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [weakSelf handleSuccessTask:task responseObject:responseObject identifier:identifier block:block];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [weakSelf handleFailureTask:task identifier:identifier error:error  block:block];
            
        }];
    }else if ([type isEqualToString:@"PostImage"]){
        [self POST_IMAGE:URLString parameters:parameters fromData:imageData success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf handleSuccessTask:task responseObject:responseObject identifier:identifier block:block];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf handleFailureTask:task identifier:identifier error:error  block:block];
        }];
    }else if([type isEqualToString:@"GETIMAGE"])
    {
        [self downImage:URLString parameters:parameters success:^(NSURLSessionDownloadTask *task, id responseObject) {
            [weakSelf handleSuccessImageTask:task responseObject:responseObject identifier:identifier block:block];
        } failure:^(NSURLSessionDownloadTask *task, NSError *error) {
            [weakSelf handleFailureTask:task identifier:identifier error:error  block:block];
        }];
    }
}

-(void)handleSuccessImageTask:(NSURLSessionTask *)task responseObject:(id)responseObject identifier:(int)identifier block:(void (^)(id responseObject,NSError *error))block
{
    block(responseObject, nil);
}

- (void)handleSuccessTask:(NSURLSessionTask *)task responseObject:(id)responseObject identifier:(int)identifier block:(void (^)(id responseObject,NSError *error))block
{
    NSLog(@"responseObject=%@",responseObject);
    
    NSError* err = nil;
    id parseResult = [ParseCenter parseResponseObject:responseObject withIdentifier:identifier error:&err];
    
    if(err){
        NSInteger status = -1;
        NSString *message = @"json解析错误";
        NSError *error = [NetworkManager error:status description:message];
        block(nil,error);
    }
    else if (parseResult) {
        block(parseResult,nil);
    }
    else {
        NSInteger status = [[responseObject objectForKey:@"code"] integerValue];
        NSString *message = [responseObject objectForKey:@"msg"];
        NSError *error = [NetworkManager error:status description:message];
        block(nil,error);
    }
    
}
- (void)handleFailureTask:(NSURLSessionTask *)task identifier:(int)identifier error:(NSError *)error block:(void (^)(id responseObject,NSError *error))block
{
    block(nil,error);
    NSLog(@"error=%@",[error localizedDescription]);
}




- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    NSString *body = nil;
    if ([request HTTPBody]) {
        body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    
    NSLog(@"%@ '%@':\nrequest.headers=%@\nrequest.body=%@", [request HTTPMethod], [[request URL] absoluteString], [request allHTTPHeaderFields], body);
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        
        if (error) {
            
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];
    
    return task;
}


- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    NSString *body = nil;
    if ([request HTTPBody]) {
        body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    NSLog(@"%@ '%@':\nrequest.headers=%@\nrequest.body=%@", [request HTTPMethod], [[request URL] absoluteString], [request allHTTPHeaderFields], body);
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];
    
    return dataTask;
}





- (NSURLSessionUploadTask *)POST_IMAGE:(NSString *)URLString
                            parameters:(id)parameters
                              fromData:(NSData *)imageData
                               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    
    NSMutableString *body=[[NSMutableString alloc]init];
    for (NSString *key in parameters) {
        
        id value = parameters[key];
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        }
        [body appendFormat:@"%@\r\n",MPboundary];
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        [body appendFormat:@"%@\r\n",value];
    }
    
    
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",@"image.jpg"];
    [body appendFormat:@"Content-Type: image/jpge,image/png, image/jpeg, image/pjpeg\r\n\r\n"];
    
    
    NSMutableData *bodyData = [NSMutableData data];
    [bodyData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:imageData];
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary] ;
    [bodyData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //    设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    
    
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
    
    
    
    NSString *httpbody = nil;
    if ([request HTTPBody]) {
        httpbody = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    NSLog(@"%@ '%@':\nrequest.headers=%@\nrequest.body=%@", [request HTTPMethod], [[request URL] absoluteString], [request allHTTPHeaderFields], httpbody);
    
    
    __block NSURLSessionUploadTask *task = [self uploadTaskWithRequest:request fromData:bodyData progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];
    
    return task;
}


-(NSURLSessionDownloadTask *)downImage:(NSString *)URLString
                            parameters:(id)parameters
                               success:(void (^)(NSURLSessionDownloadTask *task, id responseObject))success
                               failure:(void (^)(NSURLSessionDownloadTask *task, NSError *error))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                                              {
                                                  NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
                                                  [[NSFileManager defaultManager] removeItemAtURL:[documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]] error:nil];
                                                  return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                              }completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                  NSLog(@"File downloaded to: %@", filePath);
                                                  //uploadFilePath=filePath;
                                                  if (error) {
                                                      if (failure) {
                                                          failure(downloadTask, error);
                                                      }
                                                  } else {
                                                      if (success) {
                                                          success(downloadTask, filePath);
                                                      }
                                                  }
                                                  
                                              }];
    [downloadTask resume];
    
    return downloadTask;
    
}


+ (NSError *)error:(NSInteger)inCode description:(NSString *)inDescription
{
    NSParameterAssert(inDescription != NULL);
    NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        inDescription, NSLocalizedDescriptionKey,
                                        NULL];
    
    NSError *theError = [NSError errorWithDomain:@"kErrorDomain" code:inCode userInfo:theUserInfo];
    return(theError);
}



@end
