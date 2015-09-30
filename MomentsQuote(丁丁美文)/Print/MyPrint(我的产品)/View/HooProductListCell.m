//
//  HooProductListCell.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/24.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooProductListCell.h"
#import "HooLabel.h"
#import "UIImageView+WebCache.h"
#import "HooProduct.h"

@interface HooProductListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *prodcutImageView;

@property (weak, nonatomic) IBOutlet HooLabel *productLabel;

@end

@implementation HooProductListCell


- (void)setProduct:(HooProduct *)product
{
    _product = product;
    self.productLabel.text = product.product_name;

    NSURL *icon_url = [NSURL URLWithString:product.product_icon];
    [self.prodcutImageView sd_setImageWithURL:icon_url placeholderImage:[UIImage imageNamed:@"gridempty"]];

    
}


- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
