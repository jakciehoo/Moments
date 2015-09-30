//
//  HooEditViewController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/25.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooEditViewController.h"
#import "HooProductSizeInfoController.h"
#import "RKTabView.h"
#import "UIImage+Utility.h"
#import "UIColor+Extension.h"
#import "YAScrollSegmentControl.h"
#import "SVProgressHUD.h"
#import "HooProduct.h"
#import "HooProductModel.h"
#import "HooProductGroup.h"
#import "HooProductColor.h"
#import "HooProductSize.h"
#import "UIImageView+WebCache.h"
#import "HooSaveTools.h"

#define HooSegmentWidth 60
#define HooSegmentHeight 30
#define HooSegmentX 60
#define HooSegmentY 45

#define HooProductModelSelectedIndex @"ModelSelectedIndex"
#define HooProductGroupSelectedIndex @"GroupSelectedIndex"
#define HooProductColorSelectedIndex @"ColorSelectedIndex"
#define HooProductSizeSelectedIndex @"SizeSelectedIndex"

@interface HooEditViewController ()<RKTabViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,YAScrollSegmentControlDelegate>

@property (nonatomic, strong) HooProduct *product;

@property (nonatomic, weak)UIImageView *productImageView;

@property (nonatomic, weak)UIImageView *photoImageView;

@property (nonatomic, weak)RKTabView *tabView;

@property (nonatomic, weak)UIView *modeSelectView;

@property (nonatomic, weak)UIView *photoSelectView;

@property (nonatomic, assign,getter=isShowPhotoView)BOOL showPhotoView;

@property (nonatomic, weak)UIView *paternSelectView;

@property (nonatomic, strong)NSMutableArray *productModels;

@property (nonatomic, strong)NSMutableArray *productGroups;

@property (nonatomic, strong)NSMutableArray *productColors;

@property (nonatomic, strong)NSMutableArray *productSizes;

@property (nonatomic, weak)YAScrollSegmentControl *modelSegment;

@property (nonatomic, weak)YAScrollSegmentControl *groupSegment;

@property (nonatomic, weak)YAScrollSegmentControl *colorSegment;

@property (nonatomic, weak)YAScrollSegmentControl *sizeSegment;

@end

@implementation HooEditViewController



#pragma mark -懒加载

- (NSMutableArray *)productModels
{
    if (_productModels == nil) {
        _productModels = [NSMutableArray array];
        [_productModels addObjectsFromArray:self.product.models];
    }
    return _productModels;
}

- (NSMutableArray *)productGroups
{
    if (_productGroups == nil) {
        _productGroups = [NSMutableArray array];
    }
    return _productGroups;
}
- (NSMutableArray *)productColors
{
    if (_productColors == nil) {
        _productColors = [NSMutableArray array];
    }
    return _productColors;
}
- (NSMutableArray *)productSizes
{
    if (_productSizes == nil) {
        _productSizes = [NSMutableArray array];

    }
    return _productSizes;
}

