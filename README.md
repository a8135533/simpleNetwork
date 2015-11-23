# simpleNetwork
#简单的网络编程
#1、AFNetworking（http/https）
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

#2、AsyncSocket(Socket)

使用例子

    //AsyncSocket
    [TCPUtils sharedInstance].socketHost = @"192.168.1.1";
    [TCPUtils sharedInstance].socketPort = 808;
    [TCPUtils sharedInstance].delegate = self;
    // 在连接前先进行手动断开
    [TCPUtils sharedInstance].socket.userData = SocketOfflineByUser;
    [[TCPUtils sharedInstance] cutOffSocket];
    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
    [TCPUtils sharedInstance].socket.userData = SocketOfflineByServer;
    [TCPUtils sharedInstance].data = nil;
    [TCPUtils sharedInstance].timeout = 120;
    [[TCPUtils sharedInstance] socketConnectHost];
    
#3、NSURLSession（http/https）

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


