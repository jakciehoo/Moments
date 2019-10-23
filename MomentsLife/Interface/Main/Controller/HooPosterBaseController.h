//
//  HooPosterBaseController.h
//  MomentsLife
//
//  Created by HooJackie on 15/9/19.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
// 丁丁记和丁丁印的父控件

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface HooPosterBaseController : UITableViewController
/**
 *  我的创作清单数组
 */
@property (nonatomic, strong) NSMutableArray *myPosters;
/**
 *  可创作项数组
 */
@property (nonatomic, strong) NSMutableArray *createList;

@property (nonatomic, weak)UITableViewCell *selectedCell;
/**
 *  加载我的创作
 */
- (void)loadMyPosters;
/**
 *  加载更多我的创作
 */
- (void)loadMoreMyPosters;


@end