- (YAScrollSegmentControl *)modelSegment
{
    if (_modelSegment == nil) {
        YAScrollSegmentControl *modelSegment = [[YAScrollSegmentControl alloc] initWithFrame:CGRectMake(0, 0, self.view.width,30)];
        _modelSegment = modelSegment;
        modelSegment.tag = 200;
        [modelSegment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [modelSegment setTitleColor:HooColor(234, 81, 96) forState:UIControlStateSelected];
        [modelSegment setFont:[UIFont systemFontOfSize:12]];
        modelSegment.delegate = self;
        NSInteger selectedIndex = [HooSaveTools integerForkey:HooProductModelSelectedIndex];
        modelSegment.selectedIndex = selectedIndex;
        [self.modeSelectView addSubview:modelSegment];
    }
    return _modelSegment;
}
- (YAScrollSegmentControl *)groupSegment
{
    if (_groupSegment == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, HooSegmentY, HooSegmentX, HooSegmentHeight)];
        label.text = @"性别";
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        YAScrollSegmentControl *groupSegment = [[YAScrollSegmentControl alloc] initWithFrame:CGRectMake(HooSegmentX, HooSegmentY, self.view.width-HooSegmentX,HooSegmentHeight)];
        _groupSegment = groupSegment;
        groupSegment.tag = 201;
        groupSegment.delegate = self;
        groupSegment.selectedIndex = [HooSaveTools integerForkey:HooProductGroupSelectedIndex];
        [groupSegment setFont:[UIFont systemFontOfSize:12]];
        [groupSegment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [groupSegment setTitleColor:HooColor(234, 81, 96) forState:UIControlStateSelected];
        groupSegment.buttonWidth = 80;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(groupSegment.frame) + 5, self.view.width - 50, 0.5)];
        line.backgroundColor = [UIColor blackColor];
        [self.modeSelectView addSubview:line];
        [self.modeSelectView addSubview:groupSegment];
        [self.modeSelectView addSubview:label];
    }
    return _groupSegment;
}
- (YAScrollSegmentControl *)colorSegment
{
    if (_colorSegment == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2 * HooSegmentY, HooSegmentX, HooSegmentHeight)];
        label.text = @"颜色";
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        YAScrollSegmentControl *colorSegment = [[YAScrollSegmentControl alloc] initWithFrame:CGRectMake(HooSegmentX, 2 * HooSegmentY, self.view.width-HooSegmentX,HooSegmentHeight)];
        _colorSegment = colorSegment;
        colorSegment.tag = 202;
        colorSegment.delegate = self;
        colorSegment.selectedIndex = [HooSaveTools integerForkey:HooProductColorSelectedIndex];
        [colorSegment setFont:[UIFont systemFontOfSize:12]];
        [colorSegment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [colorSegment setTitleColor:HooColor(234, 81, 96) forState:UIControlStateSelected];
        colorSegment.buttonWidth = 80;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(colorSegment.frame) + 5, self.view.width - 50, 0.5)];
        line.backgroundColor = [UIColor blackColor];
        [self.modeSelectView addSubview:line];
        [self.modeSelectView addSubview:colorSegment];
        [self.modeSelectView addSubview:label];
    }
    return _colorSegment;
}

- (YAScrollSegmentControl *)sizeSegment
{
    if (_sizeSegment == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 3 * HooSegmentY, HooSegmentX, HooSegmentHeight)];
        label.text = @"尺寸 ";
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        YAScrollSegmentControl *sizeSegment = [[YAScrollSegmentControl alloc] initWithFrame:CGRectMake(HooSegmentX, 3 * HooSegmentY, self.view.width-HooSegmentX,HooSegmentHeight)];
        _sizeSegment = sizeSegment;
        sizeSegment.tag = 203;
        sizeSegment.delegate = self;
        NSInteger selectedIndex = [HooSaveTools integerForkey:HooProductSizeSelectedIndex];
        sizeSegment.selectedIndex = selectedIndex;
        [sizeSegment setFont:[UIFont systemFontOfSize:12]];
        [sizeSegment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sizeSegment setTitleColor:HooColor(234, 81, 96) forState:UIControlStateSelected];
        sizeSegment.buttonWidth = 70;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(sizeSegment.frame) + 5, self.view.width - 50, 0.5)];
        line.backgroundColor = [UIColor blackColor];
        [self.modeSelectView addSubview:line];
        
        [self.modeSelectView addSubview:sizeSegment];
        [self.modeSelectView addSubview:label];
    }
    return _sizeSegment;
}

- (UIImageView *)productImageView
{
    if (_productImageView == nil) {
        UIImageView *productImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        productImageView.contentMode = UIViewContentModeScaleAspectFill;
        [productImageView clipsToBounds];
        productImageView.userInteractionEnabled = YES;
        [self.view insertSubview:productImageView belowSubview:self.tabView];
        _productImageView = productImageView;
    }
    return _productImageView;
}

