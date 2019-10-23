//
//  HooSocialGroup.h
//  MomentsLife
//
//  Created by HooJackie on 15/9/28.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface HooProductGroup : NSObject<MJKeyValue>

@property (nonatomic, copy)NSString *group_id;

@property (nonatomic, copy)NSString *group_name;


@property (nonatomic, strong)NSArray *colors;


@end
