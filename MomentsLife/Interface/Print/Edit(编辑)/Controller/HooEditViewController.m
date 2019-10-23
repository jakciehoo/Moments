//
//  HooEditViewController.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/25.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import "HooEditViewController.h"
#import "HooProductInfoController.h"
#import "HooQuotesImageController.h"
#import "HooStopAutoRotationNaviController.h"
#import "HooLoginController.h"
#import "HooOrderPayController.h"
#import "XDEditImageController.h"
#import "CLImageEditor.h"
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
#import "UIView+AutoLayout.h"
#import "NSDate+Extension.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "HooUserManager.h"
#import "OrderedProduct.h"
#import "HooOrderedProductManager.h"


#define HooSegmentWidth 60
#define HooSegmentHeight 30
#define HooSegmentX 60
#define HooSegmentY 45


@interface HooEditViewController ()<RKTabViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,YAScrollSegmentControlDelegate,CLImageEditorDelegate,UIAlertViewDelegate>
/**
 *  产品
 */
@property (nonatomic, strong) HooProduct *product;
/**
 *产品品质数组
 */
@property (nonatomic, strong)NSMutableArray *productModels;
/**
 *  产品性别群体数组
 */
@property (nonatomic, strong)NSMutableArray *productGroups;
/**
 *  产品颜色数组
 */

@property (nonatomic, strong)NSMutableArray *productColors;
/**
 *  产品大小数组
 */
@property (nonatomic, strong)NSMutableArray *productSizes;
//产品图片视图
@property (nonatomic, weak)UIImageView *productImageView;
//设计图片视图
@property (nonatomic, weak)UIImageView *photoImageView;

//价格显示按钮
@property (nonatomic, weak)UIButton *priceButton;
//库存按钮
@property (nonatomic, weak)UIButton *inventoryButton;

//底部选项卡视图
@property (nonatomic, weak)RKTabView *tabView;
//款式选择视图
@property (nonatomic, weak)UIView *modeSelectView;
//图片选择视图
@property (nonatomic, weak)UIView *photoSelectView;
//模板视图
@property (nonatomic, weak)UIView *maskSelectView;
//品质款式选择分段按钮
@property (nonatomic, weak)YAScrollSegmentControl *modelSegment;
//属组选择分段按钮
@property (nonatomic, weak)YAScrollSegmentControl *groupSegment;
//颜色选择分段按钮
@property (nonatomic, weak)YAScrollSegmentControl *colorSegment;
//尺寸选择分段按钮
@property (nonatomic, weak)YAScrollSegmentControl *sizeSegment;
//款式说明视图
@property (nonatomic, weak)UIView *infoView;
//选择的品质
@property (nonatomic, strong)HooProductModel *selectedModel;
//选择的属组
@property (nonatomic, strong)HooProductGroup *selectedGroup;
//选择的颜色
@property (nonatomic, strong)HooProductColor *selectedColor;
//选择的尺寸
@property (nonatomic, strong)HooProductSize *selectedSize;
//选择的品质的索引
@property (nonatomic, assign)NSInteger selectedModelIndex;
//选择的属组索引
@property (nonatomic, assign)NSInteger selectedGroupIndex;
//选择的颜色索引
@property (nonatomic, assign)NSInteger selectedColorIndex;
//选择的尺寸索引
@property (nonatomic, assign)NSInteger selectedSizeIndex;

/**
 *  产品可允许用户设计图案的区域的真实大小
 */
@property (nonatomic, assign)CGSize paternsize;
/**
 *  设计图案和显示图案的比例
 */
@property (nonatomic, assign)CGFloat paternRatio;


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


