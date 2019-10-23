//
//  HooOrderManager.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/9.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "HooOrderManager.h"
#import "Order.h"
#import "OrderAddress.h"
#import "OrderDelivery.h"
#import "OrderedProduct.h"


#define CustomErrorDomain @"com.jackiehoo.MomentsLife"
typedef enum {
    XDefultFailed = -1000,
    XRegisterFailed,
    XConnectFailed,
    XPhotoCountFailed
}CustomErrorFailed;

@implementation HooOrderManager

static HooOrderManager *orderManager;

+ (instancetype)manager
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        orderManager = [[HooOrderManager alloc] init];
        
    });
    return orderManager;
}

- (void)newOrder:(Order *)order withProduct_id:(NSString *)product_id Address_id:(NSString *)address_id
  AndDelivery_id:(NSString *)delivery_id WithBlock:(void(^)(BOOL isSuccessful, NSError *error))block
{
    //用户Pointer
    BmobUser *user = [BmobUser getCurrentUser];
    BmobUser *orderUser = [BmobUser objectWithoutDatatWithClassName:@"_User" objectId:user.objectId];
    
    //订单产品Pointer
    OrderedProduct *orderedProduct = [OrderedProduct objectWithoutDatatWithClassName:NSStringFromClass([OrderedProduct class]) objectId:product_id];
    
    //地址Pointer
    OrderAddress *orderAddress = [OrderAddress objectWithoutDatatWithClassName:NSStringFromClass([OrderAddress class]) objectId:address_id];
    
    //快递Pointer
    OrderDelivery *orderDelivery = [OrderDelivery objectWithoutDatatWithClassName:NSStringFromClass([OrderDelivery class]) objectId:delivery_id];

    
    [order setObject:orderUser forKey:@"user_id"];
    
    [order setObject:orderedProduct forKey:@"product_id"];
    
    [order setObject:orderAddress forKey:@"address_id"];
    
    [order setObject:orderDelivery forKey:@"delivery_id"];
    
    [order sub_saveInBackgroundWithResultBlock:block];
}

- (void)updateOrder:(Order *)order WithBlock:(void(^)(BOOL isSuccessful, NSError *error))block
{
    if (block) {
        [order sub_updateInBackgroundWithResultBlock:block];
    }
}

- (void)orderWithOrder_id:(NSString *)order_id block:(void(^)(Order *order, BmobUser *user,OrderedProduct *orderedProduct,OrderAddress *orderAddress,OrderDelivery *orderDelivery, NSError *error))block
{
    BmobQuery   *orderQuery = [BmobQuery queryWithClassName:NSStringFromClass([Order class])];
    [orderQuery includeKey:@"user_id,address_id,delivery_id,product_id"];
    
    [orderQuery getObjectInBackgroundWithId:order_id block:^(BmobObject *object, NSError *error) {
        if (error){
            block(nil,nil,nil, nil,nil,error);
        }else{
            if (object) {
                
                Order *order = [[Order alloc] initFromBmobOjbect:object];
                BmobUser *user = [object objectForKey:@"user_id"];
                BmobObject *orderAddressObj = [object objectForKey:@"address_id"];
                OrderAddress *orderAddress = [[OrderAddress alloc] initFromBmobOjbect:orderAddressObj];
                
                BmobObject *orderedProductObj = [object objectForKey:@"product_id"];
                OrderedProduct *orderedProduct = [[OrderedProduct alloc] initFromBmobOjbect:orderedProductObj];
                BmobObject *orderDeliveryObj = [object objectForKey:@"delivery_id"];
                OrderDelivery *orderDelivery = [[OrderDelivery alloc] initFromBmobOjbect:orderDeliveryObj];
                block(order, user, orderedProduct, orderAddress, orderDelivery,error);
            }
        }
        
    }];
}

