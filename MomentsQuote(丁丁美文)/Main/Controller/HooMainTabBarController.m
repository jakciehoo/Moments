//
//  HooMainTabBarController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooMainTabBarController.h"
#import "HooHomeViewController.h"
#import "HooPosterViewController.h"
#import "HooQuotesViewController.h"
#import "HooMomentsViewController.h"
#import "HooMoreViewController.h"
#import "HooMainNavigationController.h"

@interface HooMainTabBarController ()

@property (nonatomic, strong) UIColor *centerButtonColor;
@property (nonatomic, weak) UIView *hooTabBar;
@property (nonatomic, weak) UIButton *centerButton;

@end

@implementation HooMainTabBarController

#pragma mark - 懒加载

//中心按钮的颜色
- (UIColor *)centerButtonColor
{
    if (_centerButtonColor == nil) {
        _centerButtonColor = [UIColor grayColor];
    }
    return _centerButtonColor;
}
//懒加载初始化中心按钮并添加到view上
- (UIButton *)centerButton
{
    if (_centerButton == nil) {
        UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        centerButton.backgroundColor = self.centerButtonColor;
        centerButton.layer.cornerRadius = 40;
        centerButton.layer.borderColor = [UIColor whiteColor].CGColor;
        centerButton.layer.borderWidth = 1.0;
        centerButton.showsTouchWhenHighlighted = YES;
        //添加在view上
        [self.view addSubview:centerButton];
        _centerButton = centerButton;
        [self setupCenterButtonConstraint];
    }
    return _centerButton;
}
//设置中心tabBar按钮的约束
- (void)setupCenterButtonConstraint
{
    _centerButton.translatesAutoresizingMaskIntoConstraints = NO;
    //宽高约束
    [_centerButton addConstraints:@[
                            [NSLayoutConstraint constraintWithItem:_centerButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80],
                            [NSLayoutConstraint constraintWithItem:_centerButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80],
                            ]];
    
    //与父控件水平对齐 底部距离为18
    [self.view addConstraints:@[
                                
                                //view1 constraints
                                [NSLayoutConstraint constraintWithItem:_centerButton
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:_centerButton
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:18],
                                
                                
                                ]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = HooColor(38, 86, 134);
    //调用centerButton并初始化，添加事件
    [self.centerButton addTarget:self action:@selector(centerBtnClicked) forControlEvents:UIControlEventTouchDown];
    //添加子控件
    [self setupAllChildViewController];
    
}
- (void)centerBtnClicked
{
    self.selectedIndex = 2;
}


#pragma mark - 添加子控制器
- (void)setupAllChildViewController
{
    //创作海报
    HooPosterViewController *poster = [[HooPosterViewController alloc] init];
    [self addChildVc:poster withImageName:@"tb_poster_flat" title:@"DIY"];
    HooQuotesViewController *quotes = [[HooQuotesViewController alloc] init];
    [self addChildVc:quotes withImageName:@"tb_grid_flat" title:@"美文"];
    
    HooHomeViewController *home = [[HooHomeViewController alloc] init];
    [self addChildVc:home withImageName:nil title:nil];
    
    HooMomentsViewController *Moments = [[HooMomentsViewController alloc] init];
    [self addChildVc:Moments withImageName:@"tb_pinterest" title:@"丁丁"];
    
    HooMoreViewController *profile = [[HooMoreViewController alloc] init];
    [self addChildVc:profile withImageName:@"tb_more_flat" title:@"更多"];
    
}

- (void)addChildVc:(UIViewController *)childVc withImageName:(NSString *)imageName title:(NSString *)title
{
    if (title) {
        
        childVc.title = title;
    }
    if (imageName) {
        
        childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    }
    
    HooMainNavigationController *navi = [[HooMainNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:navi];
}

@end
