//
//  HooSettingCell.m
//  HooLottery
//
//  Created by HooJackie on 15/7/6.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooSettingCell.h"
#import "HooSettingArrowItem.h"
#import "HooSettingItem.h"
#import "HooSettingSwitchItem.h"
#import "HooSettingLabelItem.h"
@interface HooSettingCell ()

@property (nonatomic,strong) UISwitch *switchView;
@property (nonatomic,strong) UILabel *label;


@end

@implementation HooSettingCell


- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}
- (UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        _label.textAlignment = NSTextAlignmentRight;
        _label.textColor = [UIColor redColor];
    }
    return _label;
}

- (void)setItem:(HooSettingItem *)item
{
    _item = item;
    
    [self setupData];
    
    [self setupAccessoryView];
    
}

- (void)setupData
{
    if (_item.icon.length) {
        
        self.imageView.image = [UIImage imageNamed:_item.icon];
    }
    
    self.textLabel.text = _item.title;
    self.detailTextLabel.text = _item.subtitle;
}
- (void)setupAccessoryView
{
    if ([_item isKindOfClass:[HooSettingArrowItem class]]) {
        
        //self.accessoryView = self.imgView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if ([_item isKindOfClass:[HooSettingSwitchItem class]])
    {
        self.accessoryView = self.switchView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if ([_item isKindOfClass:[HooSettingLabelItem class]]){
        self.accessoryView = self.label;
        HooSettingLabelItem *labelItem = (HooSettingLabelItem *)_item;
        self.label.text = labelItem.text;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    HooSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HooSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}


@end
