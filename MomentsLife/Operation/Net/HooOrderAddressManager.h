//
//  HooAddressManager.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/6.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
// 管理收货地址数据

#import <Foundation/Foundation.h>

@class OrderAddress;

@interface HooOrderAddressManager : NSObject
/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (instancetype)manager;
/**
 *  新增收货地址
 *
 *  @param address 地址对象
 *  @param block   回调
 */
- (void)newAddressWith:(OrderAddress *)address WithBlock:(void(^)(BOOL isSuccessful, NSError *error))block;
/**
 *
*  修改收货地址
*
*  @param address 地址对象
*  @param block   回调
*/
- (void)updateAddressWith:(OrderAddress *)address WithBlock:(void(^)(BOOL isSuccessful, NSError *error))block;

/**
 *  获取当前用户的所有地址
 *
 *  @param block 回调
 */
- (void)addressesQueryWithBlock:(void(^)(NSArray *addresses, NSError *error))block;
/**
 *  获取默认地址
 *
 *  @param block 回调
 */
- (void)defaultAddressWithBlock:(void(^)(OrderAddress *orderAddress, NSError *error))block;
/**
 *  删除地址
 *
 *  @param address_id 地址编号
 *  @param block   回调
 */
- (void)deleteAddressWith:(NSString *)address_id WithBlock:(void(^)(BOOL isSuccessful, NSError *error))block;

@end