- (void)successOrdersSkip:(NSInteger)count WithBlock:(void(^)(NSArray *orders, NSArray *orderedProducts,NSArray *orderAddresses,NSArray *orderDeliveries, NSError *error))block
{
    BmobQuery *orderQuery = [BmobQuery queryWithClassName:NSStringFromClass([Order class])];
    [orderQuery whereKey:@"is_pay" equalTo:@(YES)];
    [orderQuery orderByDescending:@"updatedAt"];
    orderQuery.limit = 3;
    orderQuery.skip = count;
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryWithClassName:@"_User"];
    BmobUser *user = [BmobUser getCurrentUser];
    [inQuery whereKey:@"objectId" equalTo:user.objectId];
    
    //匹配查询
    [orderQuery whereKey:@"user_id" matchesQuery:inQuery];
    [orderQuery includeKey:@"user_id,address_id,delivery_id,product_id"];
    if (user == nil) {
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"用户未登录"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:CustomErrorDomain  code:XRegisterFailed userInfo:userInfo];
        block(nil,nil, nil,nil,error);
        return;
    }
    
    [orderQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            block(nil,nil, nil,nil,error);
            return;
        }
        NSMutableArray *orders = [NSMutableArray array];
        NSMutableArray *orderedProducts = [NSMutableArray array];
        NSMutableArray *orderAddresses = [NSMutableArray array];
        NSMutableArray *orderDeliveries = [NSMutableArray array];

        
        for (BmobObject *object in array) {
            
            Order *order = [[Order alloc] initFromBmobOjbect:object];
            BmobObject *orderAddressObj = [object objectForKey:@"address_id"];
            OrderAddress *orderAddress = [[OrderAddress alloc] initFromBmobOjbect:orderAddressObj];
            
            BmobObject *orderedProductObj = [object objectForKey:@"product_id"];
            OrderedProduct *orderedProduct = [[OrderedProduct alloc] initFromBmobOjbect:orderedProductObj];
            BmobObject *orderDeliveryObj = [object objectForKey:@"delivery_id"];
            OrderDelivery *orderDelivery = [[OrderDelivery alloc] initFromBmobOjbect:orderDeliveryObj];
            [orders addObject:order];
            [orderedProducts addObject:orderedProduct];
            [orderAddresses addObject:orderAddress];
            [orderDeliveries addObject:orderDelivery];
        }
        block(orders,orderedProducts,orderAddresses,orderDeliveries,error);
    }];

}

- (void)unPayOrdersSkip:(NSInteger)count WithBlock:(void(^)(NSArray *orders, NSArray *orderedProducts,NSArray *orderAddresses,NSArray *orderDeliveries, NSError *error))block
{
    BmobQuery *orderQuery = [BmobQuery queryWithClassName:NSStringFromClass([Order class])];
    [orderQuery orderByDescending:@"updatedAt"];
    [orderQuery whereKey:@"is_pay" equalTo:@(NO)];
    orderQuery.limit = 3;
    orderQuery.skip = count;
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryWithClassName:@"_User"];
    BmobUser *user = [BmobUser getCurrentUser];
    [inQuery whereKey:@"objectId" equalTo:user.objectId];
    
    //匹配查询
    [orderQuery whereKey:@"user_id" matchesQuery:inQuery];
    [orderQuery includeKey:@"user_id,address_id,delivery_id,product_id"];
    if (user == nil) {
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"用户未登录"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:CustomErrorDomain  code:XRegisterFailed userInfo:userInfo];
        block(nil,nil, nil,nil,error);
        return;
    }
    
    [orderQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            block(nil,nil, nil,nil,error);
            return;
        }
        NSMutableArray *orders = [NSMutableArray array];
        NSMutableArray *orderedProducts = [NSMutableArray array];
        NSMutableArray *orderAddresses = [NSMutableArray array];
        NSMutableArray *orderDeliveries = [NSMutableArray array];
        
        
        for (BmobObject *object in array) {
            
            Order *order = [[Order alloc] initFromBmobOjbect:object];
            BmobObject *orderAddressObj = [object objectForKey:@"address_id"];
            OrderAddress *orderAddress = [[OrderAddress alloc] initFromBmobOjbect:orderAddressObj];
            
            BmobObject *orderedProductObj = [object objectForKey:@"product_id"];
            OrderedProduct *orderedProduct = [[OrderedProduct alloc] initFromBmobOjbect:orderedProductObj];
            BmobObject *orderDeliveryObj = [object objectForKey:@"delivery_id"];
            OrderDelivery *orderDelivery = [[OrderDelivery alloc] initFromBmobOjbect:orderDeliveryObj];
            [orders addObject:order];
            [orderedProducts addObject:orderedProduct];
            [orderAddresses addObject:orderAddress];
            [orderDeliveries addObject:orderDelivery];
        }
        block(orders,orderedProducts,orderAddresses,orderDeliveries,error);
    }];
}

- (void)deleteOrderWithOrder_id:(NSString *)order_id AndOrderedProuct_id:(NSString *)orderedProduct_id WithResultBlock:(void(^)(BOOL isSuccessful, NSError *error))block
{
    BmobObject *orderObj = [BmobObject objectWithoutDatatWithClassName:NSStringFromClass([Order class]) objectId:order_id];
    BmobObject *orderedProductObj = [BmobObject objectWithoutDatatWithClassName:NSStringFromClass([OrderedProduct class]) objectId:orderedProduct_id];
    [orderObj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (error) {
            block(NO,error);
        }
        if (isSuccessful) {
            [orderedProductObj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if (error) {
                    block(NO,error);
                }
                if (isSuccessful) {
                    block(YES,error);
                }
            }];
        }
        
    }];
}

@end
