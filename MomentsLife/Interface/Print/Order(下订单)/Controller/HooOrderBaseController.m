//
//  HooOrderController.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import <BmobPay/BmobPay.h>
#import "HooOrderBaseController.h"
#import "SVProgressHUD.h"

#import "HooOrderManager.h"



@interface HooOrderBaseController ()<UITableViewDataSource,UITableViewDelegate,BmobPayDelegate,HooPayPopViewPayDelegate>

@end

@implementation HooOrderBaseController



#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
        [self.view addSubview:tableView];
    }
    return _tableView;
}


- (HooOrderProductFooterView *)orderProductFooterView
{
    if (_orderProductFooterView == nil) {
        HooOrderProductFooterView *orderProductFooter = [HooOrderProductFooterView orderProductFooterView];
        orderProductFooter.frame = CGRectMake(0, 0, self.view.width, 224);
        if (self.orderedProduct) {
            orderProductFooter.orderedProduct = self.orderedProduct;
        }
        _orderProductFooterView = orderProductFooter;
    }
    return _orderProductFooterView;
}

- (HooOrderDeliveryFooterView *)orderDeliveryFooterView
{
    if (_orderDeliveryFooterView == nil) {
        HooOrderDeliveryFooterView *orderDeliveryFooter = [HooOrderDeliveryFooterView orderDeliveryFooterView];
        orderDeliveryFooter.frame = CGRectMake(0, 0, self.view.width, 60);
        
        _orderDeliveryFooterView = orderDeliveryFooter;
    }
    return _orderDeliveryFooterView;
}

- (HooPayPopView *)popView
{
    if (_popView == nil) {
        HooPayPopView *popView = [HooPayPopView payPopView];
        popView.frame = [UIScreen mainScreen].bounds;
        popView.delegate = self;
        [HooKeyWindow addSubview:popView];
        [HooKeyWindow bringSubviewToFront:popView];
        _popView = popView;
    }
    return _popView;
}


- (void)setOrderAddress:(OrderAddress *)orderAddress
{
    _orderAddress = orderAddress;
    [self.tableView reloadData];
}

- (void)setOrderDelivery:(OrderDelivery *)orderDelivery
{
    _orderDelivery = orderDelivery;
    [self.tableView reloadData];

}

- (Order *)order
{
    if (_order == nil) {
        _order = [[Order alloc] init];
    }
    return _order;
}
- (NSArray *)payArray
{
    if (_payArray == nil) {
        NSDictionary *aliPayDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"pay_mode_alipay"],@"image",@"支付宝",@"name",@"支付宝支付安全快捷",@"description" ,nil];
        NSDictionary *weixinPayDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"pay_mode_wechat"],@"image",@"微信支付",@"name",@"微信支付安全快捷",@"description" ,nil];
        
        _payArray = @[aliPayDict,weixinPayDict];
    }
    return _payArray;
}

#pragma mark - 初始化视图
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}
- (void)setupView
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    UIImage *image = [UIImage imageNamed:@"navbar_white"];
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    [self.navigationController.navigationBar setBackgroundImage:newImage forBarMetrics:UIBarMetricsDefault];
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}




#pragma mark - HooPayPopViewPayDelegate

- (void)payWithPayType:(HooPayType)payType
{
    switch (payType) {
        case PayTypeAliPay:
            [self payWithAliPay];
            break;
        case PayTypeWeChat:
            [self payWithWeChat];
            break;
        default:
            break;
    }
}
//支付宝支付
- (void)payWithAliPay
{
    if (!self.order.objectId.length || !self.orderedProduct.model_name.length || !self.orderAddress.objectId.length || !self.orderDelivery.delivery_name.length ) {
        [SVProgressHUD showInfoWithStatus:@"订单信息不完整，不能进行支付"];
        return;
    }
    
    NSString *body = [NSString stringWithFormat:@"%@ %@ %@",self.orderedProduct.model_name,self.orderedProduct.group_name,self.orderedProduct.color_name];
    
    BmobPay* bPay = [[BmobPay alloc] init];
    //设置代理
    bPay.delegate = self;
    //设置商品价格、商品名、商品描述
    CGFloat total_price = [[self.order.total_price substringFromIndex:1] floatValue];
    [bPay setPrice:[NSNumber numberWithFloat:total_price]];
    [bPay setProductName:self.orderedProduct.product_name];
    [bPay setBody:body];
    //appScheme为创建项目第4步中在URL Schemes中添加的标识
    [bPay setAppScheme:@"MomentsLife"];
    //调用支付宝支付
    [bPay payInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            HooLog(@"支付跳转成功");
            [self.popView removeFromSuperview];
            [SVProgressHUD showInfoWithStatus:@"现在跳转到支付界面"];
        } else{
            
            HooLog(@"%@",[error description]);
        }
    }];
}
- (void)payWithWeChat
{
    [SVProgressHUD showInfoWithStatus:@"抱歉，目前不支持微信支付"];
}


#pragma mark - BmobPayDelegate
-(void)paySuccess
{
    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
    self.order.is_pay = @(YES);
    self.order.pay_date = [NSDate date];
    self.order.order_status = @"订单支付成功，请等待发货";
    [SVProgressHUD showWithStatus:@"开始更新订单信息..."];
    [[HooOrderManager manager] updateOrder:self.order WithBlock:^(BOOL isSuccessful, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        if (error) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"支付成功，但更新订单失败，请与工作人员联系" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
        if (isSuccessful) {
            [self payOrderSuccessfulAction];
        }
    }];
    
    
}
//支付并更新订单数据成功后执行
- (void)payOrderSuccessfulAction
{
    
}

-(void)payFailWithErrorCode:(int) errorCode
{
    switch(errorCode){
            
        case 6001:{
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"用户中途取消" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
            break;
            
        case 6002:{
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"网络连接出错" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
            break;
            
        case 4000:{
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"订单支付失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alter show];
        }
            break;
    }
}




@end
