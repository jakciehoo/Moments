//
//  HooMainNavigationController.m
//  MomentsLife
//
//  Created by HooJackie on 15/8/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooMainNavigationController.h"

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
        
    viewController.hidesBottomBarWhenPushed = YES;
}




@end
