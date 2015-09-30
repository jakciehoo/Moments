//
//  HooMyPrintsController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/19.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//
#import "HooMyPrintPostersController.h"
#import "HooLoginController.h"
#import "HooStopAutoRotationNaviController.h"
#import "HooProdcutListController.h"
#import "HooProductDataTool.h"
#import "MJExtension.h"
#import "HooProduct.h"
#import "HooProductCategory.h"
#import "SVProgressHUD.h"

@interface HooMyPrintPostersController ()
//产品类目
@property (nonatomic, strong)NSMutableArray *categories;

@end


@implementation HooMyPrintPostersController

#pragma mark - 懒加载
//产品类目
- (NSMutableArray *)categories
{
    if (_categories == nil) {
        _categories = [NSMutableArray array];
    }
    return _categories;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [HooProductDataTool createCategoryPlist];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"丁丁印";
    [self setupNavi];
    
    

}
#pragma mark - 初始化导航栏
- (void)setupNavi
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_usercenter2"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserInfo)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_cart2"] style:UIBarButtonItemStylePlain target:self action:@selector(showCollection)];
}

- (void)showUserInfo
{
    HooLoginController *loginCtrl = [[HooLoginController alloc] init];
    HooStopAutoRotationNaviController *Navi = [[HooStopAutoRotationNaviController alloc] initWithRootViewController:loginCtrl];
    [self presentViewController:Navi animated:YES completion:nil];
    //[self.navigationController pushViewController:loginCtrl animated:YES];
    
}
- (void)showCollection
{

}

- (void)loadMyPosters
{
    [self loadCreateList];
    [self.tableView headerEndRefreshing];
    
}
- (void)loadMoreMyPosters
{
    [self.tableView footerEndRefreshing];
}

- (void)loadCreateList
{
    [self.createList removeAllObjects];
    
    NSString *plistPath = [HooDocumentDirectory stringByAppendingPathComponent:@"product.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        [SVProgressHUD showErrorWithStatus:@"可能有网络问题,请检查网络后下拉刷新试试！"];
    }
    [self.categories removeAllObjects];
    self.categories = [HooProductCategory objectArrayWithFile:plistPath];
    
    for (HooProductCategory *category in self.categories) {
        [self.createList addObject:category.category_name];
    }

    [self.tableView reloadData];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.createList.count) {
        HooProductCategory *category = self.categories[indexPath.row];
        NSArray *products = category.products;

        HooProdcutListController *productListCtrl = [[HooProdcutListController alloc] init];
        [productListCtrl setValue:products forKey:@"_products"];
        [self.navigationController pushViewController:productListCtrl animated:YES];
    }
}


@end
