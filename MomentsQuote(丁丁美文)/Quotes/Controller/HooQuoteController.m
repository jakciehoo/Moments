//
//  HooQuoteController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/27.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooQuoteController.h"
#import "HooFlowerButton.h"
#import "HooEditToolView.h"
#import "HooQuoteView.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "UIImage+Utility.h"
@interface HooQuoteController ()

@property (nonatomic, weak)NSLayoutConstraint *centerButtonBottomConstraint;

@end

@implementation HooQuoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    


    
    //添加中心按钮
    HooFlowerButton *flowerButton = [[HooFlowerButton alloc] initFlowerButtonWithView:self.view showInView:self.view];
    [flowerButton setImage:[UIImage imageNamed:@"flower_button_close"] forState:UIControlStateNormal];
    flowerButton.delegate = self;
    flowerButton.selected = YES;
    [flowerButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    NSLayoutConstraint *centerButtonBottomConstraint = [flowerButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-60];
    self.centerButtonBottomConstraint = centerButtonBottomConstraint;
    [flowerButton autoSetDimensionsToSize:CGSizeMake(80, 80)];
    self.centerButton = flowerButton;
    flowerButton.backgroundColor = self.imageColor;

}


- (IBAction)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 重写FlowerButtonDelegate的方法
- (void)flowerButtonDidClicked:(HooFlowerButton *)flowerButton
{
    if (self.centerButton.currentState == HooFlowerButtonsStateOpened) {
        [self.view removeConstraint:_centerButtonBottomConstraint];
        
        _centerButtonBottomConstraint = [self.centerButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-60];
        [UIView animateWithDuration:1.0 animations:^{
            
            [self.view layoutIfNeeded];
            
        }];
    }else{
        [self.view removeConstraint:_centerButtonBottomConstraint];
        
        _centerButtonBottomConstraint = [self.centerButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
        [UIView animateWithDuration:1.0 animations:^{
            
            [self.view layoutIfNeeded];
            
        }];
    }
}
@end
