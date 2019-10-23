//
//  NSString+Etension.h
//  MomentsLife
//
//  Created by HooJackie on 15/9/18.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
/**
 *  是否为空字符串
 *
 *  @return 为空返回YES，非空返回NO
 */
- (BOOL)isEmpty;
/**
 *  验证邮箱格式是否正确
 *
 *  @param email 输入NSString邮箱地址
 *
 *  @return 格式符合返回YES，格式错误返回NO
 */
+ (BOOL) validateEmail:(NSString *)email;
/**
 *  判断输入是否为电话号码格式
 *
 *
 *  @return 格式正确返回YES,格式错误返回NO
 */
- (BOOL)isPhoneNumber;
/**
 *  判断输入是否是手机号码
 *
 *
 *  @return 返回YES 则输入为手机号码格式，返回No,则输入格式不是手机号码
 */
- (BOOL)isValidateMobileNumber;
/**
 *  判断驶入是否为密码
 * 格式为：6-20为由字母和数字组成
 *  @return 返回YES 则输入为正确格式，返回No,则输入格式错误
 */
- (BOOL)isValidatePassword;
@end
