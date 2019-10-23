//
//  HooEditToolView.m
//  MomentsLife
//
//  Created by HooJackie on 15/8/22.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooEditToolView.h"
#import "CMPopoverView.h"
#import "UIImage+Utility.h"

@interface HooEditToolView ()<CMPopoverViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *fonts;
@property (nonatomic, strong) NSArray *filters;
@property (nonatomic, strong) NSArray *filterNames;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSMutableArray *filterButtons;
@property (nonatomic, strong) NSMutableArray *fontButtons;
@property (nonatomic, strong) NSMutableArray *colorButtons;
@property (nonatomic, weak) CMPopoverView *popView;
@end

@implementation HooEditToolView
#pragma mark - 懒加载
- (NSMutableArray *)fontButtons
{
    if (_fontButtons == nil) {
        _fontButtons = [NSMutableArray array];
        for (int i = 0; i < self.fonts.count; i++) {
            UIButton *fontButton = [[UIButton alloc] initWithFrame:CGRectMake(45 * i, 0, 45, 45)];
            fontButton.tag = i + 200;
            [fontButton setTitle:@"Aa" forState:UIControlStateNormal];
            fontButton.layer.cornerRadius = 10;
            fontButton.clipsToBounds = YES;
            fontButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            fontButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [fontButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [fontButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            fontButton.titleLabel.font = [UIFont fontWithName:self.fonts[i] size:30];
            [fontButton addTarget:self action:@selector(chooseFont:) forControlEvents:UIControlEventTouchUpInside];
            [_fontButtons addObject:fontButton];
        }
    }
    return _fontButtons;
}
- (NSMutableArray *)colorButtons
{
    if (_colorButtons == nil) {
        _colorButtons = [NSMutableArray array];
        for (int i = 0; i < self.colors.count; i++) {
            UIButton *colorButton = [[UIButton alloc] initWithFrame:CGRectMake(45 * i, 0, 40, 40)];
            colorButton.tag = i + 300;
            colorButton.layer.cornerRadius = 10;
            colorButton.clipsToBounds = YES;
            colorButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            colorButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [colorButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [colorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            colorButton.backgroundColor = self.colors[i];
            [colorButton addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
            [_colorButtons addObject:colorButton];
        }
    }
    return _colorButtons;
}


- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
        scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView = scrollView;
        
    }
    return _scrollView;
}

- (NSArray *)fonts
{
    if (_fonts== nil) {
        _fonts = @[ @"American Typewriter", @"Avenir-HeavyOblique", @"Noteworthy-Bold", @"BradleyHandITCTT-Bold",@"Marker Felt", @"Didot-Italic",@"Arial-BoldMT",@"BradleyHandITCTT-Bold",@"Verdana",@"Trebuchet MS",@"Times New Roman",@"Arial Rounded MT Bold",@"Georgia"];
        
    }
    return _fonts;
}
- (NSArray *)filters
{
    if (_filters== nil) {
        _filters = @[@"Default",@"CIColorPosterize",@"CIExposureAdjust",@"CISepiaTone",@"CISRGBToneCurveToLinear",@"CILinearToSRGBToneCurve",@"CIPhotoEffectChrome", @"CIPhotoEffectFade", @"CIPhotoEffectInstant", @"CIColorInvert",@"CIPhotoEffectNoir", @"CIPhotoEffectMono", @"CIPhotoEffectProcess", @"CIPhotoEffectTransfer",@"CIGloom",@"CIGaussianBlur"];
        
    }
    return _filters;
}
- (NSArray *)filterNames
{
    if (_filterNames == nil) {
        _filterNames = @[@"Default",@"Posterize",@"Exposure",@"Sepia",@"Linear",@"SRGBTone",@"Chrome", @"Fade", @"Instant",@"Invert",@"Noir", @"Mono", @"Process", @"Transfer",@"Gloom",@"Gaussian"];
    }
    return _filterNames;
}
- (NSArray *)colors
{
    if (_colors == nil) {
        _colors = @[[UIColor whiteColor],[UIColor blackColor],[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor blueColor],[UIColor greenColor],[UIColor brownColor],[UIColor grayColor],[UIColor lightGrayColor],[UIColor magentaColor],[UIColor purpleColor],[UIColor cyanColor],];
        
    }
    return _colors;
}
//重写filterImage属性的set方法
- (void)setFilterImage:(UIImage *)filterImage
{
    _filterImage = [filterImage resize:CGSizeMake(35, 35)];
    _filterButtons = [NSMutableArray array];
    for (int i = 0; i < self.filters.count; i++) {
        UIImage *filteredImage = self.filterImage;
        if (i > 0) {
            CIImage *inputCIImage = [[CIImage alloc] initWithImage:_filterImage];
            CIFilter *filter = [CIFilter filterWithName:self.filters[i]];
            [filter setDefaults];
            [filter setValue:inputCIImage forKey:@"inputImage"];
            CIImage *outputCIImage = [filter valueForKey:@"outputImage"];
            filteredImage = [UIImage imageWithCIImage:outputCIImage];
        }
        
        UIButton *filterButton = [[UIButton alloc] initWithFrame:CGRectMake(45 * i, 0, 45, 45)];
        filterButton.tag = i + 400;
        
        filterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        filterButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [filterButton setImage:filteredImage forState:UIControlStateNormal];
        [filterButton setTitle:self.filterNames[i] forState:UIControlStateNormal];
        [filterButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        filterButton.titleLabel.font = [UIFont systemFontOfSize:8];
        filterButton.titleEdgeInsets = UIEdgeInsetsMake(35, -filterButton.imageView.image.size.width, 0, 0);
        filterButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        filterButton.imageEdgeInsets = UIEdgeInsetsMake(-8,4,0,0);
        //filterButton.backgroundColor = [UIColor clearColor];
        [filterButton addTarget:self action:@selector(chooseFilter:) forControlEvents:UIControlEventTouchUpInside];
        [_filterButtons addObject:filterButton];
    }
}
#pragma mark - 初始化tooView 添加了三个按钮
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = self.height/2;
        
        [self initWithButtons];
    }
    return self;
}
- (void)initWithButtons
{   //颜色选择
    [self addOneButtonWithImage:[UIImage imageNamed:@"qm_caption"] title:@"颜色" tag:101];
    //字体选择
    [self addOneButtonWithImage:[UIImage imageNamed:@"qm_fonts"] title:@"字体" tag:102];
    //滤镜选择
    [self addOneButtonWithImage:[UIImage imageNamed:@"qm_filters"] title:@"滤镜" tag:103];
}

- (void)addOneButtonWithImage:(UIImage *)image title:(NSString *)title tag:(NSUInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(30, -btn.imageView.image.size.width, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(-10,10,0,0);
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    [self addSubview:btn];
}
#pragma mark - 单击按钮 弹出popoverView
- (void)btnClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(toolButtonClicked)]) {
        [self.delegate toolButtonClicked];
        [UIView animateWithDuration:1.0 animations:^{
            
            [self.superview layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 250, 45)];
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.showsVerticalScrollIndicator = NO;
            CMPopoverView *popView = [[CMPopoverView alloc] initWithCustomView:scrollView];
            _popView = popView;
            popView.backgroundColor = [UIColor darkGrayColor];
            popView.borderColor = [UIColor whiteColor];
            popView.borderWidth = 1.0;
            popView.cornerRadius = 10;
            popView.hasShadow = YES;
            popView.delegate = self;
            popView.has3DStyle = NO;
            popView.animation = CMPopTipAnimationPop;
            popView.dismissTapAnywhere = YES;
            popView.preferredPointDirection = PointDirectionDown;
            [popView presentPointingAtView:button inView:self.superview animated:YES];
            
            if (button.tag == 101) {
                [self addColorsToScrollView:scrollView];
            }else if (button.tag == 102){
                [self addFontsToScrollView:scrollView];
            }else if(button.tag == 103){
                [self addFiltersToScrollView:scrollView];
            }
            
        }];
    }


}
//添加到popoverView 字体选择按钮
- (void)addFontsToScrollView:(UIScrollView *)scrollView
{
    scrollView.contentSize = CGSizeMake(45.0 * self.fonts.count, 45);
    for (int i = 0; i < self.fonts.count; i++) {
        
        [scrollView addSubview:self.fontButtons[i]];
    }
}
- (void)chooseFont:(UIButton *)btn
{
    NSInteger i = btn.tag - 200;
    NSString *fontName = self.fonts[i];
    if ([self.delegate respondsToSelector:@selector(choosedFont:)]) {
        [self.delegate choosedFont:fontName];
    }
}
//添加到popoverView 颜色选择按钮
- (void)addColorsToScrollView:(UIScrollView *)scrollView
{
    scrollView.contentSize = CGSizeMake(45.0 * self.colors.count, 45);
    for (int i = 0; i < self.colors.count; i++) {
        
        [scrollView addSubview:self.colorButtons[i]];
    }
}
//添加到popoverView 图片滤镜选择按钮
- (void)chooseColor:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(choosedColor:)]) {
        [self.delegate choosedColor:btn.backgroundColor];
    }
    
}
- (void)addFiltersToScrollView:(UIScrollView *)scrollView
{
    scrollView.contentSize = CGSizeMake(45.0 * self.filters.count, 45);
    for (int i = 0; i < self.filterButtons.count; i++) {
        UIButton *filterButton = self.filterButtons[i];
        [scrollView addSubview:filterButton];
    }
}
- (void)chooseFilter:(UIButton *)btn
{
    NSInteger i = btn.tag - 400;
    if ([self.delegate respondsToSelector:@selector(choosedFilter:)]) {
        [self.delegate choosedFilter:self.filters[i]];
    }
}

#pragma mark - CMPopoverViewDelegate

- (void)popTipViewWasDismissedByUser:(CMPopoverView *)popTipView
{
    [popTipView dismissAnimated:YES];
}
// 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (self.width-20)/self.subviews.count;
    CGFloat h = self.height;
    for (int i = 0; i<self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        x = w * i + 10;
        btn.frame = CGRectMake(x, y, w, h);
    }
    
}



@end
