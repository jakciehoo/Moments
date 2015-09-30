//
//  HooQualitModel.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/28.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooProductModel.h"
#import "HooProductGroup.h"

@implementation HooProductModel

+(NSDictionary *)objectClassInArray
{
    return @{@"groups":[HooProductGroup class]};
}

@end
