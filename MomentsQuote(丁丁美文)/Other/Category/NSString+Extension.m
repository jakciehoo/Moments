//
//  NSString+Etension.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/18.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL)isEmpty
{
    if (!self || [self isEqualToString:@""] || self.length == 0) {
        return YES;
    } else {
        return NO;
    }
}
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


- (BOOL)isPhoneNumber
{
    NSError *error;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    if (error) {
        HooLog(@"error : %@",error);
        return NO;
    }
    NSRange inputRange = NSMakeRange(0, self.length);
    NSArray *matches = [detector matchesInString:self options:0 range:inputRange];
    if (matches.count == 0) {
        return NO;
    }
    NSTextCheckingResult *result = matches[0];
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
        return YES;
    } else {
        return NO;
    }
}

@end
