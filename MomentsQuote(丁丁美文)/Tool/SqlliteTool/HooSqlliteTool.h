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
 *  获取数据库的记录条数
 *
 *  @return 记录条数
 */
+ (NSInteger)momentsCount;

+ (NSInteger)myMomentsCount;

/**
 *  获取某个时间modified_date之前,是否收藏，包含文字内容 ，限制一定个数的文字的数据
 *
 *  @param modified_date 修改日期 允许为空
 *  @param isStared       是否被收藏 允许为空
 *  @param text          根据text模糊检索美文 允许为空
 *  @param count         限制返回数据的个数 非空
 *
 *  @return 返回数据数组
 */
+ (NSArray *)momentsBeforeDate:(NSString *)modified_date andIsStared:(BOOL)isStared containText:(NSString *)text limitCount:(NSInteger)count;
/**
 *  根据修改日期date,获取一定数量count的自己创建的moment类型的数组
 *
 *  @param date          Interval秒数转NSString类型的的时间
 *  @param count         限制返回数据的个数
 *  @return moment类型的数组
 */
+ (NSArray *)getMyMomentsBefore:(NSString *)date LimitCount:(NSInteger)count;
/**
 *  获取自己创建的Moment
 *
 *  @param ID momentID
 *
 *  @return moment对象
 */
+ (HooMoment *)myMomentWithID:(NSInteger)ID;
/**
 *  获取我创建的前一个美文美图对象
 *
 *  @param ID 目前的美文美图ID编号
 *
 *  @return 创建的前一个美文美图
 */
+ (HooMoment *)myOlderMomentOfMyMomentWithID:(NSInteger)ID;
/**
 *  获取ID最大的我创建的美文美图对象
 *
 *  @return ID最大的我创建的美文美图对象
 */
+ (HooMoment *)myMomentWithMaxID;
/**
 *  随机获取我的创建的美文美图对象
 *
 *  @return 随机获取的我的创建的美文美图对象
 */
+ (HooMoment *)myRandomMoment;
/**
 *
 *根据ID，从数据库中获取数据并返回HooMoment对象
 *  @param ID 数据库中的ID字段
 *
 *  @return 返回HooMoment对象
 */
+ (HooMoment *)momentWithID:(NSInteger)ID;
/**
 *  获取前一个美文美图对象
 *
 *  @param ID 目前的美文美图ID编号
 *
 *  @return 前一个美文美图
 */
+ (HooMoment *)olderMomentOfMomentWithID:(NSInteger)ID;
/**
 *  获取ID最大的美文美图对象
 *
 *  @return ID最大的美文美图对象
 */
+ (HooMoment *)momentWithMaxID;
/**
 * 随机获取的美文美图对象
 *
 *  @return 随机获取的美文美图对象
 */
+ (HooMoment *)randomMoment;
/**
 *  返回show_date为date的转化为HooMoment类型的数据
 *
 *  @param date 日期
 *
 *  @return HooMoment类型的数据
 */
+ (HooMoment *)momentWithshowDate:(NSDate *)date;
/**
 *  更新创建的美文数据
 *
 *  @param moment 需要更新的美文美图
 */
+ (BOOL)updateMyMoment:(HooMoment *)moment;
/**
 *  更新美文数据
 *
 *  @param moment 需要更新的美文美图
 */
+ (BOOL)updateMoment:(HooMoment *)moment;
/**
 *增加的新的美文美图
 *
 *  @param moment 新的美文美图
 *
 *  @return 新增成功返回yes,否则返回NO
 */
+ (BOOL)addNewMyMoment:(HooMoment *)moment;
/**
 *  增加的新的美文美图
 *
 *  @param moment 新的美文美图
 */
+ (BOOL)addNewMoment:(HooMoment *)moment;
/**
 *  删除创建的数据
 *
 *  @param ID 对应编号
 *
 *  @return 成功返回YES,失败返回NO
 */
+ (BOOL)deleteMyMomentWith:(NSInteger)ID;
/**
 *  删除数据
 *
 *  @param ID 对应编号
 *
 *  @return 成功返回YES,失败返回NO
 */
+ (BOOL)deleteMomentWith:(NSInteger)ID;



@end
