//
//  HooHeaderView.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/7.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooHeaderView.h"
#import "HooEditToolView.h"
#import "HooQuoteView.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import "UIColor+Extension.h"
#import "UIImage+Utility.h"
#import "UIView+AutoLayout.h"
@interface HooHeaderView ()<HooEditToolViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic)  HooEditToolView *editTool;

@property (weak, nonatomic)  HooQuoteView *quoteView;

@end

@implementation HooHeaderView

- (void)setMoment:(HooMoment *)moment
{
    _moment = moment;
    self.quoteView.moment = moment;
}
- (void)setHeaderImage:(UIImage *)headerImage
{
    _headerImage = headerImage;
    self.imageView.image = headerImage;
    if (self.moment.photo.image_filtername) {
        [self choosedFilter:self.moment.photo.image_filtername];
    }
    

    self.quoteView.quoteBgColor = [headerImage mostColorFromImage];
    self.editTool.filterImage = headerImage;
}

- (void)setShowQuote:(BOOL)showQuote
{
    _showQuote = showQuote;
    self.quoteView.showQuote = showQuote;
}


+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:@"HooHeaderView" owner:nil options:nil][0];
}
- (void)awakeFromNib
{
    //监听imageview的image属性变化
    [self addObserver:self
           forKeyPath:@"imageView.image"
              options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
              context:nil];
    
    //添加编辑视图
    HooEditToolView *editTool = [[HooEditToolView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    
    _editTool = editTool;
    editTool.delegate = self;
    [self.containerView addSubview:editTool];
    [editTool autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [editTool autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.imageView];
    
    //添加文字视图
    HooQuoteView *quoteView = [HooQuoteView quoteView];
    quoteView.showAuthor = NO;
    //quoteView.width = 200;
    _quoteView = quoteView;
    [self.imageView addSubview:quoteView];
    

    
}

//观察者调用方法
//这里我们观察iamgeview.image属性值改变来设置中心按钮的背景颜色
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"imageView.image"]) {
        [self setBackgroudColorForViews];
    }
    
}
//获取图片中的主色调，并设置给中心按钮
- (void)setBackgroudColorForViews
{
    
    self.quoteView.quoteBgColor = [self.imageView.image mostColorFromImage];
}

#pragma mark - HooEditToolViewDelegate
- (void)choosedColor:(UIColor *)color
{
    self.quoteView.quoteColor = color;
    
    NSArray *components = [color getRGBComponents];
    self.moment.fontColorR = [components[0] floatValue];
    self.moment.fontColorG = [components[1] floatValue];
    self.moment.fontColorB = [components[2] floatValue];

}


- (void)choosedFont:(NSString *)fontName
{
    self.quoteView.quoteFontName = fontName;
    self.moment.fontName = fontName;
}
- (void)choosedFilter:(NSString *)filterName
{
    if (self.headerImage == nil) return;
    if ([filterName isEqualToString:@"Default"]) {
        self.imageView.image = self.headerImage;
        return;
    }

    //给图片添加滤镜
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *filteredImage = [self.headerImage filterImagewithFilterName:filterName];
        if (filteredImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.imageView.image = filteredImage;
                self.moment.photo.image_filtername = filterName;
            });
        }
    });
    
}

- (void)toolButtonClicked
{
    
}
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"imageView.image"];

}

@end
