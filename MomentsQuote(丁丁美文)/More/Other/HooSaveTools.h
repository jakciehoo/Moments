//
//  HooSaveTools.h
//  HooLottery
//
//  Created by HooJackie on 15/7/7.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HooSaveTools : NSObject
/**
 *  沙盒中存取Object对象
 *
 *  @param value       值
 *  @param defaultName 名
 */
+ (void)setObject:(id)value forKey:(NSString *)defaultName;
+ (id)objectForKey:(NSString *)defaultName;


/**
 *沙盒中存取BOOL类型数据
 *
 *  @param value       Bool值
 *  @param defaultName 名
 */
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
+ (BOOL)boolForkey:(NSString *)defaultName;

/**
 *沙盒中存取NSInteger类型数据
 *
 *  @param value       NSInteger类型的值
 *  @param defaultName 名
 */
+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
+ (NSInteger)integerForkey:(NSString *)defaultName;




@end
