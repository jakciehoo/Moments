//
//  HooOrderController.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HooPayPopView.h"
#import "HooOrderProductFooterView.h"
#import "HooOrderDeliveryFooterView.h"
#import "OrderedProduct.h"
#import "OrderAddress.h"
#import "OrderDelivery.h"
#import "Order.h"

@interface HooOrderBaseController : UIViewController

//订单模型
@property (nonatomic, strong)Order *order;
//订单产品模型
@property (nonatomic, strong)OrderedProduct *orderedProduct;
//订单地址模型
@property (nonatomic, strong)OrderAddress *orderAddress;
//订单快递模型
@property (nonatomic, strong)OrderDelivery *orderDelivery;
//表格
@property (nonatomic,weak)UITableView *tableView;
//订单产品显示视图
@property (nonatomic,strong)HooOrderProductFooterView *orderProductFooterView;
//订单快递显示视图
@property (nonatomic,strong)HooOrderDeliveryFooterView *orderDeliveryFooterView;
//弹出的支付选择框
@property (nonatomic, weak)HooPayPopView *popView;
//订单支付方式字典数组，字典格式内容为[UIImage imageNamed:@"pay_mode_alipay"],@"image",@"支付宝",@"name",@"支付宝支付安全快捷",@"description" ,nil]
@property (nonatomic, strong)NSArray *payArray;

//支付并更新订单数据成功后执行
- (void)payOrderSuccessfulAction;

#pragma mark - BmobPayDelegate
//支付失败调用
-(void)payFailWithErrorCode:(int) errorCode;

@end
