# simpleNetwork
#简单的网络编程
#1、AFNetworking
支持接口

//get请求

-(void) httpGet: (NSString *)url
      parameters: (id)parameters
      identifier:(int)identifier
           block:(void (^)(id responseObject,NSError *error))block;

//下载图片

-(void) httpGetImage: (NSString *)url
          identifier:(int)identifier
               block:(void (^)(id responseObject,NSError *error))block;

//通过参数获得图片

-(void) httpGetImage:(NSString *)url
          parameters:(id)parameters
          identifier:(int)identifier
               block:(void (^)(id responseObject,NSError *error))block;

//post请求

-(void) httpPost: (NSString *)url
       parameters: (id)parameters
       identifier:(int)identifier
            block:(void (^)(id responseObject,NSError *error))block;

//post数据

-(void) httpPost: (NSString *)url
       parameters: (id)parameters
        imageData:(NSData *)imageData
       identifier:(int)identifier
            block:(void (^)(id responseObject,NSError *error))block;

使用例子

[[NetworkService sharedNetworkService] getIndexDataWithBlock:^(id responseObject, NSError *error) 
{
        if (responseObject)
        {
            
        }
}];

#2、AsyncSocket

#3、NSURLSession

支持接口

//post请求 请求参数放在NSDictionary中

-(void)httpspost:(NSString *)postUrl dict:(NSDictionary *)dict completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))handler;

//下载图片

-(void)downLoadImage:(NSString *)downUrl completionHandler:(void (^)(NSString *filePath))handler;

使用例子

   [[SDNetworkManager sharedNetworkManager] getHomeInfoWithBlock:^(id responseObject, NSError *error) {
        if (error) {
            //@"服务器连接异常";
        }
        else
        {
            if([responseObject.code isEqualToString:@"200"])
            {
            }
            else
            {
                [self toastInfo:responseObject.msg];
            }
        }
        
    }];


