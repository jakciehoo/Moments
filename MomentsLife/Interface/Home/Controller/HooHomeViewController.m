//
//  HooHomeViewController.m
//  MomentsLife
//
//  Created by HooJackie on 15/8/15.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooHomeViewController.h"
#import "HooQuoteView.h"
#import "Hoo500pxImageTool.h"
#import "SVProgressHUD.h"
#import "UIImage+Utility.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "HooSqlliteTool.h"
#import "HooQuotesImageController.h"
#import "Reachability.h"



@interface HooHomeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,HooQuotesImageControllerDelegate>

@property (nonatomic , strong) Reachability *reachability;
@property (nonatomic, weak) UIButton *surpriseButton;

@property (nonatomic, weak) UIButton *camaraButton;

@end

@implementation HooHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //检查当前网络连接状态
    self.tabBarController.tabBar.hidden = YES;

    [Hoo500pxImageTool downloadImageProgress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        HooLog(@"%@",image);
    }];
}

#pragma mark - 检查网络



- (void)downloadNewMoment
{
    [SVProgressHUD showWithStatus:@"正在加载美图"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [Hoo500pxImageTool downloadImageProgress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
        HooLog(@"%f",progress);
        [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"正在下载图片,进度:%.2f%%",progress * 100.0]];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD dismiss];
        
        [image writeImageToDocumentDirectoryWithPhotoName:self.editMoment.photo.image_filename];
        UIImage *thumbImage = [UIImage crop:image InRect:CGRectMake(0, 0, self.view.width, self.view.height/2)];
        [thumbImage writeImageToDocumentDirectoryWithPhotoName:self.editMoment.photo.image_thumb_filename];
    }];
}

#pragma mark - HooEditToolViewDelegate
//重写父类方法
- (void)toolButtonClicked
{
    [super toolButtonClicked];
    [UIView animateWithDuration:HooDuration/2 animations:^{
        self.surpriseButton.alpha = 0.0;
        self.camaraButton.alpha = 0.0;
    }];
}

#pragma mark -  FlowerButtonDelegate
//这里我们重写了父类的方法，添加了两个按钮
- (NSArray *)createOtherViewsIn:(UIView *)superView aboveView:(UIView *)blackView
{
 
    NSMutableArray *mutableArr  = [NSMutableArray array];
    NSArray *viewArray = [super createOtherViewsIn:superView aboveView:blackView];
    [mutableArr addObjectsFromArray:viewArray];
    //supriseButton
    UIButton *surpriseButton =[ self topButtonWithTitle:@"自动生成" imageName:@"surpriseme_flat"];
    [superView insertSubview:surpriseButton aboveSubview:blackView];
    self.surpriseButton = surpriseButton;
    
    [surpriseButton addTarget:self action:@selector(autoCreateNewMoment) forControlEvents:UIControlEventTouchUpInside];
    
    [surpriseButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [surpriseButton autoSetDimensionsToSize:CGSizeMake(90, 30)];
    NSLayoutConstraint *supriseBottom = [surpriseButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:superView];
    //camaraButton
    UIButton *camaraButton = [ self topButtonWithTitle:@"相机相册" imageName:@"surprisecam_flat"];
    [superView insertSubview:camaraButton aboveSubview:blackView];
    [camaraButton addTarget:self action:@selector(manualCreateNewMoment) forControlEvents:UIControlEventTouchUpInside];
    self.camaraButton = camaraButton;
    [camaraButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [camaraButton autoSetDimensionsToSize:CGSizeMake(90, 30)];
    NSLayoutConstraint *camaraBottom = [camaraButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:superView];
    

    

    
    [superView layoutIfNeeded];
    
    [superView removeConstraint:camaraBottom];
    [superView removeConstraint:supriseBottom];

    [camaraButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [surpriseButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    //移除约束
    [UIView animateWithDuration:HooDuration/2 animations:^{
        
        [superView layoutIfNeeded];
        
    }];


    [mutableArr addObject:surpriseButton];
    [mutableArr addObject:camaraButton];

    return mutableArr;
}
//顶部椭圆形button
- (UIButton *)topButtonWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 90, 30)];
    [topButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [topButton setTitle:title forState:UIControlStateNormal];
    topButton.titleLabel.font = [UIFont systemFontOfSize:10];
    topButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [topButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    topButton.backgroundColor = [UIColor whiteColor];
    topButton.layer.cornerRadius = 15;
    topButton.layer.shadowColor = [UIColor blackColor].CGColor;
    topButton.layer.shadowOffset = CGSizeMake(0.0, 1);
    topButton.layer.shadowRadius = 5;
    topButton.layer.shadowOpacity = 0.5;
    return topButton;

}


#pragma mark - camaraButton单击事件
//自动创建
- (void)autoCreateNewMoment
{
    [self.centerButton showOrHideSubviews];
    
    __weak typeof(self) weakSelf = self;
    UIImage *randomImage = [UIImage getRandomImageFromPhotoLibrary:^(NSString *failAuthorizationInfo) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showNoAccessAlertAndCancel:failAuthorizationInfo];
    }];
    self.momentImage = [randomImage aspectFill:HooKeyWindow.bounds.size];
    
    [self CreateNewMoment];
    
    
}

//访问照片未授权时弹出提示
- (void)showNoAccessAlertAndCancel:(NSString *)failIfo
{
    NSString *message = [NSString stringWithFormat:@"%@",failIfo];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        return;
    }]];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = self.surpriseButton.frame;
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - surpriseButton单击事件
- (void)manualCreateNewMoment
{
    [self.centerButton showOrHideSubviews];
    [self showPhotoSelectMenu];
}


