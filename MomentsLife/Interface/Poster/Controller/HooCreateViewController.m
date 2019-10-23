//
//  HooCreateViewController.m
//  MomentsLife
//
//  Created by HooJackie on 15/8/14.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <Photos/Photos.h>
#import "HooCreateViewController.h"
#import "HooQuotesViewController.h"
#import "HooMainNavigationController.h"
#import "HooQuotesImageController.h"
#import "HooQuotesImageController.h"

#import "HooTextViewCell.h"
#import "HooTextView.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "HooHeaderView.h"
#import "NSDate+Extension.h"
#import "HooSqlliteTool.h"
#import "HooSaveTools.h"
#import "UIImage+Utility.h"
#import "SVProgressHUD.h"
@interface HooCreateViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,HooQuotesViewControllerDelegate,UITextViewDelegate,HooQuotesImageControllerDelegate>

@property (nonatomic,strong) NSArray *dataList;



@property (weak, nonatomic) HooTextView *textView;

@property (nonatomic,strong) UISwitch *switchView;

@property (weak, nonatomic)HooHeaderView *headerView;

@property (nonatomic,assign,getter=isShowHeaderView) BOOL showHeaderView;

@property (nonatomic,assign,getter=isshowquote) BOOL showquote;

@property (nonatomic,strong) UIImage *momentImage;

@end

@implementation HooCreateViewController

#pragma mark  - 懒加载
- (HooMoment *)moment
{
    if (_moment == nil) {
        _moment = [[HooMoment alloc] init];
        
        
        _moment.fontColorR = 1.0;
        _moment.fontColorG = 1.0;
        _moment.fontColorB = 1.0;
        _moment.fontSize = 17.0;
        _moment.fontName = @"Avenir-HeavyOblique";
        //设置默认为自己创建
        _moment.author = @"Me";
        
        HooPhoto *photo = [[HooPhoto alloc] init];
        photo.style = @"BLACK_BARS";
        photo.positionX = 50.0;
        photo.positionY = 50.0;
        
        //设置照片和缩略图的名称
        NSInteger currentPhotoID = [HooSaveTools integerForkey:PhotoID];
        [HooSaveTools setInteger:currentPhotoID + 1 forKey:PhotoID];
        NSString *photoName = [NSString stringWithFormat:@"MomentPhoto_%ld.jpg",(long)currentPhotoID];
        NSString *photo_thumb_Name = [NSString stringWithFormat:@"MomentPhoto_%ld_thumb.jpg",(long)currentPhotoID];
        photo.image_filename = photoName;
        photo.image_thumb_filename = photo_thumb_Name;
        
        //设置照片默认为非加星（喜欢）
        photo.isFavorite = NO;
        
        _moment.photo = photo;
        
    }
    return _moment;
}


- (NSArray *)dataList
{
    if (_dataList == nil) {
        _dataList = @[@"选择文字",@"自动生成",@"选择图片",@"显示/隐藏文字"];
    }
    return _dataList;
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _switchView;
}
- (void)switchValueChanged:(UISwitch *)sender
{
    self.showquote = sender.on;
    self.headerView.showQuote = self.showquote;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //初始化控制器
    [self setupViewController];

    //授权访问照片库
    //[self authorizeToAccessPhotoAlbum];
    
    if(self.isFromAuto){
        [self autoCreateMomentAndShowHeaderView];
    }
    if (self.isFromEdit) {
        [self editMoment];
        self.title = @"编辑丁丁时刻";
    }else{
        self.title = @"记录丁丁时刻";
    }
}
#pragma mark - 初始化控制器
- (void)setupViewController
{
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tap];

}
- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save
{

    
    //设置创建和修改时间
    NSString *intervalString = [[NSDate date] convertDateTointervalString];
    
    self.moment.modified_date = intervalString;
    

    
    BOOL flag;
    if (self.isFromEdit) {//如果是编辑模式，我们就更新数据库
       flag = [HooSqlliteTool updateMyMoment:self.moment];
    }else{//其他情况我们这里只有新建模式，新建模式就插入新数据到数据库
        self.moment.created_date = intervalString;
        //执行插入数据库操作
        flag = [HooSqlliteTool addNewMyMoment:self.moment];
        
    }
    if (flag) {
        [SVProgressHUD showSuccessWithStatus:@"太棒了,丁丁记创建成功!"];
        //保存按钮改为不可用状态
        self.navigationItem.rightBarButtonItem.enabled = NO;
        //保存原图片到沙盒
        UIImage *cropedImage = [self.momentImage aspectFill:HooKeyWindow.bounds.size];
        [cropedImage writeImageToDocumentDirectoryWithPhotoName:self.moment.photo.image_filename];
        UIImage *thumbImage = [UIImage imageDrawInView:self.headerView.imageView Inrect:self.headerView.imageView.bounds];
        //保存快照的缩略图片到沙盒
        [thumbImage writeImageToDocumentDirectoryWithPhotoName:self.moment.photo.image_thumb_filename];
        
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:1];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"哦哦，小意外，保存失败，请再试试"];

    }
}

- (void)hideKeyboard:(UIGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (indexPath == nil || indexPath.section != 0 || indexPath.row != 0) {
        [self.textView resignFirstResponder];
    }
}
#pragma mark - 授权访问照片库

