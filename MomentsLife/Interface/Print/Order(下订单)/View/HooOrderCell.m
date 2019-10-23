//
//  HooOrderCell.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/9.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooOrderCell.h"
#import "Order.h"

@interface HooOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *order_idLabel;
@property (weak, nonatomic) IBOutlet UILabel *order_stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *order_total_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *order_countLabel;
@end

@implementation HooOrderCell

- (void)setOrder:(Order *)order
{
    _order = order;
    self.order_idLabel.text = order.objectId;
    self.order_countLabel.text = [NSString stringWithFormat:@"%ld",(long)order.order_count];
    self.order_total_priceLabel.text = order.total_price;
    self.order_stateLabel.text = self.order.order_status;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
