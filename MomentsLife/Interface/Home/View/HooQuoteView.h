//
//  HooQuoteView.h
//  MomentsLife
//
//  Created by HooJackie on 15/8/15.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HooMoment;

@interface HooQuoteView : UIView

@property (nonatomic, strong) HooMoment *moment;


/**
 *  美文颜色
 */
@property (nonatomic, strong) UIColor *quoteColor;

/**
 *  美文字体大小
 */
@property (assign, nonatomic) CGFloat quoteSize;
/**
 *  美文字体名称
 */
@property (nonatomic, strong) NSString *quoteFontName;
/**
 *  美文背景颜色
 */
@property (nonatomic, strong) UIColor *quoteBgColor;
/**
 *  是否显示文字
 */
@property (nonatomic, assign,getter=isShowQuote) BOOL showQuote;

@property (nonatomic, assign,getter=isShowAuthor) BOOL showAuthor;



/**
 *  类方法，初始化实例，返回类的实例
 *
 *  @return 返回类的实例
 */
+ (instancetype)quoteView;
@end