- (void)authorizeToAccessPhotoAlbum
{
    //获取是否授权访问照片库
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        switch (status) {
                //已授权则访问照片库，并随机获取一张照片
            case PHAuthorizationStatusAuthorized:
                
                break;
                
            default:
                //未授权则弹出提示
               // [self showNoAccessAlertAndCancel];
                break;
        }
    }];
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
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = selectedCell.frame;
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Table view data source 数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0){
        return 2;
    }else{
        return 3;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"添加文字";
    }else{
        return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0 && indexPath.section == 0){
        
        HooTextViewCell *createPosterCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (createPosterCell == nil) {
            createPosterCell = [[[NSBundle mainBundle] loadNibNamed:@"HooTextViewCell" owner:nil options:nil] lastObject];
        }
        self.textView = createPosterCell.textView;
        self.textView.delegate = self;
        createPosterCell.text = self.moment.quote;
        return createPosterCell;
    
    }else{
        static NSString *ID = @"CreateCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 0 && indexPath.row == 1) {
            
            cell.textLabel.text = self.dataList[0];
        }
        if (indexPath.row == 0 && indexPath.section == 1) {
            cell.textLabel.text = self.dataList[1];
        }
        if (indexPath.row == 1 && indexPath.section == 1) {
            cell.textLabel.text = self.dataList[2];
        }
        
        
        if (indexPath.row == 2 && indexPath.section == 1){
            static NSString *switchID = @"switchCell";
            UITableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:switchID];
            if (switchCell == nil) {
                switchCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchID];
                switchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
            switchCell.accessoryView = self.switchView;
            switchCell.textLabel.text = self.dataList[3];
            switchCell.hidden = !self.showHeaderView;
            self.switchView.on = self.showquote;
            return switchCell;
        
        }
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1){
        return self.showHeaderView ? 350 : 50;
    }else{
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 && self.showHeaderView) {
        HooHeaderView *headerView = [HooHeaderView headerView];
        headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.sectionHeaderHeight);
        
        headerView.moment = self.moment;
        if (self.momentImage) {
            
            headerView.headerImage = self.momentImage;
        }
        
        self.headerView = headerView;
        return headerView;
    }
    
    return nil;
}


#pragma mark - UITableViewDelegate 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        HooQuotesViewController *quotesCtrl = [[HooQuotesViewController alloc] init];
        quotesCtrl.from = @"create";
        quotesCtrl.delegate = self;
        [self.navigationController pushViewController:quotesCtrl animated:YES];
        
    }
    
    if (indexPath.row == 0 && indexPath.section == 1) {
        
        [self autoCreateMomentAndShowHeaderView];
        

    }
    if (indexPath.row == 1 && indexPath.section == 1) {
        [self showPhotoSelectMenu];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)editMoment
{
    NSString *imageName = self.moment.photo.image_filename;
    UIImage *image = [UIImage imageForPhotoName:imageName];
    
    self.momentImage = image;
    if (self.momentImage == nil) return;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.showHeaderView = YES;
    self.showquote = YES;
    [self.tableView reloadData];

}
#pragma mark - 单击section 1, row 0后的操作
//自动生成Moment
- (void)autoCreateMomentAndShowHeaderView
{
    __weak __typeof(self)weakSelf = self;
    self.momentImage = [UIImage getRandomImageFromPhotoLibrary:^(NSString *failAuthorizationInfo) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showNoAccessAlertAndCancel:failAuthorizationInfo];
    }];
    
    if (self.momentImage == nil) return;
    
    HooMoment *randomMoment = [HooSqlliteTool randomMoment];
    
    self.moment.quote = randomMoment.quote;
    
    self.moment.photo.style = randomMoment.photo.style;
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.showHeaderView = YES;
    self.showquote = YES;
    [self.tableView reloadData];
}
#pragma mark - 单击section 1, row 1后的操作
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
    
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    alertCtrl.popoverPresentationController.sourceView = self.view;
    alertCtrl.popoverPresentationController.sourceRect = selectedCell.frame;

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
    quotesImageCtrl.showQuote = NO;
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
        self.momentImage = pickedImage;
        [self CreateMomentAndShowHeaderView];
    }

    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)CreateMomentAndShowHeaderView
{
    if (self.momentImage == nil) return;

    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.showHeaderView = YES;
    self.showquote = YES;
    [self.tableView reloadData];
    
}

#pragma mark - HooQuotesViewControllerDelgate
- (void)quoteDidSelected:(NSString *)quote author:(NSString *)author
{
    self.moment.quote = quote;
    
    [self.tableView reloadData];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    
    self.moment.quote = textView.text;
    self.headerView.moment = self.moment;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
#pragma mark - HooQuotesImageControllerDelegate
- (void)selectMoment:(HooMoment *)moment
{
    NSString *imageName = moment.photo.image_thumb_filename;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    if (imagePath == nil) {
        self.momentImage = [UIImage imageNamed:@"gridempty"];
    }else{
        self.momentImage = [UIImage imageWithContentsOfFile:imagePath];
    }
    [self CreateMomentAndShowHeaderView];
}


@end
