//
//  HooOrderController.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import "HooOrderPayController.h"
#import "HooOrderAddressController.h"
#import "HooAddAddressController.h"
#import "HooStopAutoRotationNaviController.h"
#import "HooOrderDeliveryController.h"
#import "HooLoginController.h"
#import "HooOrderInfoController.h"
#import "HooPayPopView.h"
#import "HooOrderToolView.h"
#import "HooOrderProductFooterView.h"
#import "HooOrderDeliveryFooterView.h"
#import "HooAddressCell.h"
#import "SVProgressHUD.h"

#import "HooUserManager.h"
#import "HooOrderDeliveryManager.h"
#import "HooOrderManager.h"
#import "HooOrderAddressManager.h"



@interface HooOrderPayController ()<HooOrderToolViewDelegate,HooOrderDeliveryControllerDelegate>

@property (nonatomic,weak)HooOrderToolView *orderToolView;


//订单总价
@property (nonatomic,assign)float order_total_price;



@end

@implementation HooOrderPayController

static NSString *AddressCellID = @"AddressCell";
static NSString *OrderFooterID = @"OrderFooter";
static NSString *DeliveryCellID = @"DeliveryCell";

#pragma mark - 懒加载

- (HooOrderToolView *)orderToolView
{
    if (_orderToolView == nil) {
        HooOrderToolView *orderToolView = [HooOrderToolView orderToolView];
        orderToolView.backgroundColor = HooColor(57, 63, 75);
        orderToolView.frame = CGRectMake(0, self.view.height, self.view.width, 44);
        //toolView.alpha = 0.0;
        if (self.orderedProduct) {
            orderToolView.product_price = self.orderedProduct.product_price;
            orderToolView.inventory_count = self.orderedProduct.product_inventory_count;
        }
        orderToolView.delegate = self;
        [self.view addSubview:orderToolView];
        [self.view bringSubviewToFront:orderToolView];
        _orderToolView = orderToolView;

        
    }
    return _orderToolView;
}

- (void)setOrderDelivery:(OrderDelivery *)orderDelivery
{
    super.orderDelivery = orderDelivery;
    [self.tableView reloadData];
    self.orderToolView.delivery_price = orderDelivery.delivery_price;
}

