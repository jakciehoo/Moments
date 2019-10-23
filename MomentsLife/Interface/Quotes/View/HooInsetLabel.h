//
//  HooInsetLabel.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/8.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HooInsetLabel : UILabel

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
