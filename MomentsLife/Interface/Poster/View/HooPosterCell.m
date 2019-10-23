//
//  HooPosterCell.m
//  MomentsLife
//
//  Created by HooJackie on 15/8/13.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooPosterCell.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "UIImage+Utility.h"
#import "NSDate+Extension.h"
#import "UIImageView+WebCache.h"
#import "OrderedProduct.h"

@interface HooPosterCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation HooPosterCell


- (void)setMyMoment:(HooMoment *)myMoment
{
    _myMoment = myMoment;
    NSString *image_thumbName = myMoment.photo.image_thumb_filename;
    UIImage *image = [UIImage imageForPhotoName:image_thumbName];
    self.posterImageView.image = image;
    NSString *author = myMoment.author;
    NSString *readableTime = [NSDate readableTimeFromIntervalString:myMoment.created_date];
    self.titleLabel.text = [NSString stringWithFormat:@"作者:%@  创建时间:%@",author,readableTime];
    [self.indicator stopAnimating];
}

- (void)setOrderedProduct:(OrderedProduct *)orderedProduct
{
    _orderedProduct = orderedProduct;
    NSString *total_mdoel_name = [NSString stringWithFormat:@"款式：%@ %@ %@ 创建时间:%@",orderedProduct.model_name,orderedProduct.group_name,orderedProduct.color_name,orderedProduct.createdAt];
    self.titleLabel.text =  total_mdoel_name;
    NSURL *imageURL = [NSURL URLWithString:orderedProduct.designed_image_url];
    [self.posterImageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.indicator stopAnimating];
    }];
}



- (void)awakeFromNib {
    // Initialization code
    [self.indicator startAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
