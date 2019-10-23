//
//  HooUserManager.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/4.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooUserManager.h"
#import <BmobSDK/Bmob.h>
#import <ShareSDK/ShareSDK.h>


static HooUserManager *userManager;

@implementation HooUserManager

+ (instancetype)manager
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        userManager = [[HooUserManager alloc] init];
        
    });
    return userManager;
}

- (BmobUser *)getCurrentUser
{
    return [BmobUser getCurrentUser];
}
- (void)logout
{
    [BmobUser logout];
}

#pragma mark - 登录
- (void)LoginWithUserName:(NSString *)userName andPassword:(NSString *)password block:(void(^)(BmobUser *user, NSError *error))block
{
    if (block) {
        
        [BmobUser loginInbackgroundWithAccount:userName andPassword:password block:block];
    }
}

- (void)registerWithUserName:(NSString *)userName andPassword:(NSString *)password andEmail:(NSString *)email block:(void(^)(BOOL isSuccessful, NSError *error))block
{
    BmobUser *user = [[BmobUser alloc] init];
    user.username = userName;
    user.password = password;
    user.email = email;
    if (block) {
        
        [user signUpInBackgroundWithBlock:block];
    }

}
- (void)requestSMSCodeInBackgroundWithPhoneNumber:(NSString *)phoneNumber block:(void(^)(int number, NSError *error))block
{
    if (block) {
        
        [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:phoneNumber andTemplate:@"电话号码" resultBlock:block];
    }
}

- (void)registerWithPhoneNumber:(NSString *)phoneNumber andSMSCode:(NSString *)smsCode andPassword:(NSString *)password  block:(void(^)(BmobUser *user, NSError *error))block
{
    if (block == nil) {
        return;
    }
    if (password.length > 0) {
        [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:phoneNumber SMSCode:smsCode andPassword:password block:block];
    }else{
        [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:phoneNumber andSMSCode:smsCode block:block];
    
    }

}

- (void)changeUserName:(NSString *)userName block:(void(^)(BOOL isSuccessful, NSError *error))block
{
    if (userName.length == 0) {
        return;
    }
    BmobUser *bUser = [BmobUser getCurrentUser];
    [bUser setObject:userName forKey:@"username"];
    [bUser updateInBackgroundWithResultBlock:block];
}

- (void)loginThirdPartyWith:(NSDictionary *)dic block:(void(^)(BmobUser *user, NSError *error))block
{
    if (block) {
        
        [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:BmobSNSPlatformQQ block:block];
    }
}


@end
