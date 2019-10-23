//
//  HooSocialGroup.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/28.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooProductGroup.h"
#import "HooProductColor.h"

@implementation HooProductGroup

+(NSDictionary *)objectClassInArray
{
    return @{@"colors":[HooProductColor class]};
}

@end
