//
//  HooWebViewBaseController.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/19.
//  Copyright © 2015年 jackieHoo. All rights reserved.
//

#import "HooWebViewBaseController.h"

@interface HooWebViewBaseController ()<UIWebViewDelegate>

@property (nonatomic, weak)UIActivityIndicatorView *indicatorView;

@end

@implementation HooWebViewBaseController

- (instancetype)init
{
    if (self = [super initWithNibName:@"HooWebViewBaseController" bundle:nil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [indicatorView startAnimating];
    indicatorView.hidesWhenStopped = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicatorView];
    _indicatorView = indicatorView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicatorView stopAnimating];
}


@end
