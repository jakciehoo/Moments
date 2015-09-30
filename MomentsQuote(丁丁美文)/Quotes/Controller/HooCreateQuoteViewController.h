//
//  HooCreateQuoteViewController.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/14.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HooMoment;
@interface HooCreateQuoteViewController : UITableViewController

@property (nonatomic, strong)HooMoment *editMoment;

@property (nonatomic, assign)BOOL fromMine;

@end
