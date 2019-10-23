//
//  HooOrderToolView.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HooOrderToolViewDelegate <NSObject>

- (void)payButtonClicked:(UIButton *)payButton WithTotalPrice:(NSString *)total_price WithOrderCount:(NSInteger)order_count;

@end


@interface HooOrderToolView : UIView

@property (nonatomic, weak) id<HooOrderToolViewDelegate> delegate;

@property (nonatomic, copy)NSString *product_price;

@property (nonatomic, copy)NSString *delivery_price;

@property (nonatomic, assign)NSInteger inventory_count;

+ (instancetype)orderToolView;

@end
