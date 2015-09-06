//
//  HooBadgeView.m
//  HooWeibo
//
//  Created by HooJackie on 15/7/25.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooBadgeView.h"
#import "UIView+Extension.h"

#define HooBadgeViewFont [UIFont systemFontOfSize:11]

@implementation HooBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        // 设置字体大小
        self.titleLabel.font = HooBadgeViewFont;
        
        [self sizeToFit];
    }
    return self;
}

//重写badgeValue 的set方法
- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    //如何显示的数字为0或者为空时隐藏
    if (badgeValue.length == 0 || [badgeValue isEqualToString:@"0"]) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    
    CGSize size = [badgeValue sizeWithAttributes:@{NSFontAttributeName:HooBadgeViewFont}];
    if (size.width > self.width) {
        [self setImage:[UIImage imageNamed:@"new_dot"] forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        [self setImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        [self setTitle:badgeValue forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    }
}

@end