- (UIImageView *)productImageView
{
    if (_productImageView == nil) {
        UIImageView *productImageView = [[UIImageView alloc] init];
        productImageView.contentMode = UIViewContentModeScaleAspectFill;
        productImageView.clipsToBounds = YES;
        productImageView.userInteractionEnabled = YES;
        [self.view insertSubview:productImageView belowSubview:self.tabView];
        [productImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        _productImageView = productImageView;
    }
    return _productImageView;
}

- (UIImageView *)photoImageView
{
    if (_photoImageView == nil) {
        UIImageView *photoImageView = [[UIImageView alloc] init];
        photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        photoImageView.userInteractionEnabled = YES;
        photoImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tapPhotoView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomInAndZoomOutProductView)];
        tapPhotoView.numberOfTapsRequired = 2;
        [photoImageView addGestureRecognizer:tapPhotoView];
        XDEditImageController *editCtrl = [[XDEditImageController alloc] initWithImage:self.printImage];
        HooStopAutoRotationNaviController *navi = [[HooStopAutoRotationNaviController alloc] initWithRootViewController:editCtrl];
        if (self.paternRatio != 0) {
            CGFloat min = MIN(self.paternsize.width, self.paternsize.height);
            CGFloat max = MAX(self.paternsize.width, self.paternsize.height);
            editCtrl.ratio = min / max;
        }
        [self presentViewController:navi animated:YES completion:nil];
        [self.productImageView addSubview:photoImageView];

        _photoImageView = photoImageView;
    }
    return _photoImageView;
}

- (void)zoomInAndZoomOutProductView
{
    CGFloat photoViewWidth = self.paternRatio * self.paternsize.width;
    CGFloat width = (self.view.width - 40);
    CGFloat ratio = self.photoImageView.width < width ? (width / photoViewWidth) : (photoViewWidth / width);

    [self.productImageView autoRemoveConstraintsAffectingView];
    [self.productImageView autoCenterInSuperview];
    [self.productImageView autoSetDimensionsToSize:CGSizeMake(self.productImageView.width * ratio, self.productImageView.height * ratio)];
    [self.photoImageView autoRemoveConstraintsAffectingView];
    [self.photoImageView autoCenterInSuperview];
    [self.photoImageView autoSetDimensionsToSize:CGSizeMake(self.photoImageView.width * ratio, self.photoImageView.height * ratio)];
    
    [UIView animateWithDuration:HooDuration/2 animations:^{

        //
        [self.productImageView layoutIfNeeded];
        [self.photoImageView layoutIfNeeded];
        
    } completion:^(BOOL finished) {

        
        [UIView animateWithDuration:HooDuration/2 animations:^{
            
        }];
    }];

}


- (UIButton *)priceButton
{
    if (_priceButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = HooColor(234, 81, 96);
        button.alpha = 0.8;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        button.frame = CGRectMake(self.view.width - 50, 50, 60, 20);
        button.layer.cornerRadius = 10;
        [self.view addSubview:button];
        _priceButton = button;
    }
    return _priceButton;
}
- (UIButton *)inventoryButton
{
    if (_inventoryButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = HooColor(234, 81, 96);
        button.alpha = 0.8;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        button.frame = CGRectMake(self.view.width - 50, 100, 60, 20);
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        button.layer.cornerRadius = 10;
        [self.view addSubview:button];
        _inventoryButton = button;
    }
    return _inventoryButton;
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
#pragma mark - 款式选择视图

- (UIView *)modeSelectView
{
    if (_modeSelectView == nil) {
        UIView *modeSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, 200)];
        modeSelectView.backgroundColor = HooColor(40, 50, 62);
        _modeSelectView = modeSelectView;
        [self.view insertSubview:modeSelectView belowSubview:self.tabView];

        [self infoView];
        
        //设置产品品质选项卡
        NSMutableArray *buttonTitles = [NSMutableArray array];
        if (self.productModels.count == 0) {
            
            [SVProgressHUD showInfoWithStatus:@"该产品可能暂时下架了，请试试其他产品"];
        }else
        for (HooProductModel *model in self.productModels) {
            NSString *model_name = model.model_name;
            [buttonTitles addObject:model_name];

        }
        if (buttonTitles.count > 0) {
            
            self.modelSegment.buttonTitles = buttonTitles;
        }

        
    }
    return _modeSelectView;
}

