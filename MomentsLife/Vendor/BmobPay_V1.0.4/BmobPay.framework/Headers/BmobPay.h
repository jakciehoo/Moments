//
//  BmobPay.h
//  BmobSDK
//
//  Created by limao on 15/3/27.
//  Copyright (c) 2015年 donson. All rights reserved.
//


/**
 支付类代理，用于返回不同的支付状态事件。
 
 错误码含义
 
 |错误码 |含义        |
 |------|:---------:|
 | 4000 | 订单支付失败|
 | 6001 | 用户中途取消|
 | 6002 | 网络连接错误|
 
 */
#import <Foundation/Foundation.h>
#import "BmobPaySDK.h"
#import "BmobPayConfig.h"

@protocol BmobPayDelegate <NSObject>
@optional

/**
 * @brief 支付成功时返回事件
 *
 */
-(void)paySuccess;

/**
 *
 * @brief 支付失败时返回事件
 *
 * @param errorCode 错误码
 */
-(void)payFailWithErrorCode:(int) errorCode;

/**
 * @brief 支付发生未知错误时返回事件
 */
-(void)payUnknow;

@end


/**
 该类为Bmob支付类，目前仅支持支付宝支付。
 */
@interface BmobPay : NSObject

///商品价格
@property(nonatomic,retain) NSNumber* price;
///商品名，允许为空，只支持输入中文、英语、数字、下划线(_)及英文破折号(-)
@property(nonatomic,copy) NSString* productName;
///商品描述，允许为空，只支持输入中文、英语、数字、下划线(_)及英文破折号(-)
@property(nonatomic,copy) NSString* body;
///生成的订单号
@property(nonatomic,copy) NSString* tradeNo;
///传入的app scheme
@property(nonatomic,copy) NSString* appScheme;
///订单状态
@property(nonatomic,copy) NSString* tradeStatus;
///支付代理
@property(weak)id<BmobPayDelegate> delegate;

/**
 */
typedef void (^BmobPayResultBlock) (BOOL isSuccessful, NSError *error);

/**
 * @brief 初始化方法
 */
-(id)init;

/**
 * @brief 调用支付，不返回结果
 */
-(void)payInBackground;

/**
 * @brief 调用支付，返回结果
 */
-(void)payInBackgroundWithBlock:(BmobPayResultBlock)block;

/**
 *@brief  当上一次支付操作尚未完成时,如果BmobPay对象发起再次请求,会返回10077错误码,以免生成多个订单。如果使用过程中出现了阻塞(比如异常强制关闭支付插件页面,会导致一直不能再发起请求，这是小概率事件)，则调用此方法进行BmobPay的重置，仅对下一次请求生效,而不是永久消除限制
 */
-(void)forceFree;

/**
 * @brief 查询订单状态，不返回结果
 */
-(void)queryInBackground;

/**
 * @brief 查询订单状态，返回结果
 */
-(void)queryInBackgroundWithBlock:(BmobPayResultBlock)block;
@end
