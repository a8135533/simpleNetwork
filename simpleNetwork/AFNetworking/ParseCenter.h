//
//  ParseCenter.h
//  simpleNetwork
//
//  Created by wangxin on 15/11/23.
//  Copyright © 2015年 wangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseCenter : NSObject

+ (id)parseResponseObject:(id)responseObject withIdentifier:(int)identifier error:(NSError**)err;

@end
