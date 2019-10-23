//
//  HooOrderDeliveryController.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/6.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDelivery;
@protocol HooOrderDeliveryControllerDelegate <NSObject>

- (void)didSelectDelivery:(OrderDelivery *)delivery;

@end

@interface HooOrderDeliveryController : UITableViewController

@property (nonatomic, weak) id<HooOrderDeliveryControllerDelegate> delegate;

@end
