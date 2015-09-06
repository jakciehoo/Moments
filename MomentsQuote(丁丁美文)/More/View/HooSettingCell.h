//
//  HooSettingCell.h
//  HooLottery
//
//  Created by HooJackie on 15/7/6.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HooSettingItem;
@interface HooSettingCell : UITableViewCell
@property (nonatomic,strong) HooSettingItem *item;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
