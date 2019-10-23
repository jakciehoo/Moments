//
//  HooSettingArrowItem.m
//  HooLottery
//
//  Created by HooJackie on 15/7/5.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooSettingArrowItem.h"

@implementation HooSettingArrowItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    HooSettingArrowItem *item = [super itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;

}
@end
