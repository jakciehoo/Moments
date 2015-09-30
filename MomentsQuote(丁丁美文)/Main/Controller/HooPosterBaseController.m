//
//  HooPosterBaseController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/19.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooPosterBaseController.h"

#import "HooPosterCell.h"
#import "HooCreateCell.h"


@implementation HooPosterBaseController

static NSString *CreateCellID = @"CreateCell";
static NSString *PosterCellID = @"PosterCell";
#pragma mark - 懒加载
//我创建的美文美图数组
- (NSMutableArray *)myPosters
{
    if (_myPosters == nil) {
        _myPosters = [NSMutableArray array];
    }
    return _myPosters;
}
//创建选择项目
- (NSMutableArray *)createList
{
    if (_createList == nil) {
        _createList = [NSMutableArray array];
    }
    return _createList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
    
}
//初始化视图
- (void)setupView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HooCreateCell" bundle:nil] forCellReuseIdentifier:CreateCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"HooPosterCell" bundle:nil] forCellReuseIdentifier:PosterCellID];
    [self.tableView addHeaderWithTarget:self action:@selector(loadMyPosters)];
    [self.tableView headerBeginRefreshing];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreMyPosters)];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loadMyPosters
{

}

- (void)loadMoreMyPosters
{
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.createList.count + self.myPosters.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.createList.count) {
        return 44;
    }
    return 330;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.createList.count) {
        
        HooCreateCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:CreateCellID];
        NSString *createStr = [NSString stringWithFormat:@"%@ >>",self.createList[indexPath.row]];
        cell.createLabel.text = createStr;
        return cell;
    }else{
        HooPosterCell *cell = [tableView dequeueReusableCellWithIdentifier:PosterCellID forIndexPath:indexPath];
        cell.myMoment = self.myPosters[indexPath.row - self.createList.count];
        
        return cell;
    }
}

@end
