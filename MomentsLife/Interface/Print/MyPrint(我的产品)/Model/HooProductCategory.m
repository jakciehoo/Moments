//
//  HooProdcutCategory.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/29.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooProductCategory.h"
#import "HooProduct.h"

@implementation HooProductCategory

+(NSDictionary *)objectClassInArray
{
    return  @{@"products":[HooProduct class]};
}

@end
