//
//  HooOrderDelivery.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/6.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <BmobSDK/BmobObject.h>

@interface OrderDelivery : BmobObject

//@property (nonatomic, copy)NSString *delivery_id;

@property (nonatomic, copy)NSString *delivery_name;

@property (nonatomic, copy)NSString *delivery_price;

@property (nonatomic, copy)NSString *delivery_time;

@property (nonatomic, assign)NSNumber *is_default;

@end
