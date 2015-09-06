//
//  HooCreateViewController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/14.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooCreateViewController.h"
#import "HooTextViewCell.h"

@interface HooCreateViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) NSArray *dataList;

@end

@implementation HooCreateViewController

- (NSArray *)dataList
{
    if (_dataList == nil) {
        _dataList = @[@"选择文字",@"自动生成",@"选择图片"];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source 数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
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
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}


#pragma mark - UITableViewDelegate 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        HooLog(@"选中行1");
    }
    
    if (indexPath.row == 0 && indexPath.section == 1) {

    }
    if (indexPath.row == 1 && indexPath.section == 1) {
        [self pickPhoto];
    }
}

- (void)pickPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showPhotoSelectMenu];
    }else{
    
    }

}

- (void)showPhotoSelectMenu
{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCtrl addAction:cancelAction];
    UIAlertAction *takePhototAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self takePhoto];
    }];
    [alertCtrl addAction:takePhototAction];
    UIAlertAction *chooseFromLibraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertCtrl addAction:chooseFromLibraryAction];
    UIAlertAction *chooseFromGalleryAction = [UIAlertAction actionWithTitle:@"网络" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertCtrl addAction:chooseFromGalleryAction];
}
- (void)takePhoto
{
    UIImagePickerController *imagePickerCtrl = [[UIImagePickerController alloc] init];
    imagePickerCtrl.view.tintColor = HooTintColor;
    imagePickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerCtrl.delegate = self;
    imagePickerCtrl.allowsEditing = YES;
    [self presentViewController:imagePickerCtrl animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
}


@end
