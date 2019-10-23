//
//  UITextFieldPadding.h
//  mbank
//
//  Created by Ted on 13-11-18.
//
//

#import <UIKit/UIKit.h>

@interface UITextFieldPadding : UITextField{
    BOOL isEnablePadding;
    float paddingLeft;
    float paddingRight;
    float paddingTop;
    float paddingBottom;
}

- (void)setPadding:(BOOL)enable top:(float)top right:(float)right bottom:(float)bottom left:(float)left;

@end
