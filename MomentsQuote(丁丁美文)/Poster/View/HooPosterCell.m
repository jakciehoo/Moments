//
//  HooPosterCell.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/13.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooPosterCell.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "UIImage+Utility.h"
#import "NSDate+Extension.h"

@interface HooPosterCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;

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

}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
