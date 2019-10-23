//
//  HooQuotesViewController.h
//  MomentsLife
//
//  Created by HooJackie on 15/8/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  HooQuotesViewControllerDelegate<NSObject>
/**
 *  选中item中的文字时代理方法
 *
 *  @param quote  选中的文字正文
 *  @param author 选中的文字作者
 */
- (void)quoteDidSelected:(NSString *)quote author:(NSString *)author;

@end

@interface HooQuotesViewController : UICollectionViewController

@property (nonatomic, strong) NSMutableArray *moments;

@property (nonatomic, strong)NSString *from;

@property (nonatomic, assign,getter=isShowQuote)BOOL showQuote;

@property (nonatomic, weak)id<HooQuotesViewControllerDelegate> delegate;

@end
