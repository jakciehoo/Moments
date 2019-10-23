//
//  HooTextViewCell.h
//  MomentsLife
//
//  Created by HooJackie on 15/8/14.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HooTextView;
@interface HooTextViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet HooTextView *textView;
@property (copy, nonatomic) NSString *text;
@end
