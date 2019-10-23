//
//  HooOrderAddress.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/4.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/BmobObject.h>

@interface OrderAddress : BmobObject


@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *phone_number;

@property (nonatomic, copy)NSString *zipCode;

@property (nonatomic, copy)NSString *country_address;

@property (nonatomic, copy)NSString *detail_address;

@property (nonatomic, assign)NSNumber *is_default;

@end
