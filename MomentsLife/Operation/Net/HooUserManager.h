//
//  HooUserManager.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/4.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BmobUser;

@interface HooUserManager : NSObject
+ (instancetype)manager;
//获得当前用户
- (BmobUser *)getCurrentUser;

- (void)logout;

//用户名\手机号和密码方式登录
- (void)LoginWithUserName:(NSString *)userName andPassword:(NSString *)password block:(void(^)(BmobUser *user, NSError *error))block;
//用户名和密码方式注册
- (void)registerWithUserName:(NSString *)userName andPassword:(NSString *)password andEmail:(NSString *)email block:(void(^)(BOOL isSuccessful, NSError *error))block;
//手机短信验证
- (void)requestSMSCodeInBackgroundWithPhoneNumber:(NSString *)phoneNumber block:(void(^)(int number, NSError *error))block;
//手机号码和验证码方式注册
- (void)registerWithPhoneNumber:(NSString *)phoneNumber andSMSCode:(NSString *)smsCode andPassword:(NSString *)password  block:(void(^)(BmobUser *user, NSError *error))block;
/**
 *  修改用户名
 *
 *  @param userName 新用户名
 *  @param block    回调
 */
- (void)changeUserName:(NSString *)userName block:(void(^)(BOOL isSuccessful, NSError *error))block;
/**
 *  第三方登录
 *
 *  @param dic   用户名密码字典
 *  @param block 回调
 */
- (void)loginThirdPartyWith:(NSDictionary *)dic block:(void(^)(BmobUser *user, NSError *error))block;
@end
