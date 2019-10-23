//
//  HooOrderInfoToolView.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/9.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooOrderInfoToolView.h"

@interface HooOrderInfoToolView ()

@property (weak, nonatomic) IBOutlet UIButton *orderInfoButton;

@end

@implementation HooOrderInfoToolView


- (void)setButtontTitle:(NSString *)buttontTitle
{
    _buttontTitle = buttontTitle;
    [self.orderInfoButton setTitle:buttontTitle forState:UIControlStateNormal];
}

+ (instancetype)orderInfoToolView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HooOrderInfoToolView" owner:nil options:nil] firstObject];
    
}



//在视图顶部添加一个两个像素高度的浅红色线条
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    //获得处理的上下文
    
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    
    //指定直线样式
    
    CGContextSetLineCap(context,
                        kCGLineCapSquare);
    
    //直线宽度
    
    CGContextSetLineWidth(context,
                          2.0);
    
    //设置颜色
    //234,81,96
    CGContextSetRGBStrokeColor(context,
                               234/255.0, 81/255.0, 96/255.0, 1.0);
    
    //开始绘制
    
    CGContextBeginPath(context);
    
    //画笔移动到点(31,170)
    
    CGContextMoveToPoint(context,
                         0, 0);
    
    //下一点
    
    CGContextAddLineToPoint(context,
                            self.width, 0);
    
    //下一点
    
    //    CGContextAddLineToPoint(context,
    //                            self.width, 0);
    
    //绘制完成
    
    CGContextStrokePath(context);
    
}


@end