#pragma mark - 初始化视图
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    //加载默认快递和收货收货地址
    [self loadDefaultDelievery];
}
- (void)setupView
{
    self.title = @"产品定制";
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.tableView registerNib:[UINib nibWithNibName:@"HooAddressCell" bundle:nil] forCellReuseIdentifier:AddressCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"HooOrderProductFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:OrderFooterID];
    
    UIImage *image = [UIImage imageNamed:@"navbar_white"];
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    [self.navigationController.navigationBar setBackgroundImage:newImage forBarMetrics:UIBarMetricsDefault];
    
    
    self.orderToolView.alpha = 1.0;
    [UIView animateWithDuration:HooDuration/2 animations:^{
        
        self.orderToolView.transform = CGAffineTransformMakeTranslation(0, -44);
    }];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDefaultAddress];
}
//加载默认快递
- (void)loadDefaultDelievery
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[HooOrderDeliveryManager manager] defaultDeliveryWithBlock:^(OrderDelivery *delivery, NSError *error) {
        if (error) {
            HooLog(@"%@",error);
            [SVProgressHUD showInfoWithStatus:@"网络不给力，请重新请求"];
            return;
        }
        if (delivery) {

            self.orderDelivery = delivery;
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    }];
    
}
//加载默认地址
- (void)loadDefaultAddress
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[HooOrderAddressManager manager] defaultAddressWithBlock:^(OrderAddress *orderAddress, NSError *error) {
        if (error) {
            HooLog(@"%@",error);
            [SVProgressHUD showInfoWithStatus:@"网络不给力，请重新请求"];
            return;
        }
        if (orderAddress) {
            self.orderAddress = orderAddress;
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return  UIStatusBarStyleDefault;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 250;
    }
    if (section == 1) {
        return 60;
    }
    return 10;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"默认收货地址";
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.orderedProduct) {
            self.orderProductFooterView.orderedProduct = self.orderedProduct;
            self.orderProductFooterView.orderedProduct_thumbImage = self.orderedProduct_thumbImage;
        }
        return self.orderProductFooterView;
    }
    if (section == 1) {
        if (self.orderDelivery) {
            
            self.orderDeliveryFooterView.delivery_price = self.orderDelivery.delivery_price;
        }
        return self.orderDeliveryFooterView;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        HooAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:AddressCellID forIndexPath:indexPath];
        if (addressCell == nil) {
            addressCell = (HooAddressCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddressCellID];
        }
        if (self.orderAddress.name.length) {
            addressCell.address = self.orderAddress;
        }
        cell = addressCell;
        
    }
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:DeliveryCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DeliveryCellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = @"配送方式";
        if (self.orderDelivery.delivery_name.length) {
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.text = self.orderDelivery.delivery_name;
        }
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HooOrderAddressController *orderAddressCtrl = [[HooOrderAddressController alloc] init];
        [self.navigationController pushViewController:orderAddressCtrl animated:YES];
    }
    if (indexPath.section == 1) {
        HooOrderDeliveryController *orderDeliverCtrl = [[HooOrderDeliveryController alloc] init];
        orderDeliverCtrl.delegate = self;
        [self.navigationController pushViewController:orderDeliverCtrl animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - HooOrderDeliveryControllerDelegate
-(void)didSelectDelivery:(OrderDelivery *)delivery
{
    self.orderDelivery = delivery;
}



#pragma mark - HooOrderToolViewDelegate

- (void)payButtonClicked:(UIButton *)payButton WithTotalPrice:(NSString *)total_price WithOrderCount:(NSInteger)order_count
{
    //订单总价
    self.order_total_price = [[total_price substringFromIndex:1] floatValue];
    
    self.order.total_price = total_price;
    self.order.order_count = order_count;
    self.order.order_status = @"订单生尚未成";
    

    //如果用户没有登录，就返回
    if (![[HooUserManager manager] getCurrentUser]) {
        [SVProgressHUD showInfoWithStatus:@"您需要先返回登录才可购买"];
        return;
    }
    
    //如果没有设置默认地址，就跳转到添加地址页面
    if (self.orderAddress.name.length == 0) {
        HooAddAddressController *addAddressCtrl = [[HooAddAddressController alloc] init];
        addAddressCtrl.fromOrder = YES;
        [self.navigationController pushViewController:addAddressCtrl animated:YES];
        return;
    }
    
    
    //如果默认地址，默认快递，默认产品有一项没有，就无法下订单
    if (self.orderAddress.name.length == 0 || self.orderDelivery.delivery_name.length == 0 || self.orderedProduct == nil) {
        [SVProgressHUD showInfoWithStatus:@"你的订单信息不完整，请完善"];
        return;
    }
    //如果已经有了未支付订单,则继续支付
    if (self.order.objectId.length != 0){
        self.popView.payArray = self.payArray;
        return;
    }

    //否则需要先生成未支付订单，再继续支付
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    
    
    self.order.is_pay = @(NO);
    self.order.is_delivery = @(NO);
    self.order.order_status = @"订单生成，但尚未完成支付";
    [[HooOrderManager manager] newOrder:self.order withProduct_id:self.orderedProduct.objectId Address_id:self.orderAddress.objectId AndDelivery_id:self.orderDelivery.objectId WithBlock:^(BOOL isSuccessful, NSError *error) {
                [SVProgressHUD dismiss];

                if (isSuccessful) {
                    self.popView.payArray = self.payArray;
        
                } else if (error){
                    HooLog(@"%@",[error description]);
        
                    [SVProgressHUD showErrorWithStatus:@"网络不给力,生成订单失败"];
                }
    }];
    
}

- (void)payOrderSuccessfulAction
{
    HooOrderInfoController *orderInfoCtrl = [[HooOrderInfoController alloc] init];
    orderInfoCtrl.order_id = self.order.objectId;
    [self.navigationController pushViewController:orderInfoCtrl animated:YES];
}

- (void)payFailWithErrorCode:(int)errorCode
{
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
    [SVProgressHUD dismissWithDelay:2.0];
    
    HooOrderInfoController *orderInfoCtrl = [[HooOrderInfoController alloc] init];
    orderInfoCtrl.order_id = self.order.objectId;
    [self.navigationController pushViewController:orderInfoCtrl animated:YES];
}



@end
