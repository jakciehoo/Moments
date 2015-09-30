//
//  HooInsetsLabel.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/26.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooLabel.h"
#import <CoreText/CoreText.h>

@implementation HooLabel

-(instancetype) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(instancetype) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}
//重写此方法，该方法用于绘制文字显示的范围
//我们这里通过改变参数为有边距矩阵大小实现目的
-(void) drawTextInRect:(CGRect)rect {
    
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
    
}
//重text的Set方法，让字体的高度自适应文本内容
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self sizeToFit];
   
}
//重font的Set方法，让字体的高度自适应字体变化
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self sizeToFit];
}

- (void)sizeToFit
{
    [super sizeToFit];
    
    CGSize size = CGSizeMake(200, CGFLOAT_MAX);
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,nil];
    
    CGSize actualSize = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    self.size = actualSize;
}



@end
