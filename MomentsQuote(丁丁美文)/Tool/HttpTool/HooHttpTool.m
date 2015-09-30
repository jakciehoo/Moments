//
//  HooHttpTool.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/11.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooHttpTool.h"
#import "AFNetworking.h"

@implementation HooHttpTool

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
