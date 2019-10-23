//
//  HooPhoto.m
//  MomentsLife
//
//  Created by HooJackie on 15/9/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import "HooPhoto.h"
#import "MJExtension.h"

@interface HooPhoto ()<MJKeyValue>


@end

@implementation HooPhoto

+ (NSArray *)ignoredPropertyNames
{
    return @[@"isFavorite",@"image_filtername"];
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"style":@"caption_style",
             @"positionX":@"position_portrait",
             @"positionY":@"position_landscape",
             @"image_filename":@"filename_bundle",
             @"image_thumb_filename":@"filename_bundle_thumb"
             };
}
@end
