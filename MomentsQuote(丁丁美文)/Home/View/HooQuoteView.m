//
//  HooQuoteView.m
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/15.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooQuoteView.h"
#import "HooLabel.h"
#import "HooMoment.h"
#import "HooPhoto.h"
#import <CoreText/CoreText.h>

@interface HooQuoteView ()<UIGestureRecognizerDelegate>{

 CTFrameRef _ctFrame;
}
@property (weak, nonatomic) IBOutlet HooLabel *quoteTextLabel;
@property (weak, nonatomic) IBOutlet HooLabel *quoteAuthorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *quoteImageView;
/**
 *  美文字体大小
 */
@property (assign, nonatomic) NSInteger quoteSize;
/**
 *  美文正文
 */
@property (copy, nonatomic) NSString *quoteText;
/**
 *  美文作者
 */
@property (copy, nonatomic) NSString *quoteAuthor;



/**
 *  是否显示背景色
 */
@property (nonatomic, assign, getter = isShowBg) BOOL showBg;

@end

@implementation HooQuoteView



#pragma mark - getter 和 setter方法

- (void)setMoment:(HooMoment *)moment
{
    _moment = moment;
    
    self.quoteText = self.moment.quote;

    self.quoteAuthor= self.moment.author;
        self.quoteColor = [UIColor colorWithRed:self.moment.fontColorR green:self.moment.fontColorG  blue:self.moment.fontColorB  alpha:1.0];
    self.quoteFontName = self.moment.fontName;
    self.origin = CGPointMake(self.moment.photo.positionX, self.moment.photo.positionY);
    
    self.showBg = [self.moment.photo.style isEqualToString:@"BLACK_BARS"];
}



- (void)setQuoteAuthor:(NSString *)quoteAuthor
{
    _quoteAuthor = quoteAuthor;
    self.quoteAuthorLabel.text = quoteAuthor;

}

- (void)setQuoteText:(NSString *)quoteText
{
    _quoteText = quoteText;
    self.quoteTextLabel.text = quoteText;

}
- (void)setShowBg:(BOOL)showBg
{
    _showBg = showBg;
    [self showOrHideQuoteBackgroudColor];
}

- (void)setQuoteColor:(UIColor *)quoteColor
{
    _quoteColor = quoteColor;
    self.quoteAuthorLabel.textColor = quoteColor;
    self.quoteTextLabel.textColor = quoteColor;
    self.quoteTextLabel.highlightedTextColor = [UIColor redColor];
}

- (void)setQuoteFontName:(NSString *)quoteFontName
{
    _quoteFontName = quoteFontName;
    self.quoteTextLabel.font = [UIFont fontWithName:quoteFontName size:17.0];
    self.quoteAuthorLabel.font = [UIFont fontWithName:quoteFontName size:12.0];

}
- (void)setShowQuote:(BOOL)showQuote
{
    _showQuote = showQuote;
    self.quoteAuthorLabel.alpha = showQuote ? 1.0 : 0.0;
    self.quoteTextLabel.alpha = showQuote ? 1.0 : 0.0;
}
- (void)setQuoteBgColor:(UIColor *)quoteBgColor
{
    _quoteBgColor = quoteBgColor;
    [self showOrHideQuoteBackgroudColor];

}
- (void)showOrHideQuoteBackgroudColor
{
    //给文字添加背景色
    if (self.showBg) {
        self.quoteImageView.hidden = YES;
        if (self.quoteBgColor) {
            
            NSDictionary *attr = @{NSBackgroundColorAttributeName :self.quoteBgColor};
            if (self.quoteTextLabel.text.length > 0) {
                self.quoteTextLabel.attributedText = [[NSAttributedString alloc] initWithString:self.quoteTextLabel.text attributes:attr];
            }
            if (self.quoteAuthorLabel.text.length > 0) {
                self.quoteAuthorLabel.attributedText = [[NSAttributedString alloc] initWithString:self.quoteAuthorLabel.text attributes:attr];
            }
        }
    }else{
        if (self.quoteTextLabel.text.length > 0) {
            self.quoteTextLabel.attributedText = [[NSAttributedString alloc] initWithString:self.quoteTextLabel.text];
        }
        if (self.quoteAuthorLabel.text.length > 0) {
            self.quoteAuthorLabel.attributedText = [[NSAttributedString alloc] initWithString:self.quoteAuthorLabel.text];
        }
        self.quoteImageView.hidden = NO;
    }

}



