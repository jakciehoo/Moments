//
//  HooHomeViewController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/15.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooMomentBaseController.h"
#import "HooQuoteView.h"
#import "HooShareTool.h"
#import "UIImage+Utility.h"
#import "HooMainTabBarController.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "UIColor+Extension.h"
#import "NSDate+Extension.h"
#import "HooSqlliteTool.h"
#import "HooSaveTools.h"
#import "HooCreateQuoteViewController.h"
#import "SVProgressHUD.h"



@interface HooMomentBaseController ()

@property (weak, nonatomic) IBOutlet UIButton *starButton;

@property (weak, nonatomic) IBOutlet UIButton *pinButton;

@property (nonatomic, weak) UIView *blackView;

@property (nonatomic, weak) HooEditToolView *toolView;

@property (nonatomic, weak) NSLayoutConstraint *toolTop;


@property (nonatomic, weak) UIButton *originButton;

@property (nonatomic, weak) UIButton *saveButton;

@end

@implementation HooMomentBaseController

#pragma mark - 懒加载


- (HooMoment *)originMoment
{

    NSDate *today = [NSDate date];
    NSString *todayStr = [today dateWithMMDDAndConvertToString];
    HooMoment *moment = [HooSqlliteTool momentWithshowDate:today];
    moment.show_date = todayStr;
    
    _originMoment = moment;
    //先做一次数据更新
    [HooSqlliteTool updateMoment:_originMoment];
    return _originMoment;
}

//文字视图
- (HooQuoteView *)quoteView
{
    if (_quoteView == nil) {
        HooQuoteView *quoteView = [HooQuoteView quoteView];
        
        [self.imageView addSubview:quoteView];
        _quoteView= quoteView;
    }
    return _quoteView;
}
#pragma mark - 初始化
- (instancetype)init
{
    if (self = [super initWithNibName:@"HooMomentBaseController" bundle:nil]) {
        //监听imageview的image属性变化
        [self addObserver:self
               forKeyPath:@"imageView.image"
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                  context:nil];
        //程序进入后台更新信息通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMoment) name:UIApplicationDidEnterBackgroundNotification object:nil];
        //程序进入后台更新信息通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidLoad) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.centerButton.delegate = self;
    
    self.editMoment = self.originMoment;
    
    [self setupView:self.editMoment];
    
    self.mode = MomentModeOrigin;
    
    
    //当视图加载的时候我们需要关闭子flower按钮
    if (self.centerButton.currentState == HooFlowerButtonsStateOpened) {
        [self.centerButton showOrHideSubviews];
    }
    
    
    

    //给视图添加单击手势和事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHideButtons)];
    [self.view addGestureRecognizer:tap];
    
    //手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextMoment)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.imageView addGestureRecognizer:swipe];

}

//填充视图
- (void)setupView:(HooMoment *)moment
{

    self.quoteView.alpha = 0.0;
    self.imageView.alpha = 0.3;
    
    if (!self.fromMine) {
        self.momentImage = [UIImage imageNamed:moment.photo.image_filename];
    }else{
        NSString *imageName = moment.photo.image_filename;
        UIImage *image = [UIImage imageForPhotoName:imageName];
        self.momentImage = image;
    }
    
    self.editMoment = moment;
    
    //设置文字容器
    self.quoteView.moment = moment;
    //设置imageView
    self.imageView.image = self.momentImage;
    
    //给图片添加滤镜
    if (moment.photo.image_filtername) {
        [self choosedFilter:moment.photo.image_filtername];
    }
    
    //渐进显示
    [UIView animateWithDuration:HooDuration/2 animations:^{
        self.imageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:HooDuration/2 animations:^{
            self.quoteView.alpha = 1.0;
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setBackgroudColorForViews];
    self.quoteView.moment = self.editMoment;
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.centerButton.backgroundColor = HooColor(211, 211, 211);
    [self saveMoment];
}
//观察者调用方法
//这里我们观察iamgeview.image属性值改变来设置中心按钮的背景颜色
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"imageView.image"]) {
        [self setBackgroudColorForViews];
    }
    
}
//获取图片中的主色调，并设置给中心按钮
- (void)setBackgroudColorForViews
{
    self.imageColor = [self.imageView.image mostColorFromImage];
    self.centerButton.backgroundColor = self.imageColor;
    self.quoteView.quoteBgColor = self.imageColor;
    self.starButton.tintColor = self.imageColor;
    self.pinButton.tintColor = self.imageColor;
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
    if (self.mode == MomentModeOrigin) {
        BOOL flag;
        if (self.fromMine) {
            flag = [HooSqlliteTool updateMyMoment:self.editMoment];
        }else{
            flag = [HooSqlliteTool updateMoment:self.editMoment];
        }
    }
}

- (IBAction)starBttuonClicked:(UIButton *)sender {
    
    self.editMoment.photo.isFavorite = !self.editMoment.photo.isFavorite;
    sender.tintColor = self.editMoment.photo.isFavorite ? [UIColor orangeColor] :[UIColor grayColor];
    [self saveMoment];
}

