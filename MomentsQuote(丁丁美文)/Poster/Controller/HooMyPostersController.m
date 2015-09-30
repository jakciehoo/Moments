//
//  HooPosterViewController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/13.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import "HooMyPostersController.h"
#import "HooQuoteController.h"
#import "HooCreateViewController.h"
#import "HooPosterCell.h"
#import "HooCreateCell.h"
#import "NSDate+Extension.h"
#import "HooSqlliteTool.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "SVProgressHUD.h"
#import "UIImage+Utility.h"
#import "HooShareTool.h"



@implementation HooMyPostersController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"丁丁记";
    
    [self loadCreateList];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadMyPosters];
}
#pragma mark - 加载模型

- (void)loadCreateList
{
    [self.createList addObject:@"动手创作"];
    [self.createList addObject:@"懒人方法"];
}

//重新加载
- (void)loadMyPosters
{

    [self.myPosters removeAllObjects];
    [self loadMoreMyPosters];
    [self.tableView headerEndRefreshing];
}
//加载更多
- (void)loadMoreMyPosters
{
    if (self.myPosters.count == 0) {
        NSDate *now = [NSDate date];
        NSString *nowString = [now convertDateTointervalString];
        NSArray *moments = [HooSqlliteTool getMyMomentsBefore:nowString LimitCount:5];
        [self.myPosters addObjectsFromArray:moments];
    }else{
        HooMoment *lastMoment = (HooMoment *)self.myPosters.lastObject;
        NSArray *moreMoments = [HooSqlliteTool getMyMomentsBefore:lastMoment.modified_date LimitCount:5];
        [self.myPosters addObjectsFromArray:moreMoments];
    }
    [self.tableView footerEndRefreshing];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.createList.count) {
        HooCreateViewController *createCtrl = [[HooCreateViewController alloc] initWithStyle:UITableViewStyleGrouped];
        if(indexPath.row == 1){
            createCtrl.fromAuto = YES;
        }
        [self.navigationController pushViewController:createCtrl animated:YES];
    }else{
        HooMoment *moment = self.myPosters[indexPath.row-self.createList.count];
    
        [self showMenu:moment];
    }
}
- (void)showMenu:(HooMoment *)moment
{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCtrl addAction:cancelAction];
    
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //编辑
        [self editMoment:moment];
    }];
    [alertCtrl addAction:editAction];

    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
            UIAlertController *deleteCtrl = [UIAlertController alertControllerWithTitle:@"确定要删除吗？" message:@"删除了就不可恢复了，你确定要删除创建的美图美文吗？" preferredStyle:UIAlertControllerStyleAlert];
        
            UIAlertAction *cancelDeleteAction = [UIAlertAction actionWithTitle:@"保留" style:UIAlertActionStyleCancel handler:nil];
        [deleteCtrl addAction:cancelDeleteAction];
        
        UIAlertAction *confirmDeleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //删除
            [self deleteMoment:moment];
        }];
        [deleteCtrl addAction:confirmDeleteAction];
        [self presentViewController:deleteCtrl animated:YES completion:nil];
        
    }];
    [alertCtrl addAction:deleteAction];
    
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *image_thumbName = moment.photo.image_thumb_filename;
        UIImage *image = [UIImage imageForPhotoName:image_thumbName];
        [HooShareTool showshareAlertControllerIn:self.view WithImage:image andFileName:image_thumbName];
    }];
    [alertCtrl addAction:shareAction];
    
//    UIAlertAction *showContentAction = [UIAlertAction actionWithTitle:@"显示详细内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//    }];
    //[alertCtrl addAction:showContentAction];

    
    UIAlertAction *showAction = [UIAlertAction actionWithTitle:@"查看大图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        HooQuoteController *quoteCtrl = [[HooQuoteController alloc] init];
        quoteCtrl.fromMine = YES;
        quoteCtrl.originMoment = moment;
        [self.navigationController pushViewController:quoteCtrl animated:YES];

    }];
    [alertCtrl addAction:showAction];
    

    UIAlertAction *orderAction = [UIAlertAction actionWithTitle:@"印制" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
#warning 添加下订单功能
    }];
    [alertCtrl addAction:orderAction];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}
//编辑
- (void)editMoment:(HooMoment *)moment
{
    HooCreateViewController *createCtrl = [[HooCreateViewController alloc] initWithStyle:UITableViewStyleGrouped];
    createCtrl.fromEdit = YES;
    createCtrl.moment = moment;
    [self.navigationController pushViewController:createCtrl animated:YES];
}
//删除
- (void)deleteMoment:(HooMoment *)moment
{
    
    BOOL flag = [HooSqlliteTool deleteMyMomentWith:moment.ID];
    
    if (!flag) {
        [SVProgressHUD showErrorWithStatus:@"糟糕，难得的意外，删除数据失败，麻烦再试一次！"];
    }else{
        [UIImage removeImageWithImageName:moment.photo.image_filename];
        [UIImage removeImageWithImageName:moment.photo.image_thumb_filename];
        [self.tableView headerBeginRefreshing];
    }
}



@end
