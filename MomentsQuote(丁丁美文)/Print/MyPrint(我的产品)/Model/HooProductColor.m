//
//  HooProductColor.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/28.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooProductColor.h"
#import "HooProductSize.h"

@implementation HooProductColor

+(NSDictionary *)objectClassInArray
{
    return @{@"sizes":[HooProductSize class]};
}

@end
