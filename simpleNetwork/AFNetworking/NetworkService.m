//
//  NetworkService.m
//  p2p
//
//  Created by michealmiker on 15-3-19.
//  Copyright (c) 2015年 sendiyang. All rights reserved.
//

#import "NetworkService.h"

@implementation NetworkService

+(NetworkService *)sharedNetworkService
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedNetworkService = nil;
    dispatch_once(&pred, ^{
        _sharedNetworkService = [[self alloc] init];
    });
    return _sharedNetworkService;
}


//首页接口
-(void)getIndexDataWithBlock:(void (^)(id responseObject, NSError *error))block
{
    [[NetworkManager shareManager] httpGet:URL_REST_INDEX
                                parameters:nil
                                identifier:IDENTIFIER_INDEX
                                     block:^(id responseObject,NSError *error) {
                            
                                         block(responseObject,error);
                                     }];
    
    
}


@end
