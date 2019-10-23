//
//  HooSettingItem.m
//  HooLottery
//
//  Created by HooJackie on 15/7/5.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooSettingItem.h"

@implementation HooSettingItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    HooSettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    return  item;
}
@end
