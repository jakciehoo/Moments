//
//  HooProduct.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/29.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooProduct.h"
#import "HooProductModel.h"

@implementation HooProduct

+(NSDictionary *)objectClassInArray
{
    return @{@"models":[HooProductModel class]};
}

@end
