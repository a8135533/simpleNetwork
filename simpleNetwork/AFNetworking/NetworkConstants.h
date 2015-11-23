//
//  NetworkConstants.h
//  simpleNetwork
//
//  Created by wangxin on 15/11/23.
//  Copyright © 2015年 wangxin. All rights reserved.
//

#ifndef NetworkConstants_h
#define NetworkConstants_h

//正式服务器地址
#define kAppBaseURLString @"http://test.com.cn:8082/mobile/"

#define KP2PRegistrationAgreement @"http://p2pmobile.onewealth.com.cn:8082/themes/p2p_registration_agreement.html"

#define _setObjectToDictionary(dict, key, object) if (object != nil) [dict setObject:object forKey:key]

#define kPayOsp @"ios"   //平台名称
#define kPayOsv @"1.0.0" //平台版本
#define kPaySdkv @"1.0"  //SDK 版本号
#define KGoodsName @"P2P"//商品名称
#define KOrderInfo @"P2P"
#define KBusiType  @"0"

//网络状态：
#define NETWORK_SUCCESS_STATUS_CODE 200
//快捷支付网络状态
#define QPNETWORK_SUCCESS_STATUS_CODE 0000

//首页接口
#define URL_REST_INDEX @"index"
#define IDENTIFIER_INDEX 1


#endif /* NetworkConstants_h */
