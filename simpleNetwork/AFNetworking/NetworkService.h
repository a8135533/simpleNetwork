//
//  NetworkService.h
//  p2p
//
//  Created by michealmiker on 15-3-19.
//  Copyright (c) 2015年 sendiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
@interface NetworkService : NSObject
+(NetworkService *)sharedNetworkService;

//调用接口
-(void)getIndexDataWithBlock:(void (^)(id responseObject, NSError *error))block;

@end
