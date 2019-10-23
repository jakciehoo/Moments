//
//  HooProductModelInfoController.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/1.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooProductInfoController.h"
#import "UIImageView+WebCache.h"

@interface HooProductInfoController ()

@property (nonatomic, weak)UIImageView *sizeInfoImageView;

@property (nonatomic, weak)UIScrollView *scrollView;

@end

@implementation HooProductInfoController

- (UIImageView *)sizeInfoImageView
{
    if (_sizeInfoImageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [imageView clipsToBounds];
        imageView.contentMode = UIViewContentModeTop;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.scrollView addSubview:imageView];
        _sizeInfoImageView = imageView;
    }
    return _sizeInfoImageView;
}
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
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
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = HooColor(234, 81, 96);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"t_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
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
    if (!self.infoURL) {
        return;
    }
    [self.sizeInfoImageView sd_setImageWithURL:self.infoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            CGSize imageSize = image.size;
            CGFloat ratio = self.view.width / imageSize.width;
            CGFloat height = ratio * imageSize.height;
            CGSize newSize = CGSizeMake(self.view.width, height);
            self.sizeInfoImageView.size = newSize;
            self.scrollView.contentSize = newSize;
            [indicatorView stopAnimating];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(updateView)];
        }
    }];
    
}



@end
