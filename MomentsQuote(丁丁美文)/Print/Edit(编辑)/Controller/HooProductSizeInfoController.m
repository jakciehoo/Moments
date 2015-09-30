//
//  HooProductSizeInfoController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/30.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooProductSizeInfoController.h"
#import "UIImageView+WebCache.h"

@interface HooProductSizeInfoController ()

@property (nonatomic, weak)UIImageView *sizeInfoImageView;

@end

@implementation HooProductSizeInfoController

- (UIImageView *)sizeInfoImageView
{
    if (_sizeInfoImageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [imageView clipsToBounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.view addSubview:imageView];
        _sizeInfoImageView = imageView;
    }
    return _sizeInfoImageView;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];

}
- (void)setupView
{

    self.view.backgroundColor = HooColor(248, 248, 248);
    
    //self.navigationController.navigationBar.tintColor = HooColor(234, 81, 96);
    //self.navigationController.navigationBar.backgroundColor = HooColor(234, 81, 96);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ay_table_close"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self updateView];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] init];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [swipe addTarget:self action:@selector(back)];
    [self.view addGestureRecognizer:swipe];
}

- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)updateView
{
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [indicatorView startAnimating];
    indicatorView.hidesWhenStopped = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicatorView];
    [self.sizeInfoImageView sd_setImageWithURL:self.product_size_infoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            [indicatorView stopAnimating];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(updateView)];
        }
    }];
    
}






@end
