//
//  HooVersionTool.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/16.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HooVersionTool : NSObject

+ (void)getAppVersionWithBlock:(void(^)(NSString *versionStr, NSError *error))block;

@end
