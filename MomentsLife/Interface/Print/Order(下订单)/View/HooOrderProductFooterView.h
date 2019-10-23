//
//  HooOderHeaderView.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderedProduct;

@interface HooOrderProductFooterView : UIView

@property (nonatomic,strong)OrderedProduct *orderedProduct;

@property (nonatomic, strong)UIImage *orderedProduct_thumbImage;

+ (instancetype)orderProductFooterView;

@end
