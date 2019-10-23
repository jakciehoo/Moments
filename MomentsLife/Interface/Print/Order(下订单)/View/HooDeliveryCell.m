//
//  HooDeliveryCell.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/9.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooDeliveryCell.h"
#import "OrderDelivery.h"
#import "Order.h"

@interface HooDeliveryCell ()
@property (weak, nonatomic) IBOutlet UILabel *delivery_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *delivery_numberLabel;

@end

@implementation HooDeliveryCell

- (void)setDelivery:(OrderDelivery *)delivery
{
    _delivery = delivery;
    self.delivery_nameLabel.text = delivery.delivery_name;
}
- (void)setOrder:(Order *)order
{
    _order = order;
    self.delivery_numberLabel.text = order.delivery_number;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
