//
//  HooOrderAddressController.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooOrderAddressController.h"
#import "HooAddAddressController.h"
#import "OrderAddress.h"
#import "SVProgressHUD.h"
#import "HooOrderAddressManager.h"
#import "HooAddAddressButton.h"

@interface HooOrderAddressController ()



@property (nonatomic, weak)UIButton *addAddressButton;

@property (nonatomic, strong)NSMutableArray *addresses;

@property (nonatomic, strong)OrderAddress *defaultAddress;

@end

@implementation HooOrderAddressController

- (UIView *)addAddressButton
{
    if (_addAddressButton == nil) {
        HooAddAddressButton *addAddressButton = [[HooAddAddressButton alloc] initWithFrame:CGRectMake(0, HooKeyWindow.height, HooKeyWindow.width, 44)];
        [addAddressButton addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
        addAddressButton.backgroundColor = HooColor(57, 63, 75);
        [addAddressButton setTitle:@"新建收货地址" forState:UIControlStateNormal];
        _addAddressButton = addAddressButton;
        [HooKeyWindow addSubview:addAddressButton];
        
    }
    return _addAddressButton;
}

- (NSMutableArray *)addresses
{
    if (_addresses == nil) {
            _addresses = [NSMutableArray array];
    }
    return _addresses;
}

static NSString *CellID = @"CellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址";

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[HooOrderAddressManager manager] addressesQueryWithBlock:^(NSArray *addresses, NSError *error) {
        if (error) {
            
            HooLog(@"%@",error);
            return;
        }
        if (addresses.count) {
            [self.addresses removeAllObjects];
            [self.addresses addObjectsFromArray:addresses];
            [self.tableView reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    

    [UIView animateWithDuration:HooDuration/2 animations:^{
        self.addAddressButton.transform = CGAffineTransformMakeTranslation(0, -44);
    }];
}


- (void)addAddress:(UIButton *)sender
{
    HooAddAddressController *addAddressCtrl = [[HooAddAddressController alloc] init];
    [self.navigationController pushViewController:addAddressCtrl animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.addAddressButton removeFromSuperview];

}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addresses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    OrderAddress *address = self.addresses[indexPath.row];
    if ([address.is_default boolValue]) {
        cell.imageView.image = [UIImage imageNamed:@"ay_select_green"];
        cell.selected = YES;
        self.defaultAddress = address;
    }else{
        cell.imageView.image = [UIImage imageNamed:@"ay_select_gray"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",address.name,address.phone_number];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",address.country_address,address.detail_address];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"modify"];
    [accessoryButton setImage:buttonImage forState:UIControlStateNormal];
    [accessoryButton addTarget:self action:@selector(modifyAddress:) forControlEvents:UIControlEventTouchUpInside];
    accessoryButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    
    cell.accessoryView = accessoryButton;
    
    return cell;
}
- (void)modifyAddress:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
    
    NSInteger row = [self.tableView indexPathForCell:cell].row;
    
    HooAddAddressController *addAddressCtrl = [[HooAddAddressController alloc] init];
    addAddressCtrl.address = self.addresses[row];
    addAddressCtrl.edittingAddress = YES;
    [self.navigationController pushViewController:addAddressCtrl animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderAddress *selectedAddress = self.addresses[indexPath.row];
    
    if (selectedAddress != self.defaultAddress) {
        self.defaultAddress.is_default = @(NO);
        selectedAddress.is_default = @(YES);
    }
    [[HooOrderAddressManager manager] updateAddressWith:selectedAddress WithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self.tableView reloadData];
         HooLog(@"设置默认地址成功");
        }
    }];
    
    [[HooOrderAddressManager manager] updateAddressWith:self.defaultAddress WithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            HooLog(@"修改默认地址成功");
            [self.tableView reloadData];
        }
    }];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         OrderAddress *address = self.addresses[indexPath.row];
         [[HooOrderAddressManager manager] deleteAddressWith:address.objectId WithBlock:^(BOOL isSuccessful, NSError *error) {
             if (isSuccessful) {
                 [self.addresses removeObjectAtIndex:indexPath.row];
                 [tableView beginUpdates];
                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                 [tableView endUpdates];
                 [SVProgressHUD showSuccessWithStatus:@"成功删除数据"];

             }
         }];
 
     }
 }





@end
