//
//  HooQuotesImageController.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/10.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooQuotesViewController.h"

@protocol HooQuotesImageControllerDelegate <NSObject>

- (void)selectQuotesImage:(UIImage *)image;

@end

@interface HooQuotesImageController : HooQuotesViewController

@property (nonatomic, weak)id<HooQuotesImageControllerDelegate> QuotesImagedelegate;
@end
