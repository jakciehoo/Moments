//
//  UIColor+Extension.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/6.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
/**
 *  从颜色中获取RGB值
 *
 *  @return float类型的数组，包含3个值依次对应为R,G,B的值
 */
- (NSArray *)getRGBComponents;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
@end
