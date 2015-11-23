//
//  SDNetwork.h
//  HttpGetPostDemo
//
//  Created by wangxin on 15/6/5.
//  Copyright (c) 2015年 www.beequick.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDNetwork : NSObject

+(SDNetwork *)sharedNetwork;

//post请求 请求参数放在NSDictionary中
-(void)httpspost:(NSString *)postUrl dict:(NSDictionary *)dict completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))handler;

//下载图片
-(void)downLoadImage:(NSString *)downUrl completionHandler:(void (^)(NSString *filePath))handler;


@end
