//
//  HooShareTool.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/13.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HooShareTool : NSObject
/**
 *  显示分享菜单
 *
 *  @param view     显示容器：菜单显示在此视图
 *  @param image    分享的图片
 *  @param fileName 图片名
 */
+ (void)showshareAlertControllerIn:(UIView *)view WithImage:(UIImage *)image andFileName:(NSString *)fileName;
@end
