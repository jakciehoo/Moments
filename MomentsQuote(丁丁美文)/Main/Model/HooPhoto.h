//
//  HooPhoto.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/9/3.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HooPhoto : NSObject

/**
 * 文字在图片中呈现的样式(bar/quote有条状背景颜色或者无背景色而是有个引用提示)
 */
@property (nonatomic, copy) NSString *style;

/**
 *  字体在图片view中的位置的X值
 */
@property (nonatomic, assign) CGFloat positionX;
/**
 * 字体在图片view中的位置的Y值
 */
@property (nonatomic, assign) CGFloat positionY;
/**
 *  图片名称
 */
@property (nonatomic, copy) NSString *image_filename;
/**
 *  图片缩略图的名称
 */
@property (nonatomic, copy) NSString *image_thumb_filename;
/**
 *  滤镜名称
 */
@property (nonatomic, copy) NSString *image_filtername;
/**
 *  美图美文是否被收藏
 */
@property (nonatomic, assign) BOOL  isFavorite;

@end
