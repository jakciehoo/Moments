//
//  HooEditToolView.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/22.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HooEditToolView;

@protocol HooEditToolViewDelegate <NSObject>
- (void)choosedColor:(UIColor *)color;
- (void)choosedFont:(NSString *)fontName;
- (void)choosedFilter:(NSString *)filterName;
- (void)toolButtonClicked;

@end

@interface HooEditToolView : UIView
@property (nonatomic, strong) UIImage *filterImage;
@property (nonatomic, weak) id<HooEditToolViewDelegate> delegate;

@end
