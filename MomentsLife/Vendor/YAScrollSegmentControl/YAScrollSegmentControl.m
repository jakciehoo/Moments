/*
 
 YAScrollSegmentControl.m
 
 Copyright (c) 2015 Jimmy Arts
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "YAScrollSegmentControl.h"

IB_DESIGNABLE

static const CGFloat defaultEdgeMargin = 0;


@interface YAScrollSegmentControl () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) IBInspectable UIColor *buttonColor;
@property (nonatomic, strong) IBInspectable UIColor *buttonHighlightColor;
@property (nonatomic, strong) IBInspectable UIColor *buttonSelectedColor;

@property (nonatomic, strong) IBInspectable UIImage *buttonBackgroundImage;
@property (nonatomic, strong) IBInspectable UIImage *buttonHighlightedBackgroundImage;
@property (nonatomic, strong) IBInspectable UIImage *buttonSelectedBackgroundImage;

@property (nonatomic, strong) UIFont *buttonFont;

@end

@implementation YAScrollSegmentControl

#pragma mark - initialisers

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    [self setSelectedIndex:self.selectedIndex];
    self.backgroundColor = [UIColor colorWithPatternImage:self.buttonBackgroundImage];
    
    CGFloat maxX = 0;
    for (UIButton *button in self.scrollView.subviews) {
        if (![button isKindOfClass:[UIButton class]]) continue;
        if (CGRectGetMaxX(button.frame) > maxX) {
            maxX = CGRectGetMaxX(button.frame);
        }
    }
    
    if (maxX < self.frame.size.width) {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, (self.frame.size.width - maxX) / 2, 0, 0);
    }
}

#pragma mark - general setup

- (void)setupView
{
    self.edgeMargin = defaultEdgeMargin;

    self.buttonColor = [UIColor blackColor];
    self.selectedIndex = 0;
    
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.tag = -1;
        [self addSubview:self.scrollView];
    }
}



#pragma mark - setters

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    for (UIButton *button in self.scrollView.subviews) {
        if (![button isKindOfClass:[UIButton class]]) continue;
        
        [button setBackgroundImage:image forState:state];
    }

    if (state == UIControlStateNormal) {
        self.buttonBackgroundImage = image;
        self.backgroundColor = [UIColor colorWithPatternImage:image];
    } else if (state == UIControlStateHighlighted) {
        self.buttonHighlightedBackgroundImage = image;
    } else if (state == UIControlStateSelected) {
        self.buttonSelectedBackgroundImage = image;
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    for (UIButton *button in self.scrollView.subviews) {
        if (![button isKindOfClass:[UIButton class]]) continue;
        
        [button setTitleColor:color forState:state];
    }
    
    if (state == UIControlStateNormal) {
        self.buttonColor = color;
    } else if (state == UIControlStateHighlighted) {
        self.buttonHighlightColor = color;
    } else if (state == UIControlStateSelected) {
        self.buttonSelectedColor = color;
    }
}

- (void)setFont:(UIFont *)font
{
    for (UIButton *button in self.scrollView.subviews) {
        if (![button isKindOfClass:[UIButton class]]) continue;
        
        button.titleLabel.font = font;
    }
    
    self.buttonFont = font;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if ([self.scrollView viewWithTag:selectedIndex] && [[self.scrollView viewWithTag:selectedIndex] isKindOfClass:[UIButton class]]) {
        
        
        UIButton *activeButton = (UIButton *)[self.scrollView viewWithTag:selectedIndex];
        [self buttonSelect:activeButton];
    }
}

- (void)setButtonTitles:(NSArray *)buttonTitles
{
    _buttonTitles = buttonTitles;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat x = 0;
    for (NSInteger i = 0; i < self.buttonTitles.count; i++) {
        NSString *title = self.buttonTitles[i];
        UIButton *button = [[UIButton alloc] init];
        if (self.buttonWidth == 0) {
             button.frame = CGRectMake(x, 0, self.frame.size.width/self.buttonTitles.count, self.frame.size.height);
        }else{
            button.frame = CGRectMake(x, 0, self.buttonWidth, self.frame.size.height);
        }
        
        if (self.buttonImages) {

            [button setImage:self.buttonImages[i] forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            button.imageView.layer.cornerRadius = 2.0;

        }
        
        button.tag = i;
        [button setTitleColor:self.buttonColor forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.buttonFont) {
            button.titleLabel.font = self.buttonFont;
        }
        
        if (self.buttonHighlightColor) {
            [button setTitleColor:self.buttonHighlightColor forState:UIControlStateHighlighted];
        }
        
        if (self.buttonSelectedColor) {
            [button setTitleColor:self.buttonSelectedColor forState:UIControlStateSelected];
        }
        
        if (self.buttonBackgroundImage) {
            [button setBackgroundImage:self.buttonBackgroundImage forState:UIControlStateNormal];
        }
        if (self.buttonSelectedBackgroundImage) {
            [button setBackgroundImage:self.buttonSelectedBackgroundImage forState:UIControlStateSelected];
        }
        if (self.buttonHighlightedBackgroundImage) {
            [button setBackgroundImage:self.buttonHighlightedBackgroundImage forState:UIControlStateHighlighted];
        }
        
        button.frame = (CGRect){button.frame.origin, {button.frame.size.width + (self.edgeMargin * 2), self.frame.size.height}};
        x = CGRectGetMaxX(button.frame);
        
        [self.scrollView addSubview:button];
    }
    
    self.scrollView.contentSize = CGSizeMake(x, self.frame.size.height);
    
    if (x <= self.frame.size.width) {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, (self.frame.size.width - x) / 2, 0, 0);
    } else {
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }
    
    [self setSelectedIndex:self.selectedIndex];
}

#pragma mark - action handler

- (void)buttonSelect:(UIButton *)sender
{
    if (sender.tag == self.selectedIndex && sender.selected) return;
    
    for (UIButton *button in self.scrollView.subviews) {
        if (![button isKindOfClass:[UIButton class]]) continue;
        button.selected = NO;
        button.layer.borderWidth = 0.0;
        button.backgroundColor = [UIColor clearColor];
    }
    
    sender.selected = YES;
    sender.layer.borderColor = [UIColor whiteColor].CGColor;
    sender.layer.borderWidth = 1.0;
    sender.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    
    _selectedIndex = sender.tag;
    
    if ([self.delegate respondsToSelector:@selector(segmentControl:didSelectItemAtIndex:)]) {
        [self.delegate segmentControl:self didSelectItemAtIndex:sender.tag];
    }
    
    
    
    [self scrollItemVisible:sender];
}


#pragma mark - helper


- (void)scrollItemVisible:(UIButton *)item
{
    CGRect frame = item.frame;
    if (item != self.scrollView.subviews.firstObject && item != self.scrollView.subviews.lastObject) {
        CGFloat min = CGRectGetMinX(item.frame);
        CGFloat max = CGRectGetMaxX(item.frame);
        
        
        if (min < self.scrollView.contentOffset.x) {
            frame = (CGRect){{item.frame.origin.x - 25, item.frame.origin.y}, item.frame.size};
        } else if (max > self.scrollView.contentOffset.x + self.scrollView.frame.size.width) {
            frame = (CGRect){{item.frame.origin.x + 25, item.frame.origin.y}, item.frame.size};
        }
    }
    
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

@end