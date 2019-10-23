//
//  HooProdcutListController.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/24.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import "HooProdcutListController.h"
#import "HooProductListCell.h"
#import "HooEditViewController.h"
#import "HooStopAutoRotationNaviController.h"
#import "HooProduct.h"

@interface HooProdcutListController ()

@property (nonatomic, strong) NSMutableArray *products;

@end

@implementation HooProdcutListController

static NSString *ProductCellID = @"ProductCell";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"请选择产品";
    self.tableView.backgroundColor = HooColor(248, 248, 248);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HooProductListCell" bundle:nil] forCellReuseIdentifier:ProductCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.products.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HooProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductCellID];
    cell.product = self.products[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HooEditViewController *editCtrl = [[HooEditViewController alloc] init];
    HooProduct *product = self.products[indexPath.section];
    [editCtrl setValue:product forKey:@"_product"];
    
    HooStopAutoRotationNaviController *navi = [[HooStopAutoRotationNaviController alloc] initWithRootViewController:editCtrl];
    
    [self presentViewController:navi animated:YES completion:nil];
}




@end
