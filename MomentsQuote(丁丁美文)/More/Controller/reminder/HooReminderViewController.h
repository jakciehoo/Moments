//
//  HooReminderViewController.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/9.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HooReminderViewControllerDelegate <NSObject>

@optional
- (void)datePick:(UIDatePicker *)picker pickeDate:(NSString *)date;

@end

@interface HooReminderViewController : UIViewController

@property (nonatomic, weak) id<HooReminderViewControllerDelegate> delegate;

@end