- (UIImageView *)photoImageView
{
    if (_photoImageView == nil) {
        UIImageView *photoImageView = [[UIImageView alloc] init];
        photoImageView.frame = CGRectMake(91, 200, 144, 205);
        [self.productImageView addSubview:photoImageView];
        _photoImageView = photoImageView;
    }
    return _photoImageView;
}
//选项卡视图
- (RKTabView *)tabView
{
    if (_tabView == nil) {
        RKTabView *tabView = [[RKTabView alloc] initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
         //57,63,75
        tabView.backgroundColor = HooColor(57, 63, 75);
        
        RKTabItem *modeTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"ay_model_material_selected"] imageDisabled:[UIImage imageNamed:@"ay_model_material"]];
        
        modeTabItem.titleString = @"款式";
        RKTabItem *photoTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"ay_model_image_selected"] imageDisabled:[UIImage imageNamed:@"ay_model_image"]];
        photoTabItem.titleString = @"更换图文";
        RKTabItem *editTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"ay_model_diy_selected"] imageDisabled:[UIImage imageNamed:@"ay_model_diy"]];
        editTabItem.titleString = @"编辑";
        RKTabItem *patternTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"Tshirt_Btn_Temp"] imageDisabled:[UIImage imageNamed:@"Tshirt_Btn_Temp"]];
        patternTabItem.titleString = @"模板";
        RKTabItem *buyTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"ay_model_buy_selected"] imageDisabled:[UIImage imageNamed:@"ay_model_buy"]];
        buyTabItem.titleString = @"购买";
        
        tabView.darkensBackgroundForEnabledTabs = YES;
        //tabView.horizontalInsets = HorizontalEdgeInsetsMake(25, 25);
        tabView.titlesFontColor = [UIColor colorWithWhite:0.9f alpha:0.8f];
        
        tabView.tabItems = @[modeTabItem, photoTabItem, editTabItem, patternTabItem, buyTabItem];
        
        _tabView = tabView;
        [self.view addSubview:tabView];
    }
    return _tabView;
}

- (UIView *)modeSelectView
{
    if (_modeSelectView == nil) {
        UIView *modeSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, 200)];
        modeSelectView.backgroundColor = HooColor(40, 50, 62);
        _modeSelectView = modeSelectView;
        [self.view insertSubview:modeSelectView belowSubview:self.tabView];
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0,modeSelectView.height - 30, self.view.width, 30)];

        if (self.product.product_size_infoURL) {
            
            UIButton *sizeInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [sizeInfoBtn setTitle:@"尺寸说明" forState:UIControlStateNormal];
            [sizeInfoBtn setTitleColor:HooColor(234, 81, 96) forState:UIControlStateNormal];
            [sizeInfoBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [sizeInfoBtn setImage:[UIImage imageNamed:@"Tshirt_Btn_Style_Info"] forState:UIControlStateNormal];
            [sizeInfoBtn addTarget:self action:@selector(getSizeInfo) forControlEvents:UIControlEventTouchUpInside];
            [infoView addSubview:sizeInfoBtn];
            sizeInfoBtn.frame = CGRectMake(infoView.width - 80, 0, 80, 30);
        }
        [modeSelectView addSubview:infoView];
        
        //设置产品品质选项卡
        NSMutableArray *buttonTitles = [NSMutableArray array];
        if (self.productModels.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"该产品可能暂时下架了，请试试其他产品"];
        }
        for (HooProductModel *model in self.productModels) {
            NSString *model_name = model.model_name;
            [buttonTitles addObject:model_name];
        }
        self.modelSegment.buttonTitles = buttonTitles;
        
    }
    return _modeSelectView;
}
- (void)getSizeInfo
{
    HooProductSizeInfoController *sizeInfoCtrl = [[HooProductSizeInfoController alloc] init];
    sizeInfoCtrl.product_size_infoURL = self.product.product_size_infoURL;
    [self.navigationController pushViewController:sizeInfoCtrl animated:YES];
}


- (UIView *)paternSelectView
{

    if (_paternSelectView == nil) {
         UIView *paternSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, 85)];
        paternSelectView.backgroundColor = HooColor(40, 50, 62);
        for (int i = 0; i< 4; i++) {

            NSString *imageName = [NSString stringWithFormat:@"Tshirt_Temp_NO%d_Card",i];
            UIImage *btnImage = [UIImage imageNamed:imageName];
            UIButton *paternBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [paternBtn setImage:btnImage forState:UIControlStateNormal];
            [paternSelectView addSubview:paternBtn];
            paternBtn.frame = CGRectMake(i * (btnImage.size.width + 10) + 10, 10, btnImage.size.width, btnImage.size.height);
        }
        [self.view insertSubview:paternSelectView belowSubview:self.tabView];
        _paternSelectView = paternSelectView;
    }
    return _paternSelectView;
}


