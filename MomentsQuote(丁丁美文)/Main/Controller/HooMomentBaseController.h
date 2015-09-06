//
//  HooHomeViewController.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/15.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HooFlowerButton.h"
@class HooMoment;
@class HooQuoteView;

@interface HooMomentBaseController : UIViewController<HooFlowerButtonDelegate>

@property (nonatomic, strong) HooMoment *moment;

@property (nonatomic, weak) HooQuoteView *quoteView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) HooFlowerButton *centerButton;
@property (nonatomic, strong) UIColor *imageColor;
@end
