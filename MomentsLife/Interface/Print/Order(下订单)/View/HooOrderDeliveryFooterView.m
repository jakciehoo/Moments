//
//  HooMoneyFooterView.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooOrderDeliveryFooterView.h"

@interface HooOrderDeliveryFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *deliver_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *delivery_numberLabel;

@end


@implementation HooOrderDeliveryFooterView

- (void)setDelivery_price:(NSString *)delivery_price
{
    _delivery_price = delivery_price;
    self.deliver_priceLabel.text = delivery_price;
}

- (void)setDelivery_number:(NSString *)delivery_number
{
    _delivery_number = delivery_number;
    self.delivery_numberLabel.text = delivery_number;
}


+ (instancetype)orderDeliveryFooterView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HooOrderDeliveryFooterView" owner:nil options:nil] lastObject];
    
}

@end
