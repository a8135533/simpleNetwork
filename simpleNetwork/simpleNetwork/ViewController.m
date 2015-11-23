//
//  ViewController.m
//  simpleNetwork
//
//  Created by wangxin on 15/11/23.
//  Copyright © 2015年 wangxin. All rights reserved.
//

#import "ViewController.h"
#import "NetworkService.h"
#import "SDNetworkManager.h"
#import "TCPUtils.h"

@interface ViewController ()<TCPDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //AFNetworking
    [[NetworkService sharedNetworkService] getIndexDataWithBlock:^(id responseObject, NSError *error) {
        if (responseObject)
        {
            
        }
    }];
    
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
    
    //NSURLSession
    [[SDNetworkManager sharedNetworkManager] getHomeInfoWithBlock:^(id responseObject, NSError *error) {
        if (error) {
            //@"服务器连接异常";
        }
        else
        {
//            if([responseObject.code isEqualToString:@"200"])
//            {
//            
//            }
//            else
//            {
//                [self toastInfo:responseObject.msg];
//            }
        }
        
    }];
    


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
