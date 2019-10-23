//
//  HooProductOrder.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/6.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/BmobObject.h>

@interface Order : BmobObject

/**
 *  订单数量
 */
@property (nonatomic, assign)NSInteger order_count;

/**
 *  总计价格
 */
@property (nonatomic, copy)NSString *total_price;
/**
 *  总计价格
 */
@property (nonatomic, copy)NSString *order_description;
/**
 *  订单状态
 */
@property (nonatomic, copy)NSString *order_status;
/**
 *  是否完成支付
 */
@property (nonatomic, assign)NSNumber *is_pay;
/**
 *  支付日期
 */
@property (nonatomic, strong)NSDate *pay_date;
/**
 *  是否发货
 */
@property (nonatomic, assign)NSNumber *is_delivery;
/**
 *  发货日期
 */
@property (nonatomic, strong)NSDate *delivery_date;
/**
 *  快递单号
 */
@property (nonatomic, copy)NSString *delivery_number;
/**
 *  操作员姓名
 */
@property (nonatomic, copy)NSString *operator_name;







@end
