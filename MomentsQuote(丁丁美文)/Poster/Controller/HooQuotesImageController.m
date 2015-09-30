//
//  HooQuotesImageController.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/10.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooQuotesImageController.h"
#import "HooQuotesImageCell.h"
#import "HooMoment.h"
#import "HooPhoto.h"

@interface HooQuotesImageController ()

@end

@implementation HooQuotesImageController

static NSString * const QuotesImageCellID = @"QuotesImageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HooQuotesImageCell" bundle:nil] forCellWithReuseIdentifier:QuotesImageCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.moments.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HooQuotesImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QuotesImageCellID forIndexPath:indexPath];
    HooMoment *moment = self.moments[indexPath.item];
    NSString *imageFilename = moment.photo.image_filename;
    UIImage *image;
    if (imageFilename == nil) {
        image = [UIImage imageNamed:@"gridempty"];
    }else{
        image = [UIImage imageNamed:imageFilename];
    }

    cell.quotesImage = image;
    return cell;
    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.QuotesImagedelegate respondsToSelector:@selector(selectQuotesImage:)]) {
        HooQuotesImageCell *cell = (HooQuotesImageCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [self.QuotesImagedelegate selectQuotesImage:cell.quotesImage];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



@end
