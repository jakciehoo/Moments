//
//  NSDate+Extension.m
//  MomentsLife
//
//  Created by HooJackie on 15/8/27.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
- (NSString *)convertDateTointervalString
{
    NSTimeInterval interval = [self timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d",(int)interval];
}

+ (NSString *)readableTimeFromIntervalString:(NSString *)intervalString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[intervalString intValue]];
    NSString*readableTime = [formatter stringFromDate:date];
    return readableTime;
}


- (NSString *)dateWithMMDDAndConvertToString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}
- (instancetype)DateWitthYYYYMMddHHmmssFormater
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *dateStr = [formatter stringFromDate:self];
    return [formatter dateFromString:dateStr];
    
}

@end