- (UIView *)photoSelectView
{
    if (_photoSelectView == nil) {
        UIView *photoSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, 85)];
        // 40, 50, 62
        photoSelectView.backgroundColor = HooColor(40, 50, 62);
        UIButton *camaraBtn = [self buttonWithImage:[UIImage imageNamed:@"Tshirt_Btn_Camera"] title:@"拍照" tag:11];
        
        UIButton *albumBtn = [self buttonWithImage:[UIImage imageNamed:@"Tshirt_Btn_Photo"] title:@"照片库" tag:12];
        
        [photoSelectView addSubview:camaraBtn];
        [photoSelectView addSubview:albumBtn];
        camaraBtn.frame = CGRectMake(10, 10, 75, 75);
        albumBtn.frame = CGRectMake(10 + 75, 10, 75, 75);
        _photoSelectView = photoSelectView;
        [self.view insertSubview:photoSelectView belowSubview:self.tabView];
    }
    return _photoSelectView;
}

- (UIButton *)buttonWithImage:(UIImage *)image title:(NSString *)title tag:(NSUInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(50, -btn.imageView.image.size.width, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(-20,10,0,0);
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    return btn;
}

- (void)selectPhoto:(UIButton *)sender
{
    if (sender.tag == 11) {
        [self selectPhotoFromCamara];
    }else if (sender.tag == 12){
        [self selectPhotoFromAlbum];
    }
}

//从相机拍照
- (void)selectPhotoFromCamara
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    UIImagePickerController *imagePickerCtrl = [[UIImagePickerController alloc] init];
    imagePickerCtrl.view.tintColor = HooTintColor;
    imagePickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerCtrl.delegate = self;
    imagePickerCtrl.allowsEditing = YES;
    [self presentViewController:imagePickerCtrl animated:YES completion:nil];
}
//从照片库选择
- (void)selectPhotoFromAlbum
{
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) return;
    UIImagePickerController *imagePickerCtrl = [[UIImagePickerController alloc] init];
    imagePickerCtrl.view.tintColor = HooTintColor;
    imagePickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerCtrl.delegate = self;
    imagePickerCtrl.allowsEditing = NO;
    [self presentViewController:imagePickerCtrl animated:YES completion:nil];
    
}
- (void)pickPhotoFromApp
{
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    pickedImage = [pickedImage fixOrientation];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (pickedImage) {
        self.photoImageView.image = [pickedImage aspectFill:self.productImageView.bounds.size];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}
- (void)setupView
{
    self.photoImageView.image = [UIImage imageNamed:@"Default_Image"];
    self.view.backgroundColor = HooColor(248, 248, 248);
    self.tabView.delegate = self;
    [self.tabView switchTabIndex:0];
    //234，81，96
    //self.navigationController.navigationBar.backgroundColor = HooColor(234, 81, 96);

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ay_table_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeController)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopView)];
    tap.numberOfTapsRequired = 1;
    [self.productImageView addGestureRecognizer:tap];
    
    
}
//退出当前控制器
- (void)closeController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)closePopView
{

             [self.tabView.tabItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 RKTabItem *item = (RKTabItem *)obj;
                 if (item.tabState == TabStateEnabled) {
                   [self tabView:self.tabView tabBecameDisabledAtIndex:idx tab:item];
                     item.tabState = TabStateDisabled;
                     [self.tabView setTabContent:item];
                 }
             }];

}


#pragma mark - RKTabViewDelegate

- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem {
    if (index == 0) {
        self.modeSelectView.tag = 100 + index;
    }
    if (index == 1) {
        self.photoSelectView.tag = 100 + index;
    }

    if (index == 3) {
        self.paternSelectView.tag = 100 + index;
    }
    
    UIView *view = [self.view viewWithTag:100+index];
    if (view != nil) {
        [UIView animateWithDuration:HooDuration/2
                         animations:^{
                             view.transform = CGAffineTransformMakeTranslation(0, -(view.height + 50));                         }];
        
    }
    if (index == 4) {
        
    }
    
}

- (void)tabView:(RKTabView *)tabView tabBecameDisabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem {
    
    UIView *view = [self.view viewWithTag:100+index];
    if (view != nil) {
        
        [UIView animateWithDuration:HooDuration/2
                         animations:^{
                             view.transform = CGAffineTransformIdentity;
                                                      } completion:^(BOOL finished) {
                                                          [view removeFromSuperview];
                                                      }];
        
    }


}
#pragma mark - YAScrollSegmentControlDelegate
- (void)segmentControl:(YAScrollSegmentControl *)segmentControl didSelectItemAtIndex:(NSInteger)index
{
    
    //款式品质选项卡
    if (segmentControl.tag == 200) {
        [self modelSegmentSelected:index];
    }
    //性别选项卡
    if (segmentControl.tag == 201) {
        [self groupSegmentSelected:index];
    }
    //颜色选项卡
    if (segmentControl.tag == 202) {
        [self colorSegmentSelected:index];
        
    }
    if (segmentControl.tag == 203) {
         [HooSaveTools setInteger:self.sizeSegment.selectedIndex forKey:HooProductSizeSelectedIndex];
        
        
    }
    
    
    
    
    
    
   
    
}

