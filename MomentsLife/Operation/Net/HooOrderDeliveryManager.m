//
//  HooDeliveryManager.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/6.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "HooOrderDeliveryManager.h"
#import "OrderDelivery.h"

@implementation HooOrderDeliveryManager

static HooOrderDeliveryManager *deliveryManager;

+ (instancetype)manager
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        deliveryManager = [[HooOrderDeliveryManager alloc] init];
        
    });
    return deliveryManager;
}

- (void)deliveriesWithBlock:(void(^)(NSArray *deliveries , NSError *error))block
{
    NSMutableArray *deliveries = [NSMutableArray array];
    BmobQuery   *bquery = [OrderDelivery query];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (block) {
            if (error) {
                block(nil,error);
                return;
            }
            for (BmobObject *obj in array) {
                OrderDelivery *delivery = [[OrderDelivery alloc] initFromBmobOjbect:obj];

                [deliveries addObject:delivery];
            }
            block(deliveries,error);
            
        }
    }];
}

- (void)defaultDeliveryWithBlock:(void(^)(OrderDelivery *delivery , NSError *error))block
{
    BmobQuery   *bquery = [OrderDelivery query];
    [bquery whereKey:@"is_default" equalTo:@(YES)];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (block) {
            
            if (error) {
                block(nil,error);
                return;
            }
            if (array.count) {
                BmobObject *obj = array.firstObject;
                OrderDelivery *defaultDelivery = [[OrderDelivery alloc] initFromBmobOjbect:obj];
                block(defaultDelivery,nil);
            }
        }

        
    }];
}

- (void)updateDeliveryWithDelivery:(OrderDelivery *)delivery WithBlock:(void(^)(BOOL isSuccessful, NSError *error))block
{
    
    if (block) {
        [delivery sub_updateInBackgroundWithResultBlock:block];
    }
}
@end
