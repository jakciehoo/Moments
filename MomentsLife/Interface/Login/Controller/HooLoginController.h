//
//  HooLoginController.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/18.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface HooLoginController : UIViewController<TencentSessionDelegate>
@property (nonatomic, retain)TencentOAuth *tencentOAuth;

@end
