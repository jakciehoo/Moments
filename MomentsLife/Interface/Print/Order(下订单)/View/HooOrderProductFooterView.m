//
//  HooOderHeaderView.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import "HooOrderProductFooterView.h"
#import "OrderedProduct.h"
#import "UIImageView+WebCache.h"
#import "UIView+AutoLayout.h"
#import "HooOrderedProductManager.h"

@interface HooOrderProductFooterView ()

@property (weak, nonatomic) IBOutlet UIImageView *designedImageView;

@property (weak, nonatomic) IBOutlet UILabel *product_nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *product_modelLabel;

@property (weak, nonatomic) IBOutlet UILabel *product_countLabel;

@property (weak, nonatomic) IBOutlet UILabel *product_priceLabel;

@property (weak, nonatomic)UIActivityIndicatorView *indicator;


@end

@implementation HooOrderProductFooterView

- (void)setOrderedProduct:(OrderedProduct *)orderedProduct
{
    if (orderedProduct == nil) {
        return;
    }
    _orderedProduct = orderedProduct;
    
    self.product_nameLabel.text = orderedProduct.product_name;
    NSString *total_mdoel_name = [NSString stringWithFormat:@"%@ %@ %@",orderedProduct.model_name,orderedProduct.group_name,orderedProduct.color_name];
    if (orderedProduct.size_value) {
        total_mdoel_name = [total_mdoel_name stringByAppendingString:orderedProduct.size_value];
    }
    self.product_modelLabel.text = total_mdoel_name;
    self.product_countLabel.text = [NSString stringWithFormat:@"%ld",(long)orderedProduct.product_inventory_count];
    self.product_priceLabel.text = orderedProduct.product_price;

    if (self.orderedProduct_thumbImage) {
        self.designedImageView.image = self.orderedProduct_thumbImage;
        [self.indicator stopAnimating];
    }else{
        if (orderedProduct.designed_thumbImage_filename.length) {
            [[HooOrderedProductManager manager] downloadImageWithFilename:orderedProduct.designed_thumbImage_filename Withblock:^(BOOL isSuccessful, NSError *error, NSString *filepath) {
                if (isSuccessful) {
                    NSData *imageData = [NSData dataWithContentsOfFile:filepath];
                    UIImage *thumbImage = [UIImage imageWithData:imageData];
                    self.designedImageView.image = thumbImage;
                    [self.indicator stopAnimating];
                }
                
            } andProgress:^(CGFloat progress) {
                HooLog(@"%f",progress);
            }];
            
        }
    }

}

+ (instancetype)orderProductFooterView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HooOrderProductFooterView" owner:nil options:nil] lastObject];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.designedImageView addSubview:indicator];
    [indicator autoCenterInSuperview];
    [indicator startAnimating];
    indicator.hidesWhenStopped = YES;
    _indicator = indicator;
}


@end
