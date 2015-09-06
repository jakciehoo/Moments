//
//  HooAuthorWeiboViewController.m
//  MomentsQuote(丁丁美文)
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
    // Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];

    
    NSURL *url = [NSURL URLWithString:@"http://weibo.com/hooyoo"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
