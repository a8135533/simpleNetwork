//
//  SDNetwork.m
//  HttpGetPostDemo
//
//  Created by wangxin on 15/6/5.
//  Copyright (c) 2015年 www.beequick.cn. All rights reserved.
//

#import "SDNetwork.h"



@interface SDNetwork () <NSURLSessionDelegate>

@end

@implementation SDNetwork

+(SDNetwork *)sharedNetwork
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedNetworkService = nil;
    dispatch_once(&pred, ^{
        _sharedNetworkService = [[self alloc] init];
    });
    return _sharedNetworkService;
}

-(void)downLoadImage:(NSString *)downUrl completionHandler:(void (^)(NSString *filePath))handler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:downUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {

        if (error) {
            
            NSLog(@"error = %@",error.localizedDescription);
            
        }else{
            
            NSLog(@"%@", location);
            
            NSString *fileName = [url lastPathComponent];
            
            NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            if (docs.count > 0) {
                NSString *path = [docs[0] stringByAppendingPathComponent:fileName];
                
                NSURL *toURL = [NSURL fileURLWithPath:path];
                [[NSFileManager defaultManager] removeItemAtURL:toURL error:nil];
                
                [[NSFileManager defaultManager] copyItemAtURL:location toURL:toURL error:nil];
                
                handler(path);
            }
            else
            {
                handler(@"");
            }
           

        }
        
        
    }];

    [task resume];
}

-(void)httpspost:(NSString *)postUrl dict:(NSDictionary *)dict completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))handler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:postUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    //https for header
    [request setValue:@"userNo" forHTTPHeaderField:@"userNo"];
    [request setValue:@"merchantId" forHTTPHeaderField:@"merchantId"];
    [request setValue:@"sign" forHTTPHeaderField:@"sign"];
   
    NSMutableArray *arr=[NSMutableArray array];
    for(NSString *key in [dict allKeys]){
        [arr addObject:[NSString stringWithFormat:@"%@=%@",key,[dict objectForKey:key]]];
    }
    NSString *bodyString=[arr componentsJoinedByString:@"&"];
    NSLog(@"bodystr=%@",bodyString);
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
     NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:handler];
    [task resume];
}


- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSString *method = challenge.protectionSpace.authenticationMethod;
    NSLog(@"%@", method);
    if([method isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        NSString *host = challenge.protectionSpace.host;
        NSLog(@"%@", host);
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        return;
    }
    //NSString *thePath = [BundleImage getBundlePath:@"ssl.p12"];
    
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"mobilepay" withExtension:@"bundle"]];
    NSString *thePath = [bundle pathForResource:@"ssl" ofType:@"p12"];

    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:thePath];
    CFDataRef inPKCS12Data = (CFDataRef)CFBridgingRetain(PKCS12Data);
    SecIdentityRef identity;        // 读取p12证书中的内容
    OSStatus result = [self extractP12Data:inPKCS12Data toIdentity:&identity];
        
    if(result != errSecSuccess){
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);        return;
    }
    SecCertificateRef certificate = NULL;
    SecIdentityCopyCertificate (identity, &certificate);
    const void *certs[] = {certificate};
    CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity certificates:(NSArray*)CFBridgingRelease(certArray) persistence:NSURLCredentialPersistencePermanent];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

-(OSStatus) extractP12Data:(CFDataRef)inP12Data toIdentity:(SecIdentityRef*)identity
{
    OSStatus securityError = errSecSuccess;
    CFStringRef password = CFSTR("888888");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12Data, options, &items);
    if (securityError == 0) {
        CFDictionaryRef ident = CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(ident, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
    }
    if (options)
    {
        CFRelease(options);
    }
    return securityError;
}

+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    
    
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("888888"); //证书密码
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys,values, 1,NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    //securityError = SecPKCS12Import((CFDataRef)inPKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,optionsDictionary,&items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failed with error code %d",(int)securityError);
        return NO;
    }
    return YES;
}

OSStatus extractIdentityAndTrust(CFDataRef inPKCS12Data,        // 5
                                 
                                 SecIdentityRef *outIdentity,
                                 
                                 SecTrustRef *outTrust)

{
    
    OSStatus securityError = errSecSuccess;
    CFStringRef password = CFSTR("888888");
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(
                                                           
                                                           NULL, keys,
                                                           
                                                           values, 1,
                                                           
                                                           NULL, NULL);  // 6
    
    
    
    
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    securityError = SecPKCS12Import(inPKCS12Data,
                                    
                                    optionsDictionary,
                                    
                                    &items);                    // 7
    
    
    
    
    
    //
    
    if (securityError == 0) {                                   // 8
        
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        
        const void *tempIdentity = NULL;
        
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust,
                                             
                                             kSecImportItemIdentity);
        
        *outIdentity = (SecIdentityRef)tempIdentity;
        
        const void *tempTrust = NULL;
        
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        
        *outTrust = (SecTrustRef)tempTrust;
        
    }
    
    
    
    if (optionsDictionary)
        
        CFRelease(optionsDictionary);                            // 9
    
    //[PKCS12Data release];
    
    return 1;
}

@end
