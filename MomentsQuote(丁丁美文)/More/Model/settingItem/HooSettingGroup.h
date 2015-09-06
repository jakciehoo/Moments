//
//  HooSettingGroup.h
//  HooLottery
//
//  Created by HooJackie on 15/7/5.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HooSettingGroup : NSObject

@property (nonatomic, copy) NSString *header;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *footer;
@end
