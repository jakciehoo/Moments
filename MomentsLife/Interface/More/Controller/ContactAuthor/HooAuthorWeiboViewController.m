//
//  HooAuthorWeiboViewController.m
//  MomentsLife
//
//  Created by HooJackie on 15/8/10.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooAuthorWeiboViewController.h"

@interface HooAuthorWeiboViewController ()


@end

@implementation HooAuthorWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSURL *url = [NSURL URLWithString:@"http://weibo.com/hooyoo"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
