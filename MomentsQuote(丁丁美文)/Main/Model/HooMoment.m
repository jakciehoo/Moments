//
//  HooMoment.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/15.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooMoment.h"
#import "MJExtension.h"

@interface HooMoment ()<MJKeyValue>


@end

@implementation HooMoment

+(NSArray *)ignoredPropertyNames
{
    return @[@"fontColorR",@"fontColorG",@"fontName",@"fontColorB",@"fontSize",@"isMine"];
}

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"quote":@"description_short"};
}

@end