- (void)modelSegmentSelected:(NSInteger)index
{
    [HooSaveTools setInteger:self.modelSegment.selectedIndex forKey:HooProductModelSelectedIndex];

    HooProductModel *model = self.productModels[index];
    [self.productGroups removeAllObjects];
    [self.productGroups addObjectsFromArray:model.groups];

    [self.groupSegment removeFromSuperview];
    [self.colorSegment removeFromSuperview];
    [self.sizeSegment removeFromSuperview];


    
    
    NSMutableArray *buttonTitles = [NSMutableArray array];
    NSMutableArray *buttonImages = [NSMutableArray array];
    for (HooProductGroup *group in self.productGroups) {
        NSString *group_name = group.group_name;
        [buttonTitles addObject:group_name];
        if ([group_name isEqualToString:@"男"]) {
            UIImage *manImage = [UIImage imageNamed:@"Tshirt_Btn_Sex_Man"];
            [buttonImages addObject:manImage];
        }
        if ([group_name isEqualToString:@"女"]) {
            UIImage *womanImage = [UIImage imageNamed:@"Tshirt_Btn_Sex_Woman"];
            [buttonImages addObject:womanImage];
        }
        
    }
    if (buttonTitles.count > 0) {
        self.groupSegment.buttonImages = buttonImages;
        self.groupSegment.buttonTitles = buttonTitles;
    }
}
- (void)groupSegmentSelected:(NSInteger)index
{
    [HooSaveTools setInteger:self.groupSegment.selectedIndex forKey:HooProductGroupSelectedIndex];
    HooProductGroup *group = self.productGroups[index];
    [self.productColors removeAllObjects];
    [self.productColors addObjectsFromArray:group.colors];
    

    [self.colorSegment removeFromSuperview];
    [self.sizeSegment removeFromSuperview];

    
    NSMutableArray *buttonTitles = [NSMutableArray array];
    NSMutableArray *buttonImages = [NSMutableArray array];
    for (HooProductColor *color in self.productColors) {
        NSString *color_name = color.color_name;
        [buttonTitles addObject:color_name];
        NSString *color_hexaStr = color.color_hexa;
        NSInteger color_hexa = strtoul([color_hexaStr UTF8String], 0, 16);
        UIColor *imageColor = [UIColor colorWithHex:color_hexa];
        UIImage *buttonImage = [UIImage imageWithColor:imageColor withRect:CGRectMake(0, 0, 20, 20)];
        [buttonImages addObject:buttonImage];
    }
    if (buttonTitles.count > 0) {
        self.colorSegment.buttonImages = buttonImages;
        self.colorSegment.buttonTitles = buttonTitles;
    }
}
- (void)colorSegmentSelected:(NSInteger)index
{
    [HooSaveTools setInteger:self.colorSegment.selectedIndex forKey:HooProductColorSelectedIndex];
    HooProductColor *color = self.productColors[index];
    [self.productSizes removeAllObjects];
    [self.productSizes addObjectsFromArray:color.sizes];
    
    [self.sizeSegment removeFromSuperview];
    
    NSMutableArray *buttonTitles = [NSMutableArray array];
    for (HooProductSize *size in self.productSizes) {
        NSString *size_value = size.size_value;
        [buttonTitles addObject:size_value];
    }
    if (buttonTitles.count > 0) {
        
        self.sizeSegment.buttonTitles = buttonTitles;
        
    }
    
    NSURL *product_imageURL = color.product_imageURL;
    if (product_imageURL) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        
        [self.productImageView sd_setImageWithURL:product_imageURL placeholderImage:[UIImage imageNamed:@"tshirt_woman_black"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSInteger progress = receivedSize / expectedSize;
            [SVProgressHUD showProgress:progress status:@"努力加载中..."];

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [SVProgressHUD dismiss];
        }];
    }
    

    

}


@end
