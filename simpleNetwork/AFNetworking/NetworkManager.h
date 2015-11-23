//
//  NetworkManager.h
//  simpleNetwork
//
//  Created by wangxin on 15/11/23.
//  Copyright © 2015年 wangxin. All rights reserved.
//
#import "AFHTTPSessionManager.h"
#import "NetworkConstants.h"

@interface NetworkManager : AFHTTPSessionManager

+(instancetype)shareManager;

//get请求
- (void) httpGet: (NSString *)url
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

@end
