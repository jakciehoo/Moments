//
//  HooQuotesCell.h
//  MomentsLife
//
//  Created by HooJackie on 15/8/25.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HooMoment;

@interface HooQuotesCell : UICollectionViewCell
/**
 *  HooMoment类型模型
 */
@property (nonatomic, strong) HooMoment *moment;

@property (nonatomic, assign,getter=isShowQuote) BOOL showQuote;

@end
