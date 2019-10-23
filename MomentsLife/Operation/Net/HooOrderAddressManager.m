//
//  HooAddressManager.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/6.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "HooOrderAddressManager.h"
#import "OrderAddress.h"
#import "MJExtension.h"


@implementation HooOrderAddressManager

static HooOrderAddressManager *addressManager;

+ (instancetype)manager
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        addressManager = [[HooOrderAddressManager alloc] init];
        
    });
    return addressManager;
}

- (void)newAddressWith:(OrderAddress *)address WithBlock:(void(^)(BOOL isSuccessful, NSError *error))block
{

    
    BmobUser *user = [BmobUser getCurrentUser];
    BmobUser *addressUser = [BmobUser objectWithoutDatatWithClassName:@"_User" objectId:user.objectId];
    [address setObject:addressUser forKey:@"user_id"];

    if (block) {
        
        [address sub_saveInBackgroundWithResultBlock:block];
    }
}

- (void)updateAddressWith:(OrderAddress *)address WithBlock:(void(^)(BOOL isSuccessful, NSError *error))block
{

    if (block) {
        
        [address sub_updateInBackgroundWithResultBlock:block];
    }
}

- (void)addressesQueryWithBlock:(void(^)(NSArray *addresses, NSError *error))block
{
    NSMutableArray *addresses = [NSMutableArray array];
    BmobQuery   *addressQuery = [OrderAddress query];
    
    //构造约束条件
    BmobUser *user = [BmobUser getCurrentUser];
    BmobQuery *inQuery = [BmobQuery queryWithClassName:@"_User"];
    [inQuery whereKey:@"objectId" equalTo:user.objectId];
    
    //匹配查询
    [addressQuery whereKey:@"user_id" matchesQuery:inQuery];
    
    [addressQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (block) {
            if (error) {
                block(nil,error);
                return;
            }
            for (BmobObject *obj in array) {
                OrderAddress *address = [[OrderAddress alloc] initFromBmobOjbect:obj];

                [addresses addObject:address];
            }
            block(addresses,error);
            
        }
        
    }];
}

- (void)defaultAddressWithBlock:(void(^)(OrderAddress *orderAddress, NSError *error))block
{
    
    BmobQuery   *addressQuery = [OrderAddress query];
    [addressQuery whereKey:@"is_default" equalTo:@(YES)];
    
    //构造约束条件
    BmobUser *user = [BmobUser getCurrentUser];
    BmobQuery *inQuery = [BmobQuery queryWithClassName:@"_User"];
    [inQuery whereKey:@"objectId" equalTo:user.objectId];
    
    //匹配查询
    [addressQuery whereKey:@"user_id" matchesQuery:inQuery];
    
    [addressQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (block) {
            if (error) {
                block(nil,error);
                return;
            }
            if (array.count) {
                
                BmobObject *obj = array.firstObject;
                OrderAddress *address = [[OrderAddress alloc] initFromBmobOjbect:obj];
                block(address,error);
            }
            
            
        }
        
    }];
}

- (void)deleteAddressWith:(NSString *)address_id WithBlock:(void(^)(BOOL isSuccessful, NSError *error))block
{
    OrderAddress *addressObj = [OrderAddress objectWithoutDatatWithClassName:NSStringFromClass([OrderAddress class])  objectId:address_id];
    if (block) {
        
        [addressObj deleteInBackgroundWithBlock:block];
    }
}



@end
