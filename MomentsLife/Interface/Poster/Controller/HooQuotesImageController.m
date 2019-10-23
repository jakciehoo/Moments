//
//  HooQuotesImageController.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/10.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooQuotesImageController.h"
#import "HooMoment.h"
#import "HooPhoto.h"

@interface HooQuotesImageController ()

@end

@implementation HooQuotesImageController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"丁丁时刻";
//    self.showQuote = NO;
    
   // [self.collectionView registerNib:[UINib nibWithNibName:@"HooQuotesImageCell" bundle:nil] forCellWithReuseIdentifier:QuotesImageCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.QuotesImageDelegate respondsToSelector:@selector(selectMoment:)]) {
        HooMoment *moment = self.moments[indexPath.row];
        [self.QuotesImageDelegate selectMoment:moment];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



@end
