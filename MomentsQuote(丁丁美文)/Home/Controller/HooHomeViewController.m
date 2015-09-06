//
//  HooHomeViewController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/15.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooHomeViewController.h"
#import "HooQuoteView.h"
#import "HooEditToolView.h"
#import "HooFlowerButton.h"


@interface HooHomeViewController ()
@property (nonatomic, weak) UIButton *camaraButton;
@property (nonatomic, weak) UIButton *surpriseButton;
@end

@implementation HooHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGPoint randomOrigin = CGPointMake(arc4random() % (NSUInteger)([UIScreen mainScreen].bounds.size.width - self.quoteView.width), arc4random() % (NSUInteger)([UIScreen mainScreen].bounds.size.height - self.quoteView.height - 50));
    self.quoteView.origin = randomOrigin;
    
}
- (NSArray *)createOtherViewsIn:(UIView *)superView aboveView:(UIView *)blackView
{
   NSMutableArray *mutableArr  = [NSMutableArray array];
   NSArray *viewArray = [super createOtherViewsIn:superView aboveView:blackView];
    
    //supriseButton
    UIButton *surpriseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 80, 25)];
    [surpriseButton setBackgroundImage:[UIImage imageNamed:@"surpriseme_flat"] forState:UIControlStateNormal];
    [surpriseButton setTitle:@"自动生成" forState:UIControlStateNormal];
    surpriseButton.titleLabel.font = [UIFont systemFontOfSize:10];
    surpriseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [surpriseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    surpriseButton.backgroundColor = [UIColor whiteColor];
    surpriseButton.layer.cornerRadius = 12.5;
    [superView insertSubview:surpriseButton aboveSubview:blackView];
    _surpriseButton = surpriseButton;
    [surpriseButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [surpriseButton autoSetDimensionsToSize:CGSizeMake(80, 25)];
    NSLayoutConstraint *supriseBottom = [surpriseButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:superView];
    //camButton
    UIButton *camaraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 80, 25)];
    [camaraButton setBackgroundImage:[UIImage imageNamed:@"surprisecam_flat"] forState:UIControlStateNormal];
    [camaraButton setTitle:@"相机相册" forState:UIControlStateNormal];
    camaraButton.titleLabel.font = [UIFont systemFontOfSize:10];
    camaraButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [camaraButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    camaraButton.backgroundColor = [UIColor whiteColor];
    camaraButton.layer.cornerRadius = 12.5;
    [superView insertSubview:camaraButton aboveSubview:blackView];
    _camaraButton = camaraButton;
    
    [camaraButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [camaraButton autoSetDimensionsToSize:CGSizeMake(80, 25)];
    NSLayoutConstraint *camaraBottom = [camaraButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:superView];
    
    [superView layoutIfNeeded];
    
    [superView removeConstraint:camaraBottom];
    [superView removeConstraint:supriseBottom];
    
    
    [camaraButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [surpriseButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    
    
    //移除约束
    
    [UIView animateWithDuration:1.0 animations:^{
        
        [superView layoutIfNeeded];
        
    }];
    
    [mutableArr addObject:surpriseButton];
    [mutableArr addObject:camaraButton];
    [mutableArr addObjectsFromArray:viewArray];
    return mutableArr;
}
/*
 UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 320, 300)];
 
 testLabel.backgroundColor = [UIColor lightGrayColor];
 
 testLabel.textAlignment = NSTextAlignmentCenter;
 testLabel.numberOfLines = 0;
 
 
 NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试"];
 
 [AttributedStr addAttribute:NSFontAttributeName
 
 value:[UIFont systemFontOfSize:16.0]
 
 range:NSMakeRange(2, 2)];
 
 [AttributedStr addAttribute:NSForegroundColorAttributeName
 
 value:[UIColor redColor]
 
 range:NSMakeRange(2, 2)];
 [AttributedStr addAttribute:NSBackgroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, AttributedStr.length)];
 
 NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
 paragraphStyle.lineSpacing = 18;
 paragraphStyle.maximumLineHeight = 20;
 paragraphStyle.minimumLineHeight = 20;
 [AttributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, AttributedStr.length)];
 
 testLabel.attributedText = AttributedStr;
 
 [self.view addSubview:testLabel];
 */



@end
