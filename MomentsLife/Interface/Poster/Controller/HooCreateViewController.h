//
//  HooCreateViewController.h
//  MomentsLife
//
//  Created by HooJackie on 15/8/14.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HooMoment;
@interface HooCreateViewController : UITableViewController
/**
 *  美文美图数据模型
 */
@property (nonatomic,strong) HooMoment *moment;
/**
 *  是否来自自动创建
 */
@property (nonatomic,assign,getter=isFromAuto) BOOL fromAuto;
/**
 *  是否来自己编辑
 */
@property (nonatomic,assign,getter=isFromEdit) BOOL fromEdit;

@end
