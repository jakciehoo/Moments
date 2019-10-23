//
//  HooMoneyFooterView.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HooOrderDeliveryFooterView : UIView

@property (nonatomic, copy)NSString *delivery_price;

@property (nonatomic, copy)NSString *delivery_number;

+ (instancetype)orderDeliveryFooterView;

@end
