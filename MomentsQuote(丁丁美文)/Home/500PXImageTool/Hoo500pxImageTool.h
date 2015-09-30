//
//  Hoo500pxImageTool.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/11.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
@interface Hoo500pxImageTool : NSObject

+(void)downloadImageProgress:(void(^)(NSInteger receivedSize, NSInteger expectedSize))progress completed:(void(^)(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL))completed;
@end
