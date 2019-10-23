//
//  BmobConfig.h
//  BmobBasicSDK
//
//  Created by limao on 15/5/27.
//  Copyright (c) 2015年 Bmob. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef BmobBasicSDK_BmobPayConfig_h
#define BmobBasicSDK_BmobPayConfig_h

typedef void (^BmobBooleanResultBlock) (BOOL isSuccessful, NSError *error);
typedef void (^BmobIntegerResultBlock)(int number, NSError *error) ;
typedef void (^BmobQuerySMSCodeStateResultBlock)(NSDictionary *dic,NSError *error);

UIKIT_STATIC_INLINE NSString* BmobPayVersion()
{
    return @"BmobPay v1.0.4";
}
#endif
