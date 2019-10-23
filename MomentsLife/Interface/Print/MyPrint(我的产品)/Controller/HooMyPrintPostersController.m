//
//  HooMyPrintsController.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/19.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import "HooMyPrintPostersController.h"
#import "HooLoginController.h"
#import "HooUserManager.h"
#import "HooStopAutoRotationNaviController.h"
#import "HooUserInfoController.h"
#import "HooProdcutListController.h"
#import "HooOrderInfoController.h"
#import "HooUnPayedOrderController.h"
#import "HooCreateCell.h"
#import "HooPosterCell.h"
#import "HooProductDataTool.h"
#import "HooProduct.h"
#import "HooProductCategory.h"
#import "SVProgressHUD.h"
#import "HooUserManager.h"
#import "HooOrderManager.h"
#import "Order.h"
#import "OrderedProduct.h"
#import "HooShareTool.h"

@interface HooMyPrintPostersController ()


//产品类目
@property (nonatomic, strong)NSMutableArray *categories;

@property (nonatomic, strong)NSMutableArray *orders;

@property (nonatomic, strong)NSMutableArray *orderedProducts;

@property (nonatomic, strong)NSMutableArray *orderAddresses;

@property (nonatomic, strong)NSMutableArray *orderDeliveries;


@end


@implementation HooMyPrintPostersController

static NSString *CreateCellID = @"CreateCell";
static NSString *PosterCellID = @"PosterCell";

#pragma mark - 懒加载
//产品类目
- (NSMutableArray *)categories
{
    if (_categories == nil) {
        _categories = [NSMutableArray array];
    }
    return _categories;
}
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [HooProductDataTool createProductArraySuccess:^(BOOL flag, NSMutableArray *productArray) {
            //保存到Plist文件中
            if (!flag) {
                return;
            }
            NSString *plistPath = [HooDocumentDirectory stringByAppendingPathComponent:@"product.plist"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if (![fileManager fileExistsAtPath:plistPath]) {
                if (![fileManager createFileAtPath:plistPath contents:nil attributes:nil]) {
                    HooLog(@"创建plist文件失败");
                    
                    return;
                }
            }
           BOOL sucess = [productArray writeToFile:plistPath atomically:YES];
            if (!sucess) {
                HooLog(@"更新数据失败");
            }else{
             //HooLog(@"获取产品数据成功");
            }
        }];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"丁丁印";
    [self setupNavi];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

#pragma mark - 初始化导航栏
- (void)setupNavi
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_usercenter2"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserInfo)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_cart2"] style:UIBarButtonItemStylePlain target:self action:@selector(showUnPayOrder)];
    if (![[HooUserManager manager] getCurrentUser]) {
        [SVProgressHUD showInfoWithStatus:@"点击左上角登录，打印DIY产品"];
    }
}

- (void)showUserInfo
{
    
    if ([[HooUserManager manager] getCurrentUser]) {
        
        HooUserInfoController *userInfoCtrl = [[HooUserInfoController alloc] init];
        HooStopAutoRotationNaviController *navi = [[HooStopAutoRotationNaviController alloc] initWithRootViewController:userInfoCtrl];
        [self presentViewController:navi animated:YES completion:nil];
    }else{
        HooLoginController *loginCtrl = [[HooLoginController alloc] init];
        HooStopAutoRotationNaviController *navi = [[HooStopAutoRotationNaviController alloc] initWithRootViewController:loginCtrl];
        loginCtrl.fromMyPrint = YES;
        [self presentViewController:navi animated:YES completion:nil];
        
    }

}
- (void)showUnPayOrder
{
    HooUnPayedOrderController *unPayCtrl = [[HooUnPayedOrderController alloc] init];
//    HooStopAutoRotationNaviController *navi = [[HooStopAutoRotationNaviController alloc] initWithRootViewController:unPayCtrl];
    [self.navigationController pushViewController:unPayCtrl animated:YES];
}

- (void)loadMyPosters
{
    [self loadCreateList];
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
    [[HooOrderManager manager] successOrdersSkip:self.orders.count WithBlock:^(NSArray *orders, NSArray *orderedProducts, NSArray *orderAddresses, NSArray *orderDeliveries, NSError *error) {
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

- (void)loadCreateList
{
    [self.createList removeAllObjects];
    
    NSString *plistPath = [HooDocumentDirectory stringByAppendingPathComponent:@"product.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showInfoWithStatus:@"正在加载产品数据，请稍等，然后下拉刷新"];
        return;
    }
    [self.categories removeAllObjects];
    self.categories = [HooProductCategory objectArrayWithFile:plistPath];
    
    for (HooProductCategory *category in self.categories) {
        [self.createList addObject:category.category_name];
    }

    [self.tableView reloadData];
    
}
#pragma mark - UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.createList.count) {
        
        HooCreateCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:CreateCellID];
        NSString *createStr = [NSString stringWithFormat:@"%@ >>",self.createList[indexPath.row]];
        cell.createLabel.text = createStr;
        return cell;
    }else{
        HooPosterCell *cell = [tableView dequeueReusableCellWithIdentifier:PosterCellID forIndexPath:indexPath];
        cell.orderedProduct = self.myPosters[indexPath.row - self.createList.count];
        
        return cell;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row < self.createList.count) {
        HooProductCategory *category = self.categories[indexPath.row];
        NSArray *products = category.products;

        HooProdcutListController *productListCtrl = [[HooProdcutListController alloc] init];
        [productListCtrl setValue:products forKey:@"_products"];

        [self.navigationController pushViewController:productListCtrl animated:YES];
    }else{
        
        [self showMenuForIndexPath:indexPath];
    }

}

- (void)showMenuForIndexPath:(NSIndexPath *)indexPath
{
    Order *order = self.orders[indexPath.row - self.createList.count];
    OrderedProduct *orderedProduct = self.myPosters[indexPath.row - self.createList.count];
    
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
        [HooShareTool showshareAlertControllerIn:self.selectedCell  WithImageURL:imageURL andFileName:imageFileName];
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
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];

            [SVProgressHUD showSuccessWithStatus:@"删除订单成功"];
        }
        if (error) {
            [SVProgressHUD showSuccessWithStatus:@"删除订单失败"];
        }
    }];
}


@end