//显示选择按钮
- (void)showPhotoSelectMenu
{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCtrl addAction:cancelAction];
    //判断是否允许访问相机，如果允许，显示拍照选择
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertAction *takePhototAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self takePhoto];
        }];
        [alertCtrl addAction:takePhototAction];
    }
    //判断是否允许访问相册，如果允许，显示相册选择
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIAlertAction *chooseFromLibraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self pickFromPhotoAlbum];
        }];
        [alertCtrl addAction:chooseFromLibraryAction];
    }
    
    UIAlertAction *chooseFromGalleryAction = [UIAlertAction actionWithTitle:@"程序图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pickPhotoFromApp];
    }];
    [alertCtrl addAction:chooseFromGalleryAction];
    
    alertCtrl.popoverPresentationController.sourceView = self.view;
    alertCtrl.popoverPresentationController.sourceRect = self.camaraButton.frame;
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}
//从相机拍照
- (void)takePhoto
{
    UIImagePickerController *imagePickerCtrl = [[UIImagePickerController alloc] init];
    imagePickerCtrl.view.tintColor = HooTintColor;
    imagePickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerCtrl.delegate = self;
    imagePickerCtrl.allowsEditing = YES;
    [self presentViewController:imagePickerCtrl animated:YES completion:nil];
}
//从照片库选择
- (void)pickFromPhotoAlbum
{
    UIImagePickerController *imagePickerCtrl = [[UIImagePickerController alloc] init];
    imagePickerCtrl.view.tintColor = HooTintColor;
    imagePickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerCtrl.delegate = self;
    imagePickerCtrl.allowsEditing = NO;
    [self presentViewController:imagePickerCtrl animated:YES completion:nil];
    
}
- (void)pickPhotoFromApp
{
    HooQuotesImageController *quotesImageCtrl = [[HooQuotesImageController alloc] init];
    quotesImageCtrl.QuotesImageDelegate = self;
    [self.navigationController pushViewController:quotesImageCtrl animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    pickedImage = [pickedImage fixOrientation];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (pickedImage) {
        self.momentImage = [pickedImage aspectFill:HooKeyWindow.bounds.size];
        [self CreateNewMoment];
    }
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)CreateNewMoment
{
    if (self.momentImage == nil) return;

    HooMoment *randomMoment = [HooSqlliteTool randomMoment];
    self.quoteView.moment = randomMoment;
    randomMoment.photo.image_filtername = nil;
    self.editMoment = randomMoment;
    self.imageView.image = self.momentImage;
    
    //改成创建模式
    self.mode = MomentModeCreate;
    
}
#pragma mark - HooQuotesImageControllerDelegate
- (void)selectMoment:(HooMoment *)moment
{
    NSString *photo_name = moment.photo.image_filename;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:photo_name ofType:nil];
    self.momentImage = [UIImage imageWithContentsOfFile:imagePath];
    [self CreateNewMoment];
    
}






@end
