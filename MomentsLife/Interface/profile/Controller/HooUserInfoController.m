//
//  HooUserInfoController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/19.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooUserInfoController.h"
#import "XHPathCover.h"
#import <BmobSDK/BmobUser.h>

@interface HooUserInfoController ()

@property (nonatomic, weak) XHPathCover *pathCover;

@end

@implementation HooUserInfoController


- (void)viewDidLoad {
    [super viewDidLoad];
    

}
- (void)setupView
{
    XHPathCover *pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 250)];
    self.tableView.tableHeaderView = pathCover;
    self.pathCover = pathCover;
    
    __weak typeof(self) wself = self;
    [_pathCover setHandleRefreshEvent:^{
        [wself _refreshing];
    }];
}
- (void)_refreshing {
    // refresh your data sources
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        HooLog(@"用户已经登录");
    }
    
    
    __weak typeof(self) wself = self;
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [wself.pathCover stopRefresh];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = @"PathCover Cell";
    
    return cell;
}

@end
