//
//  HooUnPayedOrderController.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/11.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooUnPayedOrderController.h"
#import "HooOrderInfoController.h"
#import "HooStopAutoRotationNaviController.h"
#import "HooCreateCell.h"
#import "HooPosterCell.h"
#import "HooProduct.h"
#import "HooProductCategory.h"
#import "SVProgressHUD.h"
#import "HooUserManager.h"
#import "HooOrderManager.h"
#import "Order.h"
#import "HooShareTool.h"

@interface HooUnPayedOrderController ()

@property (nonatomic, strong)NSMutableArray *orders;

@property (nonatomic, strong)NSMutableArray *orderedProducts;

@property (nonatomic, strong)NSMutableArray *orderAddresses;

@property (nonatomic, strong)NSMutableArray *orderDeliveries;

@end

@implementation HooUnPayedOrderController

static NSString *PosterCellID = @"PosterCell";

#pragma mark - 懒加载

- (NSMutableArray *)orders
{
    if (_orders == nil) {
        _orders = [NSMutableArray array];
    }
    return _orders;
}
- (NSMutableArray *)orderedProducts
{
    if (_orderedProducts == nil) {
        _orderedProducts = [NSMutableArray array];
    }
    return _orderedProducts;
}
- (NSMutableArray *)orderAddresses
{
    if (_orderAddresses == nil) {
        _orderAddresses = [NSMutableArray array];
    }
    return _orderAddresses;
}
- (NSMutableArray *)orderDeliveries
{
    if (_orderDeliveries == nil) {
        _orderDeliveries = [NSMutableArray array];
    }
    return _orderDeliveries;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的购物车";
}

- (void)loadMyPosters
{
    [self.myPosters removeAllObjects];
    [self.orders removeAllObjects];
    [self.orderedProducts removeAllObjects];
    [self.orderAddresses removeAllObjects];
    [self.orderDeliveries removeAllObjects];
    [self loadMoreMyPosters];
    [self.tableView headerEndRefreshing];
    
    
}
- (void)loadMoreMyPosters
{
    //    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    //    [SVProgressHUD showWithStatus:@"正在加载您的设计"];
    [[HooOrderManager manager] unPayOrdersSkip:self.orders.count WithBlock:^(NSArray *orders, NSArray *orderedProducts, NSArray *orderAddresses, NSArray *orderDeliveries, NSError *error) {
        //        [SVProgressHUD dismiss];
        //        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        if (error) {
            //            [SVProgressHUD showErrorWithStatus:@"网路不给力，加载数据失败"];
            return;
        }
        if (orders.count) {
            [self.orders addObjectsFromArray:orders];
            [self.orderedProducts addObjectsFromArray:orderedProducts];
            [self.orderAddresses addObjectsFromArray:orderAddresses];
            [self.orderDeliveries addObjectsFromArray:orderDeliveries];
            [self.myPosters addObjectsFromArray:orderedProducts];
            [self.tableView reloadData];
        }
    }];
    [self.tableView footerEndRefreshing];
    [self.tableView reloadData];
    
}

#pragma mark - UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        HooPosterCell *cell = [tableView dequeueReusableCellWithIdentifier:PosterCellID forIndexPath:indexPath];
        cell.orderedProduct = self.myPosters[indexPath.row];
        
        return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self showMenuForIndexPath:indexPath];
    
}

- (void)showMenuForIndexPath:(NSIndexPath *)indexPath
{
    Order *order = self.orders[indexPath.row];
    OrderedProduct *orderedProduct = self.myPosters[indexPath.row];
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCtrl addAction:cancelAction];
    
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIAlertController *deleteCtrl = [UIAlertController alertControllerWithTitle:@"确定要删除吗？" message:@"删除了就不可恢复了，你确定要删除您的设计吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelDeleteAction = [UIAlertAction actionWithTitle:@"保留" style:UIAlertActionStyleCancel handler:nil];
        [deleteCtrl addAction:cancelDeleteAction];
        
        UIAlertAction *confirmDeleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //删除
            [self deleteOrder:order andOrderedProduct:orderedProduct atIndexPath:indexPath];
        }];
        [deleteCtrl addAction:confirmDeleteAction];
        [self presentViewController:deleteCtrl animated:YES completion:nil];
        
    }];
    [alertCtrl addAction:deleteAction];
    
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *imageURL = orderedProduct.designed_image_url;
        NSString *total_mdoel_name = [NSString stringWithFormat:@"款式：%@ %@ %@ 创建时间:%@",orderedProduct.model_name,orderedProduct.group_name,orderedProduct.color_name,orderedProduct.createdAt];
        NSString *imageFileName = [total_mdoel_name stringByAppendingString:@".png"];
        [HooShareTool showshareAlertControllerIn:self.selectedCell WithImageURL:imageURL andFileName:imageFileName];
    }];
    [alertCtrl addAction:shareAction];
    
    
    UIAlertAction *showAction = [UIAlertAction actionWithTitle:@"查看详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        HooOrderInfoController *orderInfoCtrl = [[HooOrderInfoController alloc] init];
        orderInfoCtrl.order_id = order.objectId;
        HooStopAutoRotationNaviController *navi = [[HooStopAutoRotationNaviController alloc] initWithRootViewController:orderInfoCtrl];
        [self presentViewController:navi animated:YES completion:nil];
        
    }];
    [alertCtrl addAction:showAction];
    
    alertCtrl.popoverPresentationController.sourceView = self.view;
    alertCtrl.popoverPresentationController.sourceRect = self.selectedCell.frame;
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)deleteOrder:(Order *)order andOrderedProduct:(OrderedProduct *)orderedProduct atIndexPath:(NSIndexPath *)indexPath
{
    [[HooOrderManager manager] deleteOrderWithOrder_id:order.objectId AndOrderedProuct_id:orderedProduct.objectId WithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self.myPosters removeObjectAtIndex:indexPath.row -self.createList.count];
            [self.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"删除订单成功"];
        }
        if (error) {
            [SVProgressHUD showSuccessWithStatus:@"删除订单失败"];
        }
    }];
}



@end
