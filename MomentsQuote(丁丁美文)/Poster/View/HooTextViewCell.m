//
//  HooTextViewCell.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/14.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooTextViewCell.h"

@implementation HooTextViewCell

- (void)awakeFromNib {
    // Initialization code
    self.textView.placeholder = @"在这里输入文字...";

}



- (void)textViewDidChange:(UITextView *)textView
{
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size.height = newSize.height;
    textView.bounds = bounds;
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
}
- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

@end
