//
//  HooTabBar.h
//  HooWeibo
//
//  Created by HooJackie on 15/7/25.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HooTabBar;
@class HooFlowerButton;

/**
 *  HooTabBar代理,当单击按钮时调用
 */
@protocol HooTabBarDelegate <NSObject>

- (void)tabBar:(HooTabBar *)tabBar didClickButton:(NSInteger)index;


@end

@interface HooTabBar : UIView
/**
 *  UITabBarItem类型的数组
 */
@property (nonatomic, strong) NSArray      *items;
@property (nonatomic, strong) UITabBarItem *selectedItem;
/**
 * HooTabBarDelegate类型的代理变量
 */
@property (nonatomic,weak) id<HooTabBarDelegate> delegate;
/**
 *  中心按钮
 */
@property (nonatomic, strong) HooFlowerButton *centerButton;




@end
