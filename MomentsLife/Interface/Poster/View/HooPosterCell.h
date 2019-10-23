//
//  HooPosterCell.h
//  MomentsLife
//
//  Created by HooJackie on 15/8/13.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HooMoment;
@class OrderedProduct;

@interface HooPosterCell : UITableViewCell

@property (nonatomic,strong) HooMoment *myMoment;

@property (nonatomic,strong) OrderedProduct *orderedProduct;



@end
