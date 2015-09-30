//
//  HooMainTabBarController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooMainTabBarController.h"
#import "HooHomeViewController.h"
#import "HooMyPostersController.h"
#import "HooQuotesViewController.h"
#import "HooMyPrintPostersController.h"
#import "HooMoreViewController.h"
#import "HooMainNavigationController.h"
#import "HooTabBar.h"
#import "HooFlowerButton.h"

@interface HooMainTabBarController ()<HooTabBarDelegate,UINavigationControllerDelegate>
{
    BOOL _tabBarIsShow;
}

@property (nonatomic, strong) NSMutableArray *items;
/**
 *  自定义的HooTabBar
 */
@property (nonatomic, weak) HooTabBar *hooTabBar;


@property (weak, nonatomic) HooHomeViewController *home;

@property (weak, nonatomic) NSLayoutConstraint *tabBarbottomConstraint;

@end

@implementation HooMainTabBarController

#pragma mark - 懒加载
- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}


#pragma mark - view初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];

    //添加子控件
    [self setupAllChildViewController];
    // 自定义tabBar
    HooTabBar *tabBar = [[HooTabBar alloc] initWithFrame:self.tabBar.bounds];
    tabBar.tintColor = HooTintColor;
    tabBar.items = self.items;
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    
    [tabBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [tabBar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    NSLayoutConstraint *tabBarbottomConstraint = [tabBar autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    self.tabBarbottomConstraint = tabBarbottomConstraint;
    
    [tabBar autoSetDimension:ALDimensionHeight toSize:49];
    self.hooTabBar = tabBar;
    //传值
    self.home.centerButton = self.hooTabBar.centerButton;

    
    [self.tabBar removeFromSuperview];
    
    self.selectedIndex = 2;
        [NSTimer scheduledTimerWithTimeInterval:HooDuration * 5 target:self selector:@selector(hideTabBar) userInfo:nil repeats:NO];
}
- (void)hideTabBar
{
    if (self.selectedIndex == 2) {
        
        [self.view removeConstraint:_tabBarbottomConstraint];
        
        _tabBarbottomConstraint = [self.hooTabBar autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-50];
        [UIView animateWithDuration:1.0 animations:^{
            
            [self.view layoutIfNeeded];
            
        }];
    }

}

//隐藏或显示自定义tabbar的动画
- (void)showOrHideTabBar
{
    if (self.hooTabBar.centerButton.currentState == HooFlowerButtonsStateOpened) {
        [self.view removeConstraint:_tabBarbottomConstraint];
        
        _tabBarbottomConstraint = [self.hooTabBar autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-50];
        [UIView animateWithDuration:HooDuration/2 animations:^{
            
            [self.view layoutIfNeeded];
            
        }];
    }else{
        [self.view removeConstraint:_tabBarbottomConstraint];
        
        _tabBarbottomConstraint = [self.hooTabBar autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [UIView animateWithDuration:HooDuration/2 animations:^{
            
            [self.view layoutIfNeeded];
            
        }];
    }
}

#pragma mark - 添加子控制器
- (void)setupAllChildViewController
{
    //创作海报
    HooMyPostersController *poster = [[HooMyPostersController alloc] init];
    [self addChildVc:poster withImageName:@"tb_edit_flat" title:@"丁丁记"];
    
    HooQuotesViewController *quotes = [[HooQuotesViewController alloc] init];
    [self addChildVc:quotes withImageName:@"tb_grid_flat" title:@"发现"];
    
    HooHomeViewController *home = [[HooHomeViewController alloc] init];
    [self addChildVc:home withImageName:nil title:nil];
    _home = home;
    
    
    
    HooMyPrintPostersController *print = [[HooMyPrintPostersController alloc] init];
    [self addChildVc:print withImageName:@"tb_poster_flat" title:@"丁丁印"];
    
    HooMoreViewController *profile = [[HooMoreViewController alloc] init];
    [self addChildVc:profile withImageName:@"tb_more_flat" title:@"更多"];
    
}
- (void)addChildVc:(UIViewController *)childVc withImageName:(NSString *)imageName title:(NSString *)title
{
    childVc.tabBarItem.title = title;

    if (imageName) {
        
        UIImage *image = [UIImage imageNamed:imageName];
        childVc.tabBarItem.image = image;
        //根据tintColor设置按钮的选中时的图片
        childVc.tabBarItem.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    [self.items addObject:childVc.tabBarItem];
    
    UINavigationController *navi = [[HooMainNavigationController alloc] initWithRootViewController:childVc];
    navi.delegate = self;
    [self addChildViewController:navi];
}

#pragma mark - HooTabBarDelegate

- (void)tabBar:(HooTabBar *)tabBar didClickButton:(NSInteger)index
{
    self.selectedIndex = index;
}


#pragma mark - UINavigationControllerDelegate 这里我们用来当 push的时候的隐藏tabBar动画

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navController.viewControllers.count > 1)
    {   //隐藏，向左移动
        if (!_tabBarIsShow) return;

         [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                        self.hooTabBar.transform = CGAffineTransformMakeTranslation(-self.hooTabBar.width * 2, 0);
                                        } completion:^(BOOL finished) {
                                            _tabBarIsShow = NO;
                                        }];
        
    }else{
        //显示，向右还原
        if (_tabBarIsShow) return;
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.hooTabBar.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                             _tabBarIsShow = YES;
                         }];
    }
    
}


@end
