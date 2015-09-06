//
//  HooMainNavigationController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooMainNavigationController.h"
#import "HooMainTabBarController.h"
#import "HooTabBar.h"

@interface HooMainNavigationController ()

@end

@implementation HooMainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.tintColor = HooColor(38, 86, 134);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    [super pushViewController:viewController animated:animated];
    if (self.viewControllers.count > 1) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
}




@end
