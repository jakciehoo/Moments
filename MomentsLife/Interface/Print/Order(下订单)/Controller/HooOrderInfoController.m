//
//  HooOrderInfoController.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/9.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobPay/BmobPay.h>
#import "HooOrderInfoController.h"
#import "HooMainTabBarController.h"
#import "HooOrderProductFooterView.h"
#import "HooOrderDeliveryFooterView.h"
#import "HooOrderInfoToolView.h"
#import "HooPayPopView.h"
#import "HooAddressCell.h"
#import "HooOrderCell.h"
#import "SVProgressHUD.h"
#import "HooOrderManager.h"
#import "Order.h"
#import "OrderDelivery.h"
#import "OrderAddress.h"
#import "OrderedProduct.h"
#import "UIView+AutoLayout.h"

@interface HooOrderInfoController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak)HooOrderInfoToolView *orderInfoToolView;


@end

@implementation HooOrderInfoController
static NSString *OrderCellID = @"OrderCell";
static NSString *AddressCellID = @"AddressCell";
static NSString *OrderFooterID = @"OrderFooter";
static NSString *DeliveryCellID = @"DeliveryCell";

- (void)setOrder:(Order *)order
{
    super.order = order;
    //继续支付按钮
    if (self.orderInfoToolView) {
        [self.orderInfoToolView removeFromSuperview];
        self.orderInfoToolView = nil;
    }
    if (![order.is_pay boolValue]){
        UIButton *successButton = [UIButton buttonWithType:UIButtonTypeCustom];
        successButton.backgroundColor = HooColor(234, 81, 96);
        [successButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        successButton.titleLabel.font = [UIFont systemFontOfSize:14];
        successButton.layer.cornerRadius = 2.0;
        successButton.showsTouchWhenHighlighted = YES;
        [self.orderInfoToolView addSubview:successButton];
        [successButton autoSetDimensionsToSize:CGSizeMake(200, 30)];
        [successButton autoCenterInSuperview];
        [successButton setTitle:@"点击继续支付" forState:UIControlStateNormal];
        [successButton addTarget:self action:@selector(continueToPay) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (HooOrderInfoToolView *)orderInfoToolView
{
    if (_orderInfoToolView == nil) {
        HooOrderInfoToolView *orderInfoToolView = [HooOrderInfoToolView orderInfoToolView];
        orderInfoToolView.backgroundColor = HooColor(57, 63, 75);
        orderInfoToolView.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
        _orderInfoToolView = orderInfoToolView;
        [self.view addSubview:orderInfoToolView];
        [self.view bringSubviewToFront:orderInfoToolView];
        
    }
    return _orderInfoToolView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   // [self setupView];
    [self loadOrder];
}

- (void)setupView
{
    self.title = @"订单详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ay_table_close"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.tableView registerNib:[UINib nibWithNibName:@"HooOrderCell" bundle:nil] forCellReuseIdentifier:OrderCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"HooAddressCell" bundle:nil] forCellReuseIdentifier:AddressCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"HooOrderProductFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:OrderFooterID];
    
    

 
}

- (void)back
{
//    HooMainTabBarController *mainTabBarCtrl = (HooMainTabBarController *)HooKeyWindow.rootViewController;
//    mainTabBarCtrl.selectedIndex = 3;
//    mainTabBarCtrl.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.presentingViewController.navigationController popToRootViewControllerAnimated:YES];
    }];
    
}


- (void)continueToPay
{
    self.popView.payArray = self.payArray;
}
- (void)loadOrder
{
    if (self.order_id) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD show];
        [[HooOrderManager manager] orderWithOrder_id:self.order_id block:^(Order *order,BmobUser *user, OrderedProduct *orderedProduct, OrderAddress *orderAddress, OrderDelivery *orderDelivery, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"网络不给力啊，请检查！"];
                return;
            }
            if (order) {
                self.order = order;
                self.orderAddress = orderAddress;
                self.orderDelivery = orderDelivery;
                self.orderedProduct = orderedProduct;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return  UIStatusBarStyleDefault;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 140;
    }
    
    if (indexPath.section == 1) {
        return 80;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 250;
    }
    if (section == 2) {
        return 37;
    }
    return 10;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"订单信息";
    }
    if (section == 1) {
        return @"订单的收货地址";
    }
    if (section == 2) {
        return @"快递信息";
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.orderedProduct.product_name.length) {
            self.orderProductFooterView.orderedProduct = self.orderedProduct;
        }
        return self.orderProductFooterView;
    }
    if (section == 2) {
        if (self.orderDelivery.delivery_price) {
            
            self.orderDeliveryFooterView.delivery_price = self.orderDelivery.delivery_price;
        }
        if (self.order.delivery_number) {
            self.orderDeliveryFooterView.delivery_number = self.order.delivery_number;
        }
        return self.orderDeliveryFooterView;
    }

    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        HooOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:OrderCellID forIndexPath:indexPath];
        if (orderCell == nil) {
            orderCell = (HooOrderCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderCellID];
        }
        if (self.order) {
            orderCell.order = self.order;
        }

        cell = orderCell;
    }
    
    
    if (indexPath.section == 1) {
        HooAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:AddressCellID forIndexPath:indexPath];
        if (addressCell == nil) {
            addressCell = (HooAddressCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddressCellID];
        }
        if (self.orderAddress.name.length) {
            addressCell.address = self.orderAddress;
        }
        cell = addressCell;
        
    }
    if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:DeliveryCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DeliveryCellID];
        }
        if (self.orderDelivery.delivery_name) {
            cell.textLabel.text = [NSString stringWithFormat:@"配送方式: %@",self.orderDelivery.delivery_name];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)payOrderSuccessfulAction
{
    [self loadOrder];
}



@end
