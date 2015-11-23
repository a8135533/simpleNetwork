//
//  ParseCenter.m
//  simpleNetwork
//
//  Created by wangxin on 15/11/23.
//  Copyright © 2015年 wangxin. All rights reserved.
//

#import "ParseCenter.h"
#import "NetworkConstants.h"

@implementation ParseCenter

+ (id)parseResponseObject:(id)responseObject withIdentifier:(int)identifier error:(NSError**)err
{
    id result = responseObject;
    switch (identifier) {
        case IDENTIFIER_INDEX:
        {
            result = [ParseCenter parseIndex:responseObject error:err];
            break;
        }
        default:
            break;
    }
    return result;
}

+ (BOOL)checkServerReturnDataIsCorrect:(id)responseObject
{
    NSString *status = [responseObject objectForKey:@"code"];
    
    if ([status intValue] == NETWORK_SUCCESS_STATUS_CODE) {
        return YES;
    }else {
        return NO;
    }
}

//首页接口
+ (id)parseIndex:(id)responseObject error:(NSError**)err
{
    if ([ParseCenter checkServerReturnDataIsCorrect:responseObject]) {
        
        //数据解析
        return nil;
        
    }
    
    return nil;
}

@end
