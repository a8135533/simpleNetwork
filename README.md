# simpleNetwork
#简单的网络编程
#1、AFNetworking
支持接口

//get请求

- (void) httpGet: (NSString *)url
      parameters: (id)parameters
      identifier:(int)identifier
           block:(void (^)(id responseObject,NSError *error))block;

//下载图片

- (void) httpGetImage: (NSString *)url
          identifier:(int)identifier
               block:(void (^)(id responseObject,NSError *error))block;

//通过参数获得图片

- (void) httpGetImage:(NSString *)url
          parameters:(id)parameters
          identifier:(int)identifier
               block:(void (^)(id responseObject,NSError *error))block;

//post请求
- (void) httpPost: (NSString *)url
       parameters: (id)parameters
       identifier:(int)identifier
            block:(void (^)(id responseObject,NSError *error))block;

//post数据

- (void) httpPost: (NSString *)url
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
