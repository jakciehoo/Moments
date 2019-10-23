//
//  HooBaseTableViewController.m
//  HooLottery
//
//  Created by HooJackie on 15/7/6.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooBaseTableViewController.h"
#import "HooSettingGroup.h"
#import "HooSettingCell.h"
#import "HooSettingArrowItem.h"

@interface HooBaseTableViewController ()

@end


@implementation HooBaseTableViewController

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        //Creates and returns an empty array.
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    HooSettingGroup *group = self.dataList[section];
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HooSettingCell *cell = [[HooSettingCell class] cellWithTableView:tableView];
    HooSettingGroup *group = self.dataList[indexPath.section];
    HooSettingItem *item = group.items[indexPath.row];
    cell.item = item;
    
    // Configure the cell...
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    HooSettingGroup *group = self.dataList[section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    HooSettingGroup *group = self.dataList[section];
    return group.footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    HooSettingGroup *group = self.dataList[indexPath.section];
    HooSettingItem *item = group.items[indexPath.row];
    
    if (item.option) {
        item.option();
        return;
    }
    if ([item isKindOfClass:[HooSettingArrowItem class]]) {
        HooSettingArrowItem *arrowItem = (HooSettingArrowItem *)item;
        if (arrowItem.destVcClass) {
            UITableViewController *vc = [[arrowItem.destVcClass alloc] init];
            vc.title = item.title;
            [self.navigationController pushViewController:vc animated:true];
        }
    }
}

@end
