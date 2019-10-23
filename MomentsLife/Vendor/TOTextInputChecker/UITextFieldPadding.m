//
//  UITextFieldPadding.m
//  mbank
//
//  Created by Ted on 13-11-18.
//
//

#import "UITextFieldPadding.h"

@implementation UITextFieldPadding

- (void)setPadding:(BOOL)enable top:(float)top right:(float)right bottom:(float)bottom left:(float)left {
    isEnablePadding = enable;
    paddingTop = top;
    paddingRight = right;
    paddingBottom = bottom;
    paddingLeft = left;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if (isEnablePadding) {
        return CGRectMake(bounds.origin.x + paddingLeft,
                          bounds.origin.y + paddingTop,
                          bounds.size.width - paddingRight, bounds.size.height - paddingBottom);
    } else {
        return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

-(void)setBackground:(UIImage *)background{
    
    [super setBackground:[background stretchableImageWithLeftCapWidth:background.size.width/2 topCapHeight:background.size.height/2]];
}

-(void)setDisabledBackground:(UIImage *)background{
    
    [super setDisabledBackground:[background stretchableImageWithLeftCapWidth:background.size.width/2 topCapHeight:background.size.height/2]];
}

@end
