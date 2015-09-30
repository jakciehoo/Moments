//
//  HooProductColor.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/28.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface HooProductColor : NSObject<MJKeyValue>

@property (nonatomic, copy)NSString *color_id;

@property (nonatomic, copy)NSString *color_name;

@property (nonatomic, copy)NSString *color_hexa;

@property (nonatomic, strong)NSURL *product_imageURL;

@property (nonatomic, strong)NSArray *sizes;


@end
