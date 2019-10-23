//
//  HooMainTabBarController.m
//  MomentsLife
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
#import "HooVersionTool.h"

@interface HooMainTabBarController ()<HooTabBarDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
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

    self.selectedIndex = 2;
    [NSTimer scheduledTimerWithTimeInterval:HooDuration * 5 target:self selector:@selector(hideTabBar) userInfo:nil repeats:NO];
    //检查新版本
    [self checkNewVersion];
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

- (void)hidesTabBar:(BOOL)hidden{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height, view.frame.size.width , view.frame.size.height)];
                
            }else{
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 49, view.frame.size.width, view.frame.size.height)];
                
            }
        }else{
            if([view isKindOfClass:NSClassFromString(@"UITransitionView")]){
                if (hidden) {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
                    
                }else{
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 49 )];
                    
                }
            }
        }
    }
    [UIView commitAnimations];
    
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
- (void)checkNewVersion
{
    [HooVersionTool getAppVersionWithBlock:^(NSString *versionStr, NSError *error) {
        if (versionStr.length) {
            NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [appInfo objectForKey:@"CFBundleShortVersionString"];
            if (![currentVersion isEqualToString:versionStr]) {
                NSString *message = [NSString stringWithFormat:@"检测到新版本，版本：%@，是否升级？", versionStr];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有新版可以更新" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
                [alert show];
            }
        }
    }];
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //https://itunes.apple.com/us/app/ding-ding-yin-ji-momentslife/id1049879738?ls=1&mt=8
        NSString *urlToOpen = @"itms-apps://itunes.apple.com/cn/app/ding-ding-yin-ji-momentslife/id1049879738?ls=1&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
    }
    
}


@end
