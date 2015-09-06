//
//  HooPosterViewController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/13.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooPosterViewController.h"
#import "HooMainNavigationController.h"
#import "HooCreateViewController.h"
#import "HooPosterCell.h"
#import "HooCreateCell.h"

@interface HooPosterViewController ()

@property (nonatomic, strong) NSMutableArray *postList;
@property (nonatomic, strong) NSMutableArray *createList;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation HooPosterViewController

static NSString *ID = @"cell";

- (NSMutableArray *)postList
{
    if (_postList == nil) {
        _postList = [NSMutableArray array];
    }
    return _postList;
}

- (NSMutableArray *)createList
{
    if (_createList == nil) {
        _createList = [NSMutableArray array];
        [_createList addObject:@"动手创作 >>"];
        [_createList addObject:@"懒人方法 >>"];
    }
    return _createList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创作";
    
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

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HooCreateCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:ID];

        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HooCreateCell" owner:nil options:nil] lastObject];
        }
    cell.createLabel.text = self.createList[indexPath.row];
    
    // Configure the cell...
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 || indexPath.row == 1) {
        HooCreateViewController *createCtrl = [[HooCreateViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:createCtrl animated:YES];
    }
}



@end
