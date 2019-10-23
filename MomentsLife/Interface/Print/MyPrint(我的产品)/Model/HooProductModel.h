//
//  HooQualitModel.h
//  MomentsLife
//
//  Created by HooJackie on 15/9/28.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface HooProductModel : NSObject<MJKeyValue>

@property (nonatomic, copy)NSString *model_id;

@property (nonatomic, copy)NSString *model_name;

@property (nonatomic, strong)NSURL *model_infoURL;

@property (nonatomic, copy)NSString *model_price;

@property (nonatomic, strong)NSArray *groups;

@end
