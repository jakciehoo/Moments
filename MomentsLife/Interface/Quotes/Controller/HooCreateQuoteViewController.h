//
//  HooCreateQuoteViewController.h
//  MomentsLife
//
//  Created by HooJackie on 15/9/14.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HooMoment;

@protocol HooCreateQuoteViewControllerDelegate <NSObject>

- (void)deleteMomentCellClicked;

@end
@interface HooCreateQuoteViewController : UITableViewController

@property (nonatomic, strong)HooMoment *editMoment;

@property (nonatomic, assign)BOOL fromMine;

@property (nonatomic, weak) id<HooCreateQuoteViewControllerDelegate> delegate;

@end
