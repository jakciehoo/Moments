//
//  HooOrderDeliveryController.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/6.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooOrderDeliveryController.h"
#import "HooOrderDeliveryManager.h"
#import "OrderDelivery.h"

@interface HooOrderDeliveryController ()

@property (nonatomic,strong)NSArray *deliveries;

@property (nonatomic,strong)OrderDelivery *defaultDelivery;

@end

@implementation HooOrderDeliveryController

#pragma mark - 懒加载
- (NSArray *)deliveries
{
    if (_deliveries == nil) {
        _deliveries = [NSArray array];
    }
    return _deliveries;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    __weak typeof(self) weakSelf = self;
    [[HooOrderDeliveryManager manager] deliveriesWithBlock:^(NSArray *deliveries, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error) {
            
            HooLog(@"获取快递数据失败");
        }
        if (deliveries) {
            
            strongSelf.deliveries = deliveries;
            [strongSelf.tableView reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.deliveries.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [UIImage imageNamed:@"ay_select_gray"];
    UIImage *selectedImage = [UIImage imageNamed:@"ay_select_green"];
    [accessoryButton setImage:normalImage forState:UIControlStateNormal];
    [accessoryButton setImage:selectedImage forState:UIControlStateSelected];
    accessoryButton.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    cell.accessoryView = accessoryButton;
    if (self.deliveries.count) {
        OrderDelivery *delivery = self.deliveries[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@    %@",delivery.delivery_name,delivery.delivery_price];
        cell.detailTextLabel.text = delivery.delivery_time;
        UIButton *button = (UIButton *)cell.accessoryView;
        if ([delivery.is_default boolValue]) {
            self.defaultDelivery = delivery;
        }
        button.selected = [delivery.is_default boolValue];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDelivery *selectedDelivery = self.deliveries[indexPath.row];
    
    if (selectedDelivery != self.defaultDelivery) {
        self.defaultDelivery.is_default = @(NO);
        selectedDelivery.is_default = @(YES);
        [[HooOrderDeliveryManager manager] updateDeliveryWithDelivery:selectedDelivery WithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                HooLog(@"设置默认快递成功");
            }
        }];
        [[HooOrderDeliveryManager manager] updateDeliveryWithDelivery:self.defaultDelivery WithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                HooLog(@"修改默认快递成功");
            }
        }];
    }

    
    if ([self.delegate respondsToSelector:@selector(didSelectDelivery:)]) {
        [self.delegate didSelectDelivery:selectedDelivery];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
