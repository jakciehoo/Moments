//
//  Bmob.h
//  BmobBasicSDK
//
//  Created by limao on 15/5/27.
//  Copyright (c) 2015年 Bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BmobPayConfig.h"
#import "BmobPay.h"

/**
 *  初始化成功的通知，注册该通知可以在初始化成功后执行需要的动作，最新版本的初始化过程已经修改成同步，因此该通过可以不作处理
 */
extern NSString *const  kBmobPayInitSuccessNotification;

/**
 *  初始化失败的通知
 */
extern NSString *const  kBmobPayInitFailNotification;

/**
 *  SDK开放接口，提供给用户的接口将放在这里
 */
@interface BmobPaySDK : NSObject

/**
 *	向Bmob注册应用
 *
 *	@param	appKey	在网站注册的appkey
 */
+(void)registerWithAppKey:(NSString*)appKey;


/**
 *  得到服务器时间戳
 *
 *  @return 时间戳字符串 (到秒)
 */
+(NSString*)getServerTimestamp;


/**
 *  在应用进入前台是调用
 */
+(void)activateSDK;

@end
