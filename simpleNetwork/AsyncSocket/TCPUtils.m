//
//  TCPUtils.m
//  socket
//
//  Created by wangxin on 15/11/13.
//  Copyright © 2015年 wangxin. All rights reserved.
//

#import "TCPUtils.h"


@implementation TCPUtils

+(TCPUtils *)sharedInstance
{
    static TCPUtils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

// socket连接
-(void)socketConnectHost{
    
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    
    BOOL connectOK = [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:_timeout error:&error];
    
    //[_socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    
    if (connectOK) {
        [self sendDataToSocket];
    }
    
    
}

// 切断socket
-(void)cutOffSocket{
    
    self.socket.userData = SocketOfflineByUser;// 声明是由用户主动切断
    
    [self.connectTimer invalidate];
    
    [self.socket disconnect];
}

#pragma mark  - 连接成功回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString  *)host port:(UInt16)port
{
    NSLog(@"socket连接成功");
    
    [_socket readDataWithTimeout: -1 tag: 0];
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"sorry the connect is failure %ld",sock.userData);
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        //[self socketConnectHost];
    }
    else if (sock.userData == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
}


-(void)sendDataToSocket
{
    [self.socket writeData:_data withTimeout:_timeout tag:1];
}


-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [_socket readDataWithTimeout: -1 tag: 0];
}


-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 对得到的data值进行解析与转换即可
    if ([_delegate respondsToSelector:@selector(tcpReciveData:)]) {
        [_delegate tcpReciveData:data];
    }
    
    [_socket readDataWithTimeout: -1 tag: 0];
}

@end
