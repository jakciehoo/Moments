//
//  HooTextView.m
//  HooWeibo
//
//  Created by HooJackie on 15/7/31.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooTextView.h"

@interface HooTextView ()

@property (nonatomic, weak) UILabel *placeHolderLabel;

@end

@implementation HooTextView
#pragma mark -  懒加载
- (UILabel *)placeHolderLabel
{
    if (_placeHolderLabel == nil) {
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel = placeHolderLabel;
        [self addSubview:placeHolderLabel];
    }
    return _placeHolderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.font = [UIFont systemFontOfSize:15];
        
    }
    return self;
}
#pragma mark - 重写设置文字方法
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeHolderLabel.text = placeholder;
    [self.placeHolderLabel sizeToFit];
    //UITextViewTextDidChangeNotification通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
}
//通知时调用方法
- (void)textChange
{
    if (self.text.length) {
        self.placeHolderLabel.hidden = YES;
    }else{
        self.placeHolderLabel.hidden = NO;
        
    }
}


//设置字体
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeHolderLabel.font = font;
    [self.placeHolderLabel sizeToFit];
}


//布局
- (void)layoutSubviews
{
    self.placeHolderLabel.x = 5;
    self.placeHolderLabel.y = 8;

}
//销毁是移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}






@end
