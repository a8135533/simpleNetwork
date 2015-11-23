//
//  SDNetworkManager.h
//  MobilePaySdk
//
//  Created by wangxin on 15/6/5.
//  Copyright (c) 2015年 wangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDNetworkManager : NSObject

+(SDNetworkManager *)sharedNetworkManager;


//首页接口
-(void)getHomeInfoWithBlock:(void (^)(id responseObject, NSError *error))block;



@end
