//
//  HooQuotesCell.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/25.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooQuotesCell.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "HooInsetsLabel.h"
#import "HooSqlliteTool.h"

@interface HooQuotesCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet HooInsetsLabel *cellQuotesLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIButton *starButton;

@end

@implementation HooQuotesCell
//重写set方法，当设置值时，我们设置控件的内容
- (void)setMoment:(HooMoment *)moment
{
    _moment = moment;

    
    NSString *imageName = moment.photo.image_thumb_filename;
    self.cellImageView.image = [UIImage imageNamed:imageName];
    self.cellQuotesLabel.text = moment.quote;
    if (moment.photo.isFavorite == YES) {
        self.starButton.selected = YES;
    }else{
        self.starButton.selected = NO;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.cellQuotesLabel.alpha = 0.5;
        self.cellImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.indicator stopAnimating];
    }];

}

- (void)awakeFromNib {
    //设置cellQuotesLabel的内边距
    self.cellQuotesLabel.insets = UIEdgeInsetsMake(0, 5, 0, 5);

}

#pragma mark -  star按钮方法 选中收藏，取消选中取消收藏
- (IBAction)starFavi:(UIButton *)sender {
    self.starButton.selected = !self.starButton.selected;
    self.moment.photo.isFavorite = self.starButton.selected;
    [HooSqlliteTool updateMoment:self.moment];
}

@end