- (IBAction)pinButtonClicked:(UIButton *)sender {
    UIImage *image = [UIImage imageDrawInView:self.view Inrect:self.imageView.frame];
    //保存快照的缩略图片到沙盒
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo
{
    NSString *title = nil ;
    NSString *msg = nil ;
    if(error != NULL){
        title = @"保存丁丁时刻失败" ;
        msg = @"抱歉啦，发生小概率事件，保存图片失败，请再试试吧！";
    }else{
        title = @"保存丁丁时刻成功" ;
        msg = @"今天运气不错，已经将丁丁时刻保存到你的相册了，有空去看看吧！";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
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
    NSArray *titleArr = @[@"分享",@"编辑",@"下一张",@"印制"];
    
    return titleArr[index];
}
//选种子按钮触发事件
- (void)flowerButton:(HooFlowerButton*)flowerButton
          didSelectItem:(HooFlowerItem*)item
{
    if (item.tag == 3) {
#warning 添加下订单功能
    }
    if (item.tag == 2) {
        [self nextMoment];
    }
    
    if (item.tag == 1) {
        [self editCurrentMomentQuote];
    }
    if (item.tag == 0) {
        [self shareMoment];
    }
    
}

//获取下一个美文美图对象
- (void)nextMoment
{
    HooMoment *moment;
    if (!self.fromMine) {
        moment =[HooSqlliteTool olderMomentOfMomentWithID:self.editMoment.ID];
    }else{
        moment = [HooSqlliteTool myOlderMomentOfMyMomentWithID:self.editMoment.ID];
    }
    if (moment == nil) {
        if (!self.fromMine) {
            moment =[HooSqlliteTool momentWithMaxID];
        }else{
            moment = [HooSqlliteTool myMomentWithMaxID];
        }
    }
    
    
    [self setupView:moment];
    
    //进入Next状态
    _mode = MomentModeNext;
}
//编辑
- (void)editCurrentMomentQuote
{
    //进入编辑状态
    _mode = MomentModeEdit;
    
    HooCreateQuoteViewController *createQuoteCtrl = [[HooCreateQuoteViewController alloc] init];
    createQuoteCtrl.title = @"修改文字";
    createQuoteCtrl.editMoment = self.editMoment;
    createQuoteCtrl.fromMine = self.fromMine;
    [self.navigationController pushViewController:createQuoteCtrl animated:YES];
    
}
//分享
- (void)shareMoment
{
    UIImage *image = [UIImage imageDrawInView:self.imageView Inrect:self.imageView.bounds];
    NSString *imageName = self.editMoment.photo.image_filename;
    [HooShareTool showshareAlertControllerIn:self.view WithImage:image andFileName:imageName];

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
    HooEditToolView *tool = [[HooEditToolView alloc] initWithFrame:CGRectMake(0, -50, 160, 60)];
    tool.filterImage = self.momentImage;
    tool.delegate = self;
    tool.layer.shadowColor = [UIColor blackColor].CGColor;
    tool.layer.shadowOffset = CGSizeMake(0.0, 1);
    tool.layer.shadowRadius = 5;
    tool.layer.shadowOpacity = 0.5;
    
    [superView insertSubview:tool aboveSubview:blackView];
    _toolView = tool;
    
    [tool autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [tool autoSetDimensionsToSize:CGSizeMake(160, 60)];
    NSLayoutConstraint *bottomToTop = [tool autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:superView];
    
    //originButton
    UIButton *originButton = [self roundButtonWithTitle:@"返回" imageName:@"fbi_flat_original"];
    NSLayoutConstraint *originTop;
    
    //非初始状态，显示返回初始状态按钮
    if (self.mode != MomentModeOrigin){
        [superView insertSubview:originButton aboveSubview:blackView];
        [originButton addTarget:self action:@selector(returnOriginMoment) forControlEvents:UIControlEventTouchUpInside];
        self.originButton = originButton;
        [originButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [originButton autoSetDimensionsToSize:CGSizeMake(60, 60)];
        originTop = [originButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:superView];
    }
    
    //saveButton
    UIButton *saveButton = [self roundButtonWithTitle:@"保存" imageName:@"fbi_save_flat"];
    NSLayoutConstraint *saveTop;
    //进入编辑和创建模式时显示保存按钮
    if (self.mode == MomentModeEdit || self.mode == MomentModeCreate){
        [superView insertSubview:saveButton aboveSubview:blackView];
        [saveButton addTarget:self action:@selector(savEditMoment) forControlEvents:UIControlEventTouchUpInside];
        self.saveButton = saveButton;
        [saveButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [saveButton autoSetDimensionsToSize:CGSizeMake(60, 60)];
        saveTop = [saveButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:superView];
    }
    
       //更新约束
    [superView layoutIfNeeded];
    //移除约束

    [superView removeConstraint:bottomToTop];
    _toolTop = [tool autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];
    
    if (self.mode != MomentModeOrigin){
        [superView removeConstraint:originTop];
        [originButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:200];
    }
    
    if (self.mode == MomentModeEdit || self.mode == MomentModeCreate){
        [superView removeConstraint:saveTop];
        [saveButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:270];
    }

    
    [UIView animateWithDuration:HooDuration/2 animations:^{
        
        [superView layoutIfNeeded];
        
    }];
    
    if (self.mode != MomentModeOrigin){
        [viewArray addObject:originButton];
    }
    
    if (self.mode == MomentModeEdit || self.mode == MomentModeCreate){
        [viewArray addObject:saveButton];
    }
    
    [viewArray addObject:tool];

    return viewArray;
}

- (UIButton *)roundButtonWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    UIButton *roundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    roundButton.layer.cornerRadius = 30;
    roundButton.backgroundColor = [UIColor whiteColor];
    roundButton.layer.shadowColor = [UIColor blackColor].CGColor;
    roundButton.layer.shadowOffset = CGSizeMake(0.0, 1);
    roundButton.layer.shadowRadius = 5;
    roundButton.layer.shadowOpacity = 0.5;
    roundButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [roundButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [roundButton setTitle:title forState:UIControlStateNormal];
    [roundButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    roundButton.imageEdgeInsets = UIEdgeInsetsMake(-10,11,0,0);
    roundButton.titleEdgeInsets = UIEdgeInsetsMake(30, -roundButton.imageView.image.size.width, 0, 0);
    return roundButton;
}
//originButton单击事件
- (void)returnOriginMoment
{
    //回到初始状态
    _mode = MomentModeOrigin;

    [self.centerButton showOrHideSubviews];
    [self setupView:self.originMoment];
}

// saveButton单击事件
- (void)savEditMoment
{
    //设置创建和修改时间
    NSDate *dateNow = [NSDate date];
    long interval = [dateNow timeIntervalSince1970];
    NSString *intervalString = [NSString stringWithFormat:@"%ld",interval];
    
    self.editMoment.modified_date = intervalString;
    
    
    BOOL flag;
    
    if (self.mode == MomentModeCreate) {
        //设置照片和缩略图的名称
        NSInteger currentPhotoID = [HooSaveTools integerForkey:PhotoID];
        [HooSaveTools setInteger:currentPhotoID + 1 forKey:PhotoID];
        NSString *photoName = [NSString stringWithFormat:@"MomentPhoto_%ld.jpg",(long)currentPhotoID];
        NSString *photo_thumb_Name = [NSString stringWithFormat:@"MomentPhoto_%ld_thumb.jpg",(long)currentPhotoID];
        self.editMoment.photo.image_filename = photoName;
        self.editMoment.photo.image_thumb_filename = photo_thumb_Name;
        self.editMoment.created_date = intervalString;
        
        //执行插入数据库操作
        flag = [HooSqlliteTool addNewMyMoment:self.editMoment];
        
        if (flag) {
            //保存图片到沙盒
            [self.momentImage writeImageToDocumentDirectoryWithPhotoName:self.editMoment.photo.image_filename];
            
            CGRect rect = CGRectMake(0, self.editMoment.photo.positionY - 50, self.imageView.width, self.imageView.width);
            UIImage *thumbImage = [UIImage imageDrawInView:self.imageView Inrect:rect];
            //保存快照的缩略图片到沙盒
            [thumbImage writeImageToDocumentDirectoryWithPhotoName:self.editMoment.photo.image_thumb_filename];
        }
    }else if (self.mode == MomentModeEdit){
        if (self.fromMine) {
            flag = [HooSqlliteTool updateMyMoment:self.editMoment];
        }else{
            flag = [HooSqlliteTool updateMoment:self.editMoment];
        }
        
    }
    
    if (flag) {
        //模式改为Next状态
        _mode = MomentModeNext;
        //关闭按钮
        [self.centerButton showOrHideSubviews];
        [SVProgressHUD showSuccessWithStatus:@"太棒了,丁丁记创建成功!"];
        
        
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"哦哦，小意外，保存失败，请再试试"];
        
    }
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
    //获取RGB色值
    NSArray *components = [color getRGBComponents];
    
    self.editMoment.fontColorR = [components[0] floatValue];
    self.editMoment.fontColorG = [components[1] floatValue];
    self.editMoment.fontColorB = [components[2] floatValue];
}


- (void)choosedFont:(NSString *)fontName
{
    self.quoteView.quoteFontName = fontName;
    self.editMoment.fontName = fontName;
}
- (void)choosedFilter:(NSString *)filterName
{
    if (self.momentImage == nil) return;
    
    self.editMoment.photo.image_filtername = filterName;
    
    if ([filterName isEqualToString:@"Default"]) {
        self.imageView.image = self.momentImage;
        return;
    }
    //给图片添加滤镜
    UIImage *filteredImage = [self.momentImage filterImagewithFilterName:filterName];
    self.imageView.image = filteredImage;
    
}

- (void)toolButtonClicked
{
    
    if(self.centerButton.currentState == HooFlowerButtonsStateOpened){
        [self.centerButton hideFlowerButtons];
        self.originButton.alpha = 0.0;
            [UIView animateWithDuration:HooDuration/2 animations:^{
                self.blackView.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                
                [self.blackView removeFromSuperview];
            }];
    }
    [self.toolView.superview removeConstraint:_toolTop];
    [self.toolView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:100];
}

#pragma mark - dealloc
- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"imageView.image"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
