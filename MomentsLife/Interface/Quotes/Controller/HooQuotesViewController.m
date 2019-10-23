//
//  HooQuotesViewController.m
//  MomentsLife
//
//  Created by HooJackie on CountPerTime/8/3.
//  Copyright (c) 20CountPerTime年 jackieHoo. All rights reserved.
//

#import "HooQuotesViewController.h"
#import "HooJSONTool.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "HooSqlliteTool.h"
#import "HooQuotesCell.h"
#import "HooAddQuoteCell.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "NSDate+Extension.h"
#import "HooQuoteController.h"
#import "HooCreateQuoteViewController.h"

#define CountPerTime 16

@interface HooQuotesViewController ()<UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isStared;

@end

@implementation HooQuotesViewController
//记录第一进入页面时的屏幕宽度
static CGFloat deviceWidth;
//cell 重复利用的标示符
static NSString * const reuseIdentifier = @"Cell";
//static NSString * const addQuoteID = @"AddQuoteCell";

#pragma mark - 懒加载
- (NSMutableArray *)moments
{
    if (_moments == nil) {
        _moments = [NSMutableArray array];
    }
    return _moments;
}

- (instancetype)init
{
    if (self = [super init]) {
        //如果数据库从还没有数据，那我们先从json文件中，将数据保存到数据库中
        NSArray *moreMoments = [HooSqlliteTool momentsBeforeDate:nil andIsStared:NO containText:nil limitCount:CountPerTime];
        if (moreMoments.count == 0) {
            BOOL flag = [HooJSONTool saveMoments];
            if (!flag) {
                [SVProgressHUD showErrorWithStatus:@"糟糕！出现万分之一可能性的意外，请重启"];
            }
        }
        self.showQuote = YES;
        //初始化静态变量的唯一值，用于保存屏幕宽度，在程序运行过程一直保存在内存中不会改变
        deviceWidth = HooScreenSize.width;
        //定义CollectionView的布局方式
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (HooScreenSize.width - 8) / 2;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
        flowLayout.minimumLineSpacing = 4.0;
        flowLayout.minimumInteritemSpacing = 4.0;
        self = [self initWithCollectionViewLayout:flowLayout];
    }
    return self;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    [self setupNavigationBar];
    
    [self setupCollectionView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self reloadMoments];
}
#pragma mark - 初始化导航栏
- (void)setupNavigationBar
{
    //添加一个searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    searchBar.placeholder = @"查找";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;

    _searchBar = searchBar;
    //添加一个分段控件
    UISegmentedControl *segmentedCtrl = [[UISegmentedControl alloc] initWithItems:@[[UIImage imageNamed:@"gallery_tiny_navi"],[UIImage imageNamed:@"star_tiny_navi"]]];
    segmentedCtrl.selectedSegmentIndex = 0;
    segmentedCtrl.size = CGSizeMake(80, 30);
    [segmentedCtrl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedCtrl];
    
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 初始化collectionView
- (void)setupCollectionView
{
    self.collectionView.backgroundColor = HooColor(223, 223, 223);
    [self.collectionView registerNib:[UINib nibWithNibName:@"HooQuotesCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    //[self.collectionView registerNib:[UINib nibWithNibName:@"HooAddQuoteCell" bundle:nil] forCellWithReuseIdentifier:addQuoteID];
    [self.collectionView addHeaderWithTarget:self action:@selector(reloadMoments)];
    [self.collectionView headerBeginRefreshing];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreMoments)];
}
- (void)segmentValueChanged:(UISegmentedControl *)sender
{
    self.isStared = sender.selectedSegmentIndex;
    [self reloadMoments];

}
#pragma mark - 加载更多美文
- (void)reloadMoments
{
    [self.moments removeAllObjects];
    [self loadMoreMoments];
    [self.collectionView headerEndRefreshing];
}



#pragma mark - 屏幕旋转时的改变布局流，横屏为3行，竖屏为2行
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    // 根据屏幕宽度决定列数
    int cols = (size.width == deviceWidth) ? 2 : 3;
    // 根据列数计算内边距
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat itemWidth = (size.width - 8) / cols;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    //flowLayout.sectionInset = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0);
    flowLayout.minimumLineSpacing = 4.0;
    flowLayout.minimumInteritemSpacing = 4.0;
    flowLayout.footerReferenceSize = CGSizeMake(size.width, 100.0);
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.moments.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    HooQuotesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.moment = self.moments[indexPath.item];
    cell.showQuote = self.isShowQuote;
        return cell;

    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.item == 0) {
//        HooCreateQuoteViewController *createQuoteCtrl = [[HooCreateQuoteViewController alloc] init];
//        createQuoteCtrl.title = @"添加文字";
//        [self.navigationController pushViewController:createQuoteCtrl animated:YES];
//    }
//
//    if (indexPath.item > 0) {
        if ([self.from isEqualToString:@"create"]) {
            if ([self.delegate respondsToSelector:@selector(quoteDidSelected:author:)]) {
                HooQuotesCell *cell = (HooQuotesCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                NSString *quote = cell.moment.quote;
                NSString *author = cell.moment.author;
                [self.delegate quoteDidSelected:quote author:author];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            HooQuoteController *quoteCtrl = [[HooQuoteController alloc] init];
            quoteCtrl.originMoment = self.moments[indexPath.item];
            [self.navigationController pushViewController:quoteCtrl animated:YES];
        }
    //}
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [self reloadMoments];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.moments removeAllObjects];
    [self reloadMoments];
}

- (void)loadMoreMoments
{
    if (self.moments.count == 0) {
        NSDate *now = [NSDate date];
        NSString *nowString = [now convertDateTointervalString];
        NSArray *moreMoments = [HooSqlliteTool momentsBeforeDate:nowString andIsStared:self.isStared containText:self.searchBar.text limitCount:CountPerTime];
        [self.moments addObjectsFromArray:moreMoments];
    }else{
        HooMoment *lastMoment = (HooMoment *)self.moments.lastObject;
        NSArray *moreMoments = [HooSqlliteTool momentsBeforeDate:lastMoment.modified_date andIsStared:self.isStared containText:self.searchBar.text limitCount:CountPerTime];
        [self.moments addObjectsFromArray:moreMoments];
        //如果数量小于CountPerTime，说明数据加载到最后了，我就弹出提示
        if (moreMoments.count < CountPerTime) {

            //弹出提示，然后3秒后隐藏
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD showInfoWithStatus:@"丁丁印记加载到最后了，每天更新一条美文，请等待！"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        }
    }
    [self.collectionView footerEndRefreshing];
    [self.collectionView reloadData];
    
}




@end
