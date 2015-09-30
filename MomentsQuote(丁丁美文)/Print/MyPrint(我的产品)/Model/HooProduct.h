//
//  HooProduct.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/29.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface HooProduct : NSObject<MJKeyValue>

@property (nonatomic, copy)NSString *product_id;

@property (nonatomic, copy)NSString *product_name;

@property (nonatomic, copy)NSString *product_icon;

@property (nonatomic, copy)NSURL *product_size_infoURL;

@property (nonatomic, strong)NSArray *models;




@end
