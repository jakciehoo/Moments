//
//  HooInsetsLabel.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/26.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//自定义UILabel控件，扩展增加实现内边距属性

#import <UIKit/UIKit.h>

@interface HooLabel : UILabel
/**
 *  内边距
 */
@property(nonatomic) UIEdgeInsets insets;
/**
 *  初始化内边距的方法
 *
 *  @param frame  大小
 *  @param insets 内边距
 *
 *  @return 返回自身类型
 */
-(instancetype) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(instancetype) initWithInsets: (UIEdgeInsets) insets;
@end
