//
//  HooSettingItem.h
//  HooLottery
//
//  Created by HooJackie on 15/7/5.
//  Copyright (c) 2015年 jackie. All rights reserved.
//
typedef void (^hooSettingItemOption)();

#import <Foundation/Foundation.h>

@interface HooSettingItem : NSObject
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) hooSettingItemOption option;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
@end
