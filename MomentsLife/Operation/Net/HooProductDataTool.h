//
//  HooProductDataTool.h
//  MomentsLife
//
//  Created by HooJackie on 15/9/29.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import <Foundation/Foundation.h>

@interface HooProductDataTool : NSObject

+ (void)createProductArraySuccess:(void(^)(BOOL flag, NSMutableArray *productArray))success;


@end
