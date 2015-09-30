//
//  HooProdcutCategory.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/29.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface HooProductCategory : NSObject<MJKeyValue>

@property (nonatomic, copy)NSString *category_id;

@property (nonatomic, copy)NSString *category_name;

@property (nonatomic, strong)NSArray *products;

@end
