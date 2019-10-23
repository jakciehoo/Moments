//
//  HooVersionTool.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/16.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "HooVersionTool.h"

@implementation HooVersionTool

+ (void)getAppVersionWithBlock:(void(^)(NSString *versionStr, NSError *error))block
{
    BmobQuery *appQuery = [BmobQuery queryWithClassName:@"App"];
    if (block) {
        
        [appQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                block(nil,error);
            }
            if (array.count) {
                BmobObject *appObj = array.firstObject;
                NSString *versionStr = [appObj objectForKey:@"version"];
                block(versionStr,error);
            }
        }];
    }
}

@end
