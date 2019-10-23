//
//  HooDeliveryCell.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/9.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDelivery;
@class Order;
@interface HooDeliveryCell : UITableViewCell

@property (nonatomic, strong)OrderDelivery *delivery;

@property (nonatomic, strong)Order *order;

@end
