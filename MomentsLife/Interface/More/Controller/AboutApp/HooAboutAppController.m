//
//  HooAboutAppController.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/19.
//  Copyright © 2015年 jackieHoo. All rights reserved.
//

#import "HooAboutAppController.h"

@interface HooAboutAppController ()

@end

@implementation HooAboutAppController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *bundleDirectory = [[NSBundle mainBundle] bundlePath];
    
    NSString *filePath = [bundleDirectory stringByAppendingPathComponent:@"AboutApp/AboutApp.htm"];
    NSString *htmlPath = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlPath baseURL:[NSURL URLWithString:filePath]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