//款式选择
- (YAScrollSegmentControl *)modelSegment
{
    if (_modelSegment == nil) {
        YAScrollSegmentControl *modelSegment = [[YAScrollSegmentControl alloc] initWithFrame:CGRectMake(0, 0, self.view.width,30)];
        _modelSegment = modelSegment;
        modelSegment.tag = 200;
        [modelSegment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [modelSegment setTitleColor:HooColor(234, 81, 96) forState:UIControlStateSelected];
        [modelSegment setFont:[UIFont systemFontOfSize:12]];
        modelSegment.selectedIndex = self.selectedModelIndex;
        modelSegment.delegate = self;
        [self.modeSelectView addSubview:modelSegment];
    }
    return _modelSegment;
}
//性别组选择
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
        groupSegment.selectedIndex = self.selectedGroupIndex;

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
//颜色选择
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
        colorSegment.selectedIndex = self.selectedColorIndex;
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
//尺寸选择
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
        sizeSegment.selectedIndex = self.selectedSizeIndex;
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
- (UIView *)infoView
{
    if (_infoView == nil) {
        
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0,self.modeSelectView.height - 30, self.view.width, 30)];
        
        
         //尺寸信息
        UIButton *sizeInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sizeInfoBtn setTitle:@"尺寸说明" forState:UIControlStateNormal];
        [sizeInfoBtn setTitleColor:HooColor(234, 81, 96) forState:UIControlStateNormal];
        [sizeInfoBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        sizeInfoBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [sizeInfoBtn setImage:[UIImage imageNamed:@"Tshirt_Btn_Style_Info"] forState:UIControlStateNormal];
        [sizeInfoBtn addTarget:self action:@selector(getSizeInfo:) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:sizeInfoBtn];
        sizeInfoBtn.frame = CGRectMake(infoView.width - 80, 0, 80, 30);
        

        //产品品质信息
        UIButton *modelInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [modelInfoBtn setTitle:@"款式说明" forState:UIControlStateNormal];
        [modelInfoBtn setTitleColor:HooColor(234, 81, 96) forState:UIControlStateNormal];
        [modelInfoBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        modelInfoBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [modelInfoBtn setImage:[UIImage imageNamed:@"Tshirt_Btn_Style_Info"] forState:UIControlStateNormal];
        [modelInfoBtn addTarget:self action:@selector(getModelInfo:) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:modelInfoBtn];
        modelInfoBtn.frame = CGRectMake(infoView.width - 160, 0, 80, 30);
        [self.modeSelectView addSubview:infoView];
        _infoView = infoView;
        
    }
    return _infoView;
}

- (void)getSizeInfo:(UIButton *)sender
{
    if (self.product.product_size_infoURL) {
        HooProductInfoController *sizeInfoCtrl = [[HooProductInfoController alloc] init];
        sizeInfoCtrl.title = @"尺寸说明";
        sizeInfoCtrl.infoURL = self.product.product_size_infoURL;
        [self.navigationController pushViewController:sizeInfoCtrl animated:YES];
    }

}
- (void)getModelInfo:(UIButton *)sender
{
    if (self.productModels.count) {
        HooProductModel *model = [self.productModels objectAtIndex:self.selectedModelIndex];
        if (model.model_infoURL) {
            HooProductInfoController *modelInfoCtrl = [[HooProductInfoController alloc] init];
            modelInfoCtrl.title = @"产品说明";
            modelInfoCtrl.infoURL = model.model_infoURL;
            [self.navigationController pushViewController:modelInfoCtrl animated:YES];
        }
    }

}


//模板选择视图
- (UIView *)maskSelectView
{

    if (_maskSelectView == nil) {
         UIView *maskSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, 85)];
        maskSelectView.backgroundColor = HooColor(40, 50, 62);
        for (int i = 0; i< 4; i++) {

            NSString *imageName = [NSString stringWithFormat:@"Tshirt_Temp_NO%d_Card",i];
            UIImage *btnImage = [UIImage imageNamed:imageName];
            UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.tag = 500 + i;
            [maskBtn setImage:btnImage forState:UIControlStateNormal];
            [maskBtn addTarget:self action:@selector(applyMask:) forControlEvents:UIControlEventTouchUpInside];
            [maskSelectView addSubview:maskBtn];
            maskBtn.frame = CGRectMake(i * (btnImage.size.width + 10) + 10, 10, btnImage.size.width, btnImage.size.height);
        }
        [self.view insertSubview:maskSelectView belowSubview:self.tabView];
        _maskSelectView = maskSelectView;
    }
    return _maskSelectView;
}

- (void)applyMask:(UIButton *)sender
{
    NSInteger index = sender.tag - 500;
    NSString *imageName = [NSString stringWithFormat:@"Tshirt_Temp_NO%ld_Big",(long)index];
    NSString *imageFile = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    UIImage *maskedImage = [UIImage imageWithContentsOfFile:imageFile];
    
    self.photoImageView.image = [self.printImage maskedImage:maskedImage];

}

