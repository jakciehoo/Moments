//
//  HooSqlliteTool.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/24.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HooMoment;

@interface HooSqlliteTool : NSObject

/**
 *  获取某个时间modified_date之前,是否收藏，包含文字内容 ，限制一定个数的文字的数据
 *
 *  @param modified_date 修改日期 允许为空
 *  @param isStared       是否被收藏 允许为空
 *  @param text          根据text模糊检索美文 允许为空
 *  @param count         限制返回数据的个数 允许为空
 *
 *  @return 返回数据数组
 */
+ (NSArray *)momentsBeforeDate:(NSString *)modified_date andIsStared:(BOOL)isStared containText:(NSString *)text limitCount:(NSInteger)count;
/**
 *  根据修改日期，从数据库中获取数据并返回HooMoment对象
 *
 *  @param modified_date 修改日期
 *
 *  @return 返回HooMoment对象
 */
+ (HooMoment *)momentWithModified_date:(NSString *)modified_date;
/**
 *
 *根据ID，从数据库中获取数据并返回HooMoment对象
 *  @param ID 数据库中的ID字段
 *
 *  @return 返回HooMoment对象
 */
+ (HooMoment *)momentWithID:(NSInteger)ID;
/**
 *  更新美文数据
 *
 *  @param momentDict 需要更新的美文美图
 */
+ (void)updateMoment:(HooMoment *)moment;

/**
 *  增加的新的美文美图
 *
 *  @param moment 新的美文美图
 */
+ (void)addNewMoment:(HooMoment *)moment;



@end
