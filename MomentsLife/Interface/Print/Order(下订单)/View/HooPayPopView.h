//
//  HooPayPopView.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/8.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PayTypeAliPay,
    PayTypeWeChat,
    PayTypeUnionPay,
} HooPayType;

@protocol HooPayPopViewPayDelegate <NSObject>

- (void)payWithPayType:(HooPayType)payType;

@end


@interface HooPayPopView : UIView

@property (nonatomic,readonly)HooPayType payType;

@property (strong, nonatomic)NSArray *payArray;

@property (nonatomic,weak)id<HooPayPopViewPayDelegate> delegate;


+ (instancetype)payPopView;


@end