//图文来源选择视图
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




#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    pickedImage = [pickedImage fixOrientation];
    //[self dismissViewControllerAnimated:YES completion:nil];
    if (pickedImage) {
        UIImage *image = [UIImage compressImage:pickedImage toMaxFileSize:1000 * 1000];
        XDEditImageController *editCtrl = [[XDEditImageController alloc] initWithImage:image];
        if (self.paternRatio != 0) {
                CGFloat min = MIN(self.paternsize.width, self.paternsize.height);
                CGFloat max = MAX(self.paternsize.width, self.paternsize.height);
            editCtrl.ratio = min / max;
        }
        [picker pushViewController:editCtrl animated:YES];
    }
    [self closePopView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self closePopView];
}



- (void)setPaternsize:(CGSize)paternsize
{
    _paternsize = paternsize;
    
    CGSize photoImageViewSize = CGSizeMake(paternsize.width * self.paternRatio, paternsize.height * self.paternRatio);
    [self.photoImageView autoRemoveConstraintsAffectingView];
    [self.photoImageView autoCenterInSuperview];
    [self.photoImageView autoSetDimensionsToSize:photoImageViewSize];



}

#pragma mark - 视图初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}
- (void)setupView
{
    
    self.view.backgroundColor = HooColor(248, 248, 248);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ay_table_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeController)];
    
    // 打印图片为空时设置一个默认的打印图片
    if (_printImage == nil) {
        
        NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"Default_Image" ofType:@"jpg"];
        self.printImage = [UIImage imageWithContentsOfFile:imageFile];
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopView)];
    tap.numberOfTapsRequired = 1;
    [self.productImageView addGestureRecognizer:tap];
    
    if ([self respondsToSelector:@selector(imageEditFinished:)]) {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(imageEditFinished:) name: kNotificationFinishEditImage object: nil];
    }

    
    
    self.tabView.delegate = self;
    [self.tabView switchTabIndex:0];
    //提示用户选择产品
    if (self.productModels.count > 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择您的产品款式"];
    }


}

//XDEditImageController发起kNotificationFinishEditImage通知调用的方法
- (void)imageEditFinished:(NSNotification *)aNotification
{
    NSData *imageData = [aNotification object];
    self.printImage = [UIImage imageWithData:imageData];
    self.photoImageView.image = self.printImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = HooColor(234, 81, 96);
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.translucent = YES;
}
//退出当前控制器
- (void)closeController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//关闭弹出tabView弹出的视图
- (void)closePopView
{
    __weak typeof(self) weakSelf = self;
     [self.tabView.tabItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         __strong typeof(self) strongSelf = self;
         RKTabItem *item = (RKTabItem *)obj;
         if (item.tabState == TabStateEnabled) {
           [strongSelf tabView:weakSelf.tabView tabBecameDisabledAtIndex:idx tab:item];
             item.tabState = TabStateDisabled;
             [strongSelf.tabView setTabContent:item];
         }
     }];

}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - RKTabViewDelegate

- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem {
    //单击款式
    if (index == 0) {
        self.modeSelectView.tag = 100 + index;
    }
    //单击照片选项
    if (index == 1 && _photoImageView != nil) {
        self.photoSelectView.tag = 100 + index;
    }
    //单击编辑选项
    if (index == 2 && _photoImageView.image != nil) {
        if(self.photoImageView.image){
            CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:self.photoImageView.image delegate:self];
            CLImageToolInfo *textTool = [editor.toolInfo subToolInfoWithToolName:@"CLTextTool" recursive:NO];
            textTool.dockedNumber = -1;
            CLImageToolInfo *stickTool = [editor.toolInfo subToolInfoWithToolName:@"CLStickerTool" recursive:NO];
            stickTool.dockedNumber = -1;
            CLImageToolInfo *toneCurveTool = [editor.toolInfo subToolInfoWithToolName:@"CLEmoticonTool" recursive:NO];
            toneCurveTool.dockedNumber = -1;
            [self presentViewController:editor animated:YES completion:nil];
        }
    }
    //单击模板选项
    if (index == 3 && _photoImageView.image != nil) {
        self.maskSelectView.tag = 100 + index;
        
    }
    
    UIView *view = [self.view viewWithTag:100+index];
    if (view != nil) {
        [UIView animateWithDuration:HooDuration/2
                         animations:^{
                             view.transform = CGAffineTransformMakeTranslation(0, -(view.height + 50));
                             self.productImageView.transform = CGAffineTransformMakeTranslation(0, -50);
                         }];
        
    }
    //单击购买选项相应事件
    if (index == 4 && _photoImageView != nil) {
        
        if ([[HooUserManager manager] getCurrentUser]) {
            NSString *product_name = self.product.product_name;
            NSString *model_name = self.selectedModel.model_name;
            NSString *group_name = self.selectedGroup.group_name;
            NSString *color_name = self.selectedColor.color_name;
            NSString *size_value = self.selectedSize.size_value;
            NSString *size_unit = self.selectedSize.size_unit;
            
            
            if (color_name == nil) {
                [SVProgressHUD showInfoWithStatus:@"请选择一款产品"];
                return;
            }
            if (self.productImageView.image == nil || self.photoImageView.image == nil) {
                [SVProgressHUD showInfoWithStatus:@"抱歉，网络原因，您需要重新设计！"];
                return;
            }
            
            NSString *title = [NSString stringWithFormat:@"确定购买%@?",product_name];
            NSString *message = [NSString stringWithFormat:@"款式:%@,%@,%@",model_name,group_name,color_name];
            if (size_value) {
                NSString *sizeStr = [NSString stringWithFormat:@",%@%@",size_value,size_unit];
                message = [message stringByAppendingString:sizeStr];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];

        }else{
            [SVProgressHUD showInfoWithStatus:@"您需要先登录才能购买"];
            HooLoginController *loginCtrl = [[HooLoginController alloc] init];
            loginCtrl.fromEdit = YES;
            HooStopAutoRotationNaviController *navi = [[HooStopAutoRotationNaviController alloc] initWithRootViewController:loginCtrl];
            [self presentViewController:navi animated:YES completion:nil];
        }

        tabItem.tabState = TabStateEnabled;
        
    }
    
}


- (void)tabView:(RKTabView *)tabView tabBecameDisabledAtIndex:(NSUInteger)index tab:(RKTabItem *)tabItem {
    
    UIView *view = [self.view viewWithTag:100+index];
    if (view != nil) {
        
        [UIView animateWithDuration:HooDuration/2
                         animations:^{
                             view.transform = CGAffineTransformIdentity;
                             self.productImageView.transform = CGAffineTransformIdentity;
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
        [self sizeSegmentSelected:index];
    }
}

- (void)modelSegmentSelected:(NSInteger)index
{
    self.selectedModelIndex = index;
    self.selectedModel = self.productModels[index];
    NSString *model_price = self.selectedModel.model_price;
    [self.priceButton setTitle:model_price forState:UIControlStateNormal];
    
    
    [self.productGroups removeAllObjects];
    [self.productGroups addObjectsFromArray:self.selectedModel.groups];

    [self.groupSegment removeFromSuperview];
    self.groupSegment = nil;
    self.selectedGroup = nil;
    [self.colorSegment removeFromSuperview];
    self.colorSegment = nil;

    self.selectedColor = nil;
    [self.sizeSegment removeFromSuperview];
    self.sizeSegment = nil;

    self.selectedSize = nil;
    
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
    self.selectedGroupIndex = index;

    self.selectedGroup = self.productGroups[index];
    
    [self.productColors removeAllObjects];
    [self.productColors addObjectsFromArray:self.selectedGroup.colors];
    

    [self.colorSegment removeFromSuperview];
    self.colorSegment = nil;
    self.selectedColor = nil;
    [self.sizeSegment removeFromSuperview];
    self.sizeSegment = nil;

    self.selectedSize = nil;

    
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
    self.selectedColorIndex = index;

    self.selectedColor = self.productColors[index];
    [self.productSizes removeAllObjects];
    [self.productSizes addObjectsFromArray:self.selectedColor.sizes];
    

    [self setupProductImageViewWithImageURL:self.selectedColor];
    
    [self.sizeSegment removeFromSuperview];
    self.sizeSegment = nil;
    self.selectedSize = nil;
    
    NSMutableArray *buttonTitles = [NSMutableArray array];
    for (HooProductSize *size in self.productSizes) {
        NSString *size_value = size.size_value;
        [buttonTitles addObject:size_value];
    }
    if (buttonTitles.count > 0) {
        
        self.sizeSegment.buttonTitles = buttonTitles;

    }
}
//获得color对象的数据，填充ProductView
- (void)setupProductImageViewWithImageURL:(HooProductColor *)color
{
    NSURL *product_imageURL = color.product_imageURL;
    NSString *patern_size = color.patern_size;
    NSInteger product_inventory_count = color.product_inventory_count;
    CGFloat size_ratio = color.size_ratio;
    
    
    if (product_imageURL) {
        //添加产品视图
        [self.productImageView sd_setImageWithURL:product_imageURL placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSInteger progress = receivedSize / expectedSize;
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showProgress:progress status:@"正在加载产品图片..."];

            });
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //显示库存数量按钮
                [self.inventoryButton setTitle:[NSString stringWithFormat:@"数量:%ld",(long)product_inventory_count] forState:UIControlStateNormal];
                //添加图片视图
                if (patern_size && size_ratio) {
                    self.paternRatio = size_ratio;
                    self.paternsize = CGSizeFromString(patern_size);
                    
                }
            });
            [SVProgressHUD dismiss];
            


        }];
    }
}
- (void)sizeSegmentSelected:(NSInteger)index
{
    self.selectedSizeIndex = index;
    self.selectedSize = self.productSizes[index];
}


