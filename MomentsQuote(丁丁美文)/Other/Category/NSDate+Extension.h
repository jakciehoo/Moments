//
//  NSDate+Extension.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/27.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  将日期转化成距离1970的秒数的NSString类型
 *
 *  @return 距离1970的秒数的NSString类型
 */
- (NSString *)convertDateTointervalString;
/**
 *  将日期转化成可读格式
 *
 *  @param intervalString 距离1970的秒数的NSString类型
 *
 *  @return 格式为YYYY-MM-dd HH:mm的NSString类型对象
 */
+ (NSString *)readableTimeFromIntervalString:(NSString *)intervalString;
/**
 *  返回一个只有月日的时间并转化成NSString类型时间
 */
- (NSString *)dateWithMMDDAndConvertToString;
@end
