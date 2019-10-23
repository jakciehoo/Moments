//
//  HooDeliveryManager.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/6.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderDelivery;

@interface HooOrderDeliveryManager : NSObject
/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (instancetype)manager;
/**
 *  获取所有快递信息
 *
 *  @param block 回调
 */
- (void)deliveriesWithBlock:(void(^)(NSArray *deliveries , NSError *error))block;
/**
 *  获取默认快递
 *
 *  @param block 回调
 */
- (void)defaultDeliveryWithBlock:(void(^)(OrderDelivery *delivery , NSError *error))block;

- (void)updateDeliveryWithDelivery:(OrderDelivery *)delivery WithBlock:(void(^)(BOOL isSuccessful, NSError *error))block;

@end
