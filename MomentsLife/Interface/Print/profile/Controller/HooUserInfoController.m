//
//  HooUserInfoController.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/19.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "HooUserInfoController.h"
#import "HooOrderAddressController.h"
#import "HooLoginController.h"
#import "HooUserManager.h"
#import "XHPathCover.h"
#import "UIImage+Utility.h"
#import "SVProgressHUD.h"

#define HooUserIconPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"userIcon.png"]


@interface HooUserInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) XHPathCover *pathCover;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation HooUserInfoController


- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
    }
    return self;
}

- (NSArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = @[@"地址管理",@"修改用户名称"];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupView];

}
- (void)setupView
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ay_table_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeController)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出账号" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationController.navigationBar.tintColor = HooColor(234, 81, 96);
    
    self.title = @"个人信息";

    
    XHPathCover *pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 213)];
    BmobUser *user = [[HooUserManager manager] getCurrentUser];
    
    if (user) {
        [pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:user.username, XHUserNameKey, nil]];
    }

    if ([[NSFileManager defaultManager] fileExistsAtPath:HooUserIconPath]) {
        [pathCover setAvatarImage:[UIImage imageWithContentsOfFile:HooUserIconPath]];
    }else{
        [pathCover setAvatarImage:[UIImage imageNamed:@"userIcon"]];
    }
    
    [pathCover setBackgroundImage:[UIImage imageNamed:@"banner"]];
    [pathCover.avatarButton addTarget:self action:@selector(showPhotoSelectMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableView.tableHeaderView = pathCover;
    _pathCover = pathCover;

    
    __weak typeof(self) wself = self;
    [self.pathCover setHandleRefreshEvent:^{
        [wself refreshing];
    }];
}
- (void)refreshing {
    
    __weak typeof(self) wself = self;
    
    BmobUser *user = [[HooUserManager manager] getCurrentUser];
    
    if (user) {
        [wself.pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:user.username, XHUserNameKey, nil]];
    }
    
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [wself.pathCover stopRefresh];
    });
}
- (void)closeController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)logout
{
    [[HooUserManager manager] logout];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_pathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_pathCover scrollViewWillBeginDragging:scrollView];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.dataSource.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    cell.textLabel.text = self.dataSource[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HooOrderAddressController *orderAddressCtrl = [[HooOrderAddressController alloc] init];
        [self.navigationController pushViewController:orderAddressCtrl animated:YES];
    }
    if (indexPath.section == 1) {
        [self changeUserName];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - 修改用户名
- (void)changeUserName
{
    __weak typeof(self) wself = self;
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"修改用户名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCtrl addAction:cancelAction];
    [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField *textField){
        BmobUser *user = [[HooUserManager manager] getCurrentUser];;
        textField.placeholder = [NSString stringWithFormat:@"当前用户名: %@", user.username];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        UITextField *userNameTextField = alertCtrl.textFields.firstObject;
        [[HooUserManager manager] changeUserName:userNameTextField.text block:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                HooLog(@"修改用户名成功");
                [wself refreshing];

            }
            if (error) {
                HooLog(@"%@",error);
                [SVProgressHUD showErrorWithStatus:@"用户名被占用了，请换一个名称"];
            }
        }];
        
    }];
    okAction.enabled = NO;
    [alertCtrl addAction:okAction];

    [self presentViewController:alertCtrl animated:YES completion:nil];

}
//通知
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *userName = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = userName.text.length > 2;
    }
}

#pragma mark - 选择头像
//显示选择按钮
- (void)showPhotoSelectMenu:(UIButton *)sender
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
    alertCtrl.popoverPresentationController.sourceView = self.view;
    alertCtrl.popoverPresentationController.sourceRect = sender.frame;
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


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    pickedImage = [pickedImage fixOrientation];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (pickedImage) {
        
        UIImage *iconImage = [pickedImage aspectFill:self.pathCover.avatarButton.bounds.size];
        NSData *imageData = UIImageJPEGRepresentation(iconImage, 1.0);
        [imageData writeToFile:HooUserIconPath atomically:YES];
        [self.pathCover setAvatarImage:iconImage];
    }

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}









@end