+ (instancetype)quoteView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HooQuoteView" owner:nil options:nil] lastObject];
    
}

- (void)awakeFromNib
{
    
    //不需要autoResizing,否则自动缩放
    self.autoresizingMask = UIViewAutoresizingNone;
    //添加了四中手势,tap,pan,rotation,pinch
    [self addGestureRecognizersToPiece:self];

    
}




#pragma mark -添加手势
- (void)addGestureRecognizersToPiece:(UIView *)piece
{
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    rotationGesture.delegate = self;
    [piece addGestureRecognizer:rotationGesture];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    panGesture.delegate = self;
    [piece addGestureRecognizer:panGesture];
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchPiece:)];
    pinchGesture.delegate = self;
    [piece addGestureRecognizer:pinchGesture];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPiece:)];
    tapGesture.delegate = self;
    [piece addGestureRecognizer:tapGesture];
}

- (void)rotatePiece:(UIRotationGestureRecognizer *)recognizer
{
    UIView *piece = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        [self adjustAnchorPointForGestureRecognizer:recognizer];
        piece.transform = CGAffineTransformRotate(piece.transform, recognizer.rotation);
        recognizer.rotation = 0.0;
    }
    
}

- (void)panPiece:(UIPanGestureRecognizer *)recognizer
{
    UIView *piece = recognizer.view;
    [piece.superview bringSubviewToFront:piece];
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        //[self adjustAnchorPointForGestureRecognizer:recognizer];
        CGPoint translation = [recognizer translationInView:piece.superview];
        CGPoint newPoint = CGPointMake(piece.center.x + translation.x, piece.center.y + translation.y);
        CGFloat checkPointX = piece.frame.origin.x + translation.x;
        CGFloat checkPointY = piece.frame.origin.y + translation.y;
        CGRect rectToCheckBounds = CGRectMake(checkPointX, checkPointY, piece.frame.size.width, piece.frame.size.height);
        if (CGRectContainsRect(piece.superview.frame, rectToCheckBounds)) {
            piece.center = newPoint;
            [recognizer setTranslation:CGPointZero inView:piece.superview];
            //记录新的美文美图的起始位置
            self.moment.photo.positionX = checkPointX;
            self.moment.photo.positionY = checkPointY;
        }

        
    }
}
- (void)pinchPiece:(UIPinchGestureRecognizer *)recognizer
{
    UIView *piece = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        [self adjustAnchorPointForGestureRecognizer:recognizer];
        piece.transform = CGAffineTransformScale(piece.transform, recognizer.scale
                                                 , recognizer.scale);
        recognizer.scale = 1.0;
    }
}
- (void)tapPiece:(UITapGestureRecognizer *)recognizer
{
    self.showBg = !self.isShowBg;
    self.moment.photo.style = self.showBg ? @"BLACK_BARS" : @"QUOTE";


}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)recognizer
{

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = recognizer.view;
        CGPoint locationInView = [recognizer locationInView:piece];
        CGPoint locationInSuperView = [recognizer locationInView:piece.superview];
        piece.layer.anchorPoint = CGPointMake(locationInView.x/piece.width, locationInView.y/piece.height);
        piece.center = locationInSuperView;
    }
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.height = self.quoteAuthorLabel.height + self.quoteTextLabel.height + 5;
    self.quoteAuthorLabel.width = self.quoteTextLabel.width;
    self.width = self.quoteTextLabel.width;
    
}




@end
