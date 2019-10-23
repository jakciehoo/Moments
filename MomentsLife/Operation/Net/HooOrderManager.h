//
//  HooOrderManager.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/9.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <BmobSDK/BmobObject.h>

@class Order;
@class OrderAddress;
@class OrderedProduct;
@class OrderDelivery;

@interface HooOrderManager : BmobObject

+ (instancetype)manager;
/**
 *  新增订单
 *
 *  @param order       订单
 *  @param product_id  订单产品编号
 *  @param address_id  订单地址编号
 *  @param delivery_id 订单快递编号
 *  @param block       回调
 */
- (void)newOrder:(Order *)order withProduct_id:(NSString *)product_id Address_id:(NSString *)address_id
  AndDelivery_id:(NSString *)delivery_id WithBlock:(void(^)(BOOL isSuccessful, NSError *error))block;


- (void)updateOrder:(Order *)order WithBlock:(void(^)(BOOL isSuccessful, NSError *error))block;
/**
 *  根据order编号查询订单
 *
 *  @param order_id 订单编号
 *  @param block    回调
 */
- (void)orderWithOrder_id:(NSString *)order_id block:(void(^)(Order *order,BmobUser* user,OrderedProduct *orderedProduct,OrderAddress *orderAddress,OrderDelivery *orderDelivery, NSError *error))block;
/**
 *  支付成功的订单
 *
 *  @param count 查询跳过的个数
 *  @param block 回调
 */
- (void)successOrdersSkip:(NSInteger)count WithBlock:(void(^)(NSArray *orders, NSArray *orderedProducts,NSArray *orderAddresses,NSArray *orderDeliveries, NSError *error))block;
/**
 *  支付失败的订单
 *
 *  @param count 查询跳过的个数
 *  @param block 回调
 */
- (void)unPayOrdersSkip:(NSInteger)count WithBlock:(void(^)(NSArray *orders, NSArray *orderedProducts,NSArray *orderAddresses,NSArray *orderDeliveries, NSError *error))block;

- (void)deleteOrderWithOrder_id:(NSString *)order_id AndOrderedProuct_id:(NSString *)orderedProduct_id WithResultBlock:(void(^)(BOOL isSuccessful, NSError *error))block;

@end
