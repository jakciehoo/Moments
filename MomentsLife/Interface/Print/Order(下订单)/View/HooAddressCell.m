//
//  HooAddressCell.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooAddressCell.h"
#import "OrderAddress.h"

@interface HooAddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation HooAddressCell

- (void)setAddress:(OrderAddress *)address
{
    _address = address;
    if (address != nil) {
        self.nameLabel.text = address.name;
        self.phoneNumberLabel.text = address.phone_number;
        self.addressLabel.text = [NSString stringWithFormat:@"%@  %@",address.country_address,address.detail_address];
    }

    
}

- (void)awakeFromNib {
    // Initialization code
    self.addressLabel.text = @"请先设置收货地址";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