#pragma mark- CLImageEditor delegate

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    self.photoImageView.image = image;
    self.printImage = image;
    
    [editor dismissViewControllerAnimated:YES completion:nil];
    [self closePopView];
}
- (void)imageEditorDidCancel:(CLImageEditor *)editor
{
    [self closePopView];
    [editor dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
    if (buttonIndex == 1) {
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showProgress:0.0 status:[NSString stringWithFormat:@"正在上传你的设计，共%d张",2]];
        OrderedProduct *orderedProduct = [[OrderedProduct alloc] init];
        UIImage *designed_image = [UIImage imageDrawInView:self.productImageView Inrect:self.productImageView.bounds];
        UIImage *origin_image = self.photoImageView.image;

        NSData *origin_imageData = [UIImage compressImageDataWithImage:origin_image toMaxDataSize:1000 * 1000];
        NSData *designed_imageData = [UIImage compressImageDataWithImage:designed_image toMaxDataSize:100 * 1000];
        
        if (self.selectedModel){
            orderedProduct.product_name = self.product.product_name;
            orderedProduct.model_name = self.selectedModel.model_name;
            orderedProduct.product_price = self.selectedModel.model_price;
        }
        if (self.selectedGroup) orderedProduct.group_name = self.selectedGroup.group_name;
        if (self.selectedColor){
            orderedProduct.color_name = self.selectedColor.color_name;
            orderedProduct.product_inventory_count = self.selectedColor.product_inventory_count;
        }
        if (self.selectedSize) orderedProduct.size_value = self.selectedSize.size_value;

        [[HooOrderedProductManager manager] uploadOrderedProductWithOriginImageData:origin_imageData andDesignedImageData:designed_imageData WithOrderedProduct:orderedProduct WithResultBlock:^(BOOL isSuccessful, NSError *error){
            [SVProgressHUD dismiss];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            
            if (error) {
                HooLog(@"orderedProduct上传%@",error);
                [SVProgressHUD showInfoWithStatus:@"上传数据不成功"];
            }
            if (isSuccessful) {
                //传值
                HooOrderPayController *orderCtrl = [[HooOrderPayController alloc] init];
                orderCtrl.orderedProduct = orderedProduct;
                orderCtrl.orderedProduct_thumbImage = designed_image;
                [weakSelf.navigationController pushViewController:orderCtrl animated:YES];
            }
        } andProgress:^(NSUInteger index, CGFloat progress) {
            //index表示正在上传的文件其路径在数组当中的索引，progress表示该文件的上传进度
            [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"正在上传你的设计，共%d张",2]];
        }];
        
    }
}



//释放通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    HooLog(@"dealloc");
}

@end
