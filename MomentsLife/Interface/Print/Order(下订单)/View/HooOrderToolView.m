//
//  HooOrderToolView.m
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooOrderToolView.h"

@interface HooOrderToolView()

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *order_countLabel;

@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (weak, nonatomic) IBOutlet UIButton *minusCountButton;

@property (weak, nonatomic) IBOutlet UIButton *addCountButton;

@property (assign, nonatomic)NSInteger order_count;

@end

@implementation HooOrderToolView

- (void)setProduct_price:(NSString *)product_price
{
    _product_price = [product_price substringFromIndex:1];
    
    CGFloat total_price = [_product_price floatValue] * self.order_count + [_delivery_price floatValue];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",total_price];
    

}
- (void)setDelivery_price:(NSString *)delivery_price
{
    _delivery_price = [delivery_price substringFromIndex:1];
    CGFloat total_price = [_product_price floatValue] * self.order_count + [_delivery_price floatValue];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",total_price];
}

+ (instancetype)orderToolView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HooOrderToolView" owner:nil options:nil] lastObject];
    
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = HooColor(57, 63, 75);
    self.payButton.layer.cornerRadius = 5;
    self.order_countLabel.text = [NSString stringWithFormat:@"%li",(long)self.order_count];
    [self addObserver:self forKeyPath:@"order_count" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    self.order_count = 1;
    
    
}
//观察者，监控订单数量的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"order_count"]) {
        if (self.order_count == 1) {
            self.minusCountButton.enabled = NO;
        }
        if (self.order_count != 1) {
            self.minusCountButton.enabled = YES;
        }
        if (self.order_count == self.inventory_count) {
            self.addCountButton.enabled = NO;
        }
        if (self.order_count < self.inventory_count) {
            self.addCountButton.enabled = YES;
        }
        self.order_countLabel.text = [NSString stringWithFormat:@"%ld",(long)self.order_count];
        CGFloat total_price = [_product_price floatValue] * self.order_count + [_delivery_price floatValue];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",total_price];
    }
}


- (IBAction)payBtnClicked:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(payButtonClicked:WithTotalPrice:WithOrderCount:)]) {
        [self.delegate payButtonClicked:sender WithTotalPrice:self.totalPriceLabel.text WithOrderCount:self.order_count];
    }
}


- (IBAction)minusCount:(UIButton *)sender {
    self.order_count--;
}


- (IBAction)addCount:(UIButton *)sender {
    self.order_count++;
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
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"order_count"];
}


@end
