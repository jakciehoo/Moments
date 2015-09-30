//
//  HooQuoteController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/27.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooQuoteController.h"
#import "HooFlowerButton.h"

@interface HooQuoteController ()

@property (nonatomic, weak)NSLayoutConstraint *centerButtonBottomConstraint;



@end

@implementation HooQuoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化视图
    [self setupView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)setupView
{
    //添加导航按钮
    UIButton *naviBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [naviBack setImage:[UIImage imageNamed:@"corner_back_flat"] forState:UIControlStateNormal];
    [naviBack addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:naviBack];
    [naviBack autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
    [naviBack autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8];
    [naviBack autoSetDimensionsToSize:CGSizeMake(40, 40)];
    
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
    //手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissController)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.imageView addGestureRecognizer:swipe];

}



- (void)dismissController
{
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
