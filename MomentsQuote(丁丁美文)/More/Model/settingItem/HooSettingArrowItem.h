//
//  HooSettingArrowItem.h
//  HooLottery
//
//  Created by HooJackie on 15/7/5.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooSettingItem.h"

@interface HooSettingArrowItem : HooSettingItem
@property (nonatomic,assign) Class destVcClass;


+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;

@end
