//
//  HooHomeViewController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/15.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooMomentBaseController.h"
#import "HooQuoteView.h"
#import "HooEditToolView.h"
#import "UIImage+Utility.h"
#import "HooMainTabBarController.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "UIColor+Extension.h"
#import "HooSqlliteTool.h"



@interface HooMomentBaseController ()<HooEditToolViewDelegate>

@property (nonatomic, weak) UIView *blackView;

@property (nonatomic, weak) HooEditToolView *toolView;

@property (nonatomic, weak) NSLayoutConstraint *toolTop;
@end

@implementation HooMomentBaseController

- (HooMoment *)moment
{
    if (_moment == nil) {
        _moment = [HooSqlliteTool momentWithID:1];
        
    }
    return _moment;
}

- (HooQuoteView *)quoteView
{
    if (_quoteView == nil) {
        HooQuoteView *quoteView = [HooQuoteView quoteView];
        
        [self.view addSubview:quoteView];
        _quoteView= quoteView;
    }
    return _quoteView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //设置imageView
    UIImage *image = [UIImage imageNamed:self.moment.photo.image_filename];
    self.imageView.image = image;
    self.imageView.clipsToBounds = YES;
    
    //设置背景颜色
    [self setBackgroudColorForViews];
    //设置文字容器
    self.quoteView.moment = self.moment;

    
    self.centerButton.delegate = self;
    //给视图添加单击手势和事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHideButtons)];
    [self.view addGestureRecognizer:tap];
    
    //监听imageview的image属性变化
    [self addObserver:self
           forKeyPath:@"imageView.image"
              options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
              context:nil];
    //监听程序进入后台调用的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMoment) name:UIApplicationDidEnterBackgroundNotification object:nil];


}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBackgroudColorForViews];
    

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.centerButton.backgroundColor = HooColor(211, 211, 211);
    
    
}
#pragma mark - 观察者调用方法
//这里我们观察iamgeview.image属性值改变来设置中心按钮的背景颜色
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"imageView.image"]) {
        [self setBackgroudColorForViews];
    }
    
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - 控制器view单击时调用的方法
//用于关闭和显示按钮等子视图
- (void)tapToHideButtons
{

    [self.centerButton showOrHideSubviews];

}
#pragma mark - 保存当前的美文美图到数据库
- (void)saveMoment
{
    [HooSqlliteTool updateMoment:self.moment];
}
#pragma mark - 获取图片中的主色调，并设置给中心按钮
- (void)setBackgroudColorForViews
{
    self.imageColor = [self.imageView.image  mostColorFromImage];
    self.centerButton.backgroundColor = self.imageColor;
    self.quoteView.quoteBgColor = self.imageColor;
}



#pragma mark - FlowerButtonDelegate
//弹出字按钮的个数
- (NSInteger)flowerButtonNumberOfItems:(HooFlowerButton *)flowerButton
{
    return 4;
}

//设置字按钮的图片
//大小建议为 30 * 30
- (UIImage *)flowerButton:(HooFlowerButton *)flowerButton imageForItemAtIndex:(NSInteger)index
{
    NSString *imageName = [NSString stringWithFormat:@"fbi_flat_%ld",index+1];
    return  [UIImage imageNamed:imageName];
}


//设置字按钮的标题
- (NSString *)flowerButton:(HooFlowerButton *)flowerButton titleForItemAtIndex:(NSInteger)index
{
    NSArray *titleArr = @[@"分享",@"提醒",@"下一张",@"拍照"];
    
    return titleArr[index];
}
//选种子按钮触发事件
- (void)flowerButton:(HooFlowerButton*)flowerButton
          didSelectItem:(HooFlowerItem*)item
{
    
}

- (BOOL)showOtherViews
{
    return YES;
}
- (NSArray *)createOtherViewsIn:(UIView *)superView aboveView:(UIView *)blackView
{
    
    self.blackView = blackView;
    NSMutableArray *viewArray = [NSMutableArray array];
    //tooView
    HooEditToolView *tool = [[HooEditToolView alloc] initWithFrame:CGRectMake(0, -50, 150, 50)];
    tool.filterImage = self.imageView.image;
    tool.delegate = self;
    [superView insertSubview:tool aboveSubview:blackView];
    _toolView = tool;
    
    [tool autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [tool autoSetDimensionsToSize:CGSizeMake(150, 50)];
    NSLayoutConstraint *bottomToTop = [tool autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:superView];
    
    
    
       //更新约束
    [superView layoutIfNeeded];
    //移除约束

    [superView removeConstraint:bottomToTop];

    _toolTop = [tool autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
    [UIView animateWithDuration:HooDuration animations:^{
        
        [superView layoutIfNeeded];
        
    }];
    
    [viewArray addObject:tool];

    return viewArray;
}
- (void)flowerButtonDidClicked:(HooFlowerButton *)flowerButton
{
    if ([self.tabBarController isKindOfClass:[HooMainTabBarController class]]) {
        HooMainTabBarController *tabCtrl  = (HooMainTabBarController *)self.tabBarController;
        [tabCtrl showOrHideTabBar];
    }
}


#pragma mark - HooEditToolViewDelegate
- (void)choosedColor:(UIColor *)color
{
    self.quoteView.quoteColor = color;

    NSArray *components = [color getRGBComponents];
    self.moment.fontColorR = [components[0] floatValue];
    self.moment.fontColorG = [components[1] floatValue];
    self.moment.fontColorB = [components[2] floatValue];
    [self saveMoment];
    
}


- (void)choosedFont:(NSString *)fontName
{
    self.quoteView.quoteFontName = fontName;
    self.moment.fontName = fontName;
}
- (void)choosedFilter:(NSString *)filterName
{
    //给图片添加滤镜
    CIImage *inputCIImage = [[CIImage alloc] initWithImage:self.imageView.image];
    CIFilter *filter = [CIFilter filterWithName:filterName];
    
    [filter setValue:inputCIImage forKey:kCIInputImageKey];
    CIImage *outputCIImage = [filter outputImage];
    CGRect extent = [outputCIImage extent];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputCIImage fromRect:extent];
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage];
    self.imageView.image = filteredImage;
}
- (void)toolButtonClicked:(UIButton *)sender
{
    if(self.centerButton.currentState == HooFlowerButtonsStateOpened){
        [self.centerButton hideButtons];

            [UIView animateWithDuration:HooDuration animations:^{
                self.blackView.alpha = 0.0;
            } completion:^(BOOL finished) {
                
                [self.blackView removeFromSuperview];
            }];
    }
    [self.toolView.superview removeConstraint:_toolTop];
    [self.toolView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:100];

}

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"imageView.image"];
}

@end
