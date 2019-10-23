//
//  HooSettingLabelItem.m
//  HooLottery
//
//  Created by HooJackie on 15/7/6.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooSettingLabelItem.h"
#import "HooSaveTools.h"

@implementation HooSettingLabelItem
-(void)setText:(NSString *)text
{
    if (text.length) {
        _text = text;
    }
    [HooSaveTools setObject:text forKey:self.title];
}

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    _text = [HooSaveTools objectForKey:self.title];
}

@end

