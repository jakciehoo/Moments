//
//  HooTabBar.m
//  HooWeibo
//
//  Created by HooJackie on 15/7/25.
//  Copyright (c) 2015年 jackie. All rights reserved.
//

#import "HooTabBar.h"
#import "UIView+Extension.h"
#import "HooTabBarButton.h"
#import "HooFlowerButton.h"


@interface HooTabBar ()


@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak)   UIButton       *selectedButton;


@end

@implementation HooTabBar
#pragma mark - 懒加载 
//初始化buttons
- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
//添加中心按钮
- (HooFlowerButton *)centerButton
{

    if (_centerButton == nil) {
        HooFlowerButton *centerButton = [[HooFlowerButton alloc] initFlowerButtonWithView:self showInView:self];
        [self addSubview:centerButton];
        _centerButton = centerButton;
        [centerButton autoCenterInSuperview];
        [centerButton autoSetDimensionsToSize:CGSizeMake(90, 90)];
        centerButton.layer.cornerRadius = 45;
        centerButton.layer.borderColor = [UIColor whiteColor].CGColor;
        centerButton.layer.borderWidth = 2.0;
        centerButton.titleLabel.font = [UIFont systemFontOfSize:30];
        centerButton.showsTouchWhenHighlighted = YES;
        centerButton.backgroundColor = HooColor(211, 211, 211);
        //显示月
        UILabel *monthLabel = [[UILabel alloc] init];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.textColor = [UIColor whiteColor];
        monthLabel.font = [UIFont systemFontOfSize:12];
        [centerButton addSubview:monthLabel];
        [monthLabel autoSetDimension:ALDimensionHeight toSize:15];
        [monthLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 0, 0, 0) excludingEdge:ALEdgeBottom];
        //显示当天
        UILabel *dayLabel = [[UILabel alloc] init];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.textColor = [UIColor whiteColor];
        dayLabel.font = [UIFont systemFontOfSize:30];
        [centerButton addSubview:dayLabel];
        [dayLabel autoSetDimension:ALDimensionHeight toSize:30];
        [dayLabel autoCenterInSuperview];
        
        NSString *monthStr = [self getMonthOfDateAndConvertToString:[NSDate date]];
        NSString *dayStr = [self getDayOfDateAndConvertToString:[NSDate date]];
        monthLabel.text = monthStr;
        dayLabel.text = dayStr;
    }
    return _centerButton;
}
//获取当前月份
- (NSString *)getMonthOfDateAndConvertToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M月"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
//获取当天日期
- (NSString *)getDayOfDateAndConvertToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_white"]];
        self.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        [self addObserver:self
                      forKeyPath:@"centerButton.selected"
                         options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                         context:nil];

    }
    return self;
    
}

// 观察者，观察选中按钮是否发生改变

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if([keyPath isEqualToString:@"centerButton.selected"]) {
        
        if (self.centerButton.selected) {
            self.selectedButton.selected = NO;
            self.selectedButton = self.centerButton;
            if ([_delegate respondsToSelector:@selector(tabBar:didClickButton:)]) {
                [_delegate tabBar:self didClickButton:self.centerButton.tag];
            }
        }else{
            //选中其他item时候移除按钮和遮盖
            [self.centerButton removeItemsAndBlackView];
        }
    }
}


#pragma mark - 重写items的set方法，并添加5个按钮
- (void)setItems:(NSArray *)items
{
    _items = items;
    //添加按钮
    for (int i = 0; i < self.items.count; i++) {
        HooTabBarButton *btn = [HooTabBarButton buttonWithType:UIButtonTypeCustom];
        btn.item = self.items[i];
        if (i != 2) {
            btn.tag = i;
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];

        [self addSubview:btn];
        
        [self.buttons addObject:btn];
        //中间按钮初始化
        if (i == 2) {
            btn.item.enabled = NO;
            btn.enabled = NO;
            //懒加载添加中心按钮并设置标签
            self.centerButton.tag = 2;
            [self btnClick:self.centerButton];

        }
    }
}

//单击按钮事件
- (void)btnClick:(UIButton *)button
{
    
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
    if ([button isKindOfClass:[HooTabBarButton class]]) {
        HooTabBarButton *tabBarButton = (HooTabBarButton *)button;
        self.selectedItem = tabBarButton.item;
    }
    
    if ([_delegate respondsToSelector:@selector(tabBar:didClickButton:)]) {
        [_delegate tabBar:self didClickButton:button.tag];
    }

}
#pragma mark - 视图即将被添加到父视图中调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    //设置中心按钮的容器
    self.centerButton.containerView = newSuperview;
}



#pragma mark - 布局按钮
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat tabBarW = self.width;
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    CGFloat itemW = (tabBarW-self.centerButton.width - 12)/(self.buttons.count-1);
    //CGFloat itemW = (tabBarW)/(self.buttons.count);
    CGFloat itemH = self.height;
    for (NSUInteger i = 0; i < self.buttons.count; i++) {
        
        UIButton *view = self.buttons[i];
        if (i<2) {
            
            itemX = itemW * i;
            view.frame = CGRectMake(itemX, itemY, itemW, itemH);
        }
        if (i==2) {
        }
        
        if (i>2) {
            NSUInteger j = self.buttons.count - i;
            itemX = itemW * j;
            view.frame = CGRectMake(self.width - itemX, itemY, itemW, itemH);
            
        }
    }
}


#pragma mark - 释放观察者
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"centerButton.selected"];
    
}






@end
