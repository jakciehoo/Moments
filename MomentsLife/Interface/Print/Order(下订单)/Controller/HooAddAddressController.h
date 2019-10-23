//
//  HooAddAddressController.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderAddress;
@interface HooAddAddressController : UIViewController

@property (nonatomic, strong)OrderAddress *address;

@property (nonatomic, assign,getter=isEdittingAddress)BOOL edittingAddress;

@property (nonatomic, assign,getter=isFromOrder)BOOL fromOrder;


@end
