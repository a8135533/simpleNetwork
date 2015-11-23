//
//  TCPUtils.h
//  socket
//
//  Created by wangxin on 15/11/13.
//  Copyright © 2015年 wangxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

enum{
    SocketOfflineByServer,// 服务器掉线，默认为0
    SocketOfflineByUser,  // 用户主动cut
};

@protocol TCPDelegate <NSObject>

-(void)tcpReciveData:(NSData *)data;
-(void)tcpConnectFailed;

@end

@interface TCPUtils : NSObject<AsyncSocketDelegate>

+(TCPUtils *)sharedInstance;

@property (nonatomic, strong) id<TCPDelegate> delegate;

@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot
@property (nonatomic, strong) NSData         *data;
@property (nonatomic) int                    timeout;

@property (nonatomic, retain) NSTimer        *connectTimer; // 计时器

-(void)socketConnectHost;  // socket连接
-(void)cutOffSocket; // 断开socket连接

@end
