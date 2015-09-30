//
//  HooQualitModel.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/28.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface HooProductModel : NSObject<MJKeyValue>

@property (nonatomic, copy)NSString *model_id;

@property (nonatomic, copy)NSString *model_name;

@property (nonatomic, strong)NSArray *groups;

@end
