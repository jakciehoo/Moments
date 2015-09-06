//
//  UIColor+Extension.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/6.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)


- (NSArray *)getRGBComponents {
    NSMutableArray *components = [NSMutableArray array];
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        [components addObject:@(resultingPixel[component] / 255.0f)];
    }
    return components;
}

@end
