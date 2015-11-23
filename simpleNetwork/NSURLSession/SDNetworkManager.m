//
//  SDNetworkManager.m
//  MobilePaySdk
//
//  Created by wangxin on 15/6/5.
//  Copyright (c) 2015年 wangxin. All rights reserved.
//

#import "SDNetworkManager.h"
#import "SDNetwork.h"

@implementation SDNetworkManager


#define URL_BASE            @"http://test"

#define URL_HOME            @"home"


+(SDNetworkManager *)sharedNetworkManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedNetworkService = nil;
    dispatch_once(&pred, ^{
        _sharedNetworkService = [[self alloc] init];
    });
    return _sharedNetworkService;
}

-(NSString *)combineURL:(NSString *)url
{
    return [NSString stringWithFormat:@"%@%@", URL_BASE, url];
}


//首页接口
-(void)getHomeInfoWithBlock:(void (^)(id responseObject, NSError *error))block
{
    
    [[SDNetwork sharedNetwork] httpspost:[self combineURL:URL_HOME] dict:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"error=%@", [error localizedDescription]);
                    block(data, error);
                }
                else
                {
                    NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                    if (json) {
                        NSLog(@"post_json==%@",json);
                    }
                    
                    //hydrateFromJson:json;
                    //block(result, error);

                }
            });
    }];
}



@end
