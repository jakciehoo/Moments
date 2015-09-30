//
//  HooHttpTool.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/11.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HooHttpTool : NSObject
/**
 *  Get方法
 *
 *  @param URLString  请求的URL
 *  @param parameters 请求参数
 *  @param success    请求成功回调的Block
 *  @param failure    请求失败回调的Block
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

@end
