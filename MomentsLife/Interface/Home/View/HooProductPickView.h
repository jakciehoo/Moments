//
//  HooProductPickView.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/14.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>



@class HooProduct;

@protocol HooProductPickViewDelegate <NSObject>

@optional
- (void)pickerDidSelectProduct:(HooProduct *)product;

@end

@interface HooProductPickView : UIView

@property (assign, nonatomic) id <HooProductPickViewDelegate> delegate;


- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
