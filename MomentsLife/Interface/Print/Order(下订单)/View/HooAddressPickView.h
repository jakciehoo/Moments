//
//  HooAddressPickView.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HooAddressLocation.h"

typedef enum {
    HooAddressPickerWithStateAndCity,
    HooAddressPickerWithStateAndCityAndDistrict
} HooAddressPickerStyle;

@class HooAddressPickView;
@class HooAddressLocation;

@protocol HooAddressPickViewDelegate <NSObject>

@optional
- (void)pickerDidChangeStatus:(HooAddressPickView *)picker;

@end

@interface HooAddressPickView : UIView

@property (weak, nonatomic) id <HooAddressPickViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) HooAddressLocation *locate;
@property (nonatomic,assign) HooAddressPickerStyle pickerStyle;
- (instancetype)addressPickViewtWithStyle:(HooAddressPickerStyle)pickerStyle delegate:(id<HooAddressPickViewDelegate>)delegate;

- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
