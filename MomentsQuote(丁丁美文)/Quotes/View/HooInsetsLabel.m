//
//  HooInsetsLabel.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/26.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooInsetsLabel.h"

@implementation HooInsetsLabel

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

@end
