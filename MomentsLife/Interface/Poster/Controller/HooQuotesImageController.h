//
//  HooQuotesImageController.h
//  MomentsLife
//
//  Created by HooJackie on 15/9/10.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooQuotesViewController.h"

@class HooMoment;

@protocol HooQuotesImageControllerDelegate <NSObject>

- (void)selectMoment:(HooMoment *)moment;

@end

@interface HooQuotesImageController : HooQuotesViewController

@property (nonatomic, weak)id<HooQuotesImageControllerDelegate> QuotesImageDelegate;
@end
