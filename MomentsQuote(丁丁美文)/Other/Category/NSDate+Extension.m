//
//  NSDate+Extension.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/27.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
+(NSString *)intervalStringFromDate:(NSDate *)date
{
    NSTimeInterval interval = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d",(int)interval];
}

@end
