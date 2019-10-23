//
//  HooTextViewCell.m
//  MomentsLife
//
//  Created by HooJackie on 15/8/14.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooTextViewCell.h"
#import "HooTextView.h"

@interface HooTextViewCell ()


@end

@implementation HooTextViewCell

- (void)setText:(NSString *)text
{
    _text = text;
    self.textView.text = text;
}

- (void)awakeFromNib {
    // Initialization code
    self.textView.placeholder = @"在这里输入文字...";
}


@end
