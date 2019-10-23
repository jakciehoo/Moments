//
//  HooOderedProductManager.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/7.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrderedProduct;

@interface HooOrderedProductManager : NSObject

+ (instancetype)manager;


/**
 *  通过NSData的数组上传数据
 *
 *  @param orderedProduct        HooOrderedProduct产品
 *  @param resultbBlock 返回结果的block
 *  @param progress     执行上传进度的block
 */
- (void)uploadOrderedProductWithOriginImageData:(NSData *)origin_imageData andDesignedImageData:(NSData *)designed_imageData WithOrderedProduct:(OrderedProduct *)orderedProduct WithResultBlock:(void(^)(BOOL isSuccessful, NSError *error))resultBlock andProgress:(void(^)(NSUInteger index, CGFloat progress))progress;
/**
 *  下载图片
 *
 *  @param filename 图片名称
 *  @param block    回调
 *  @param progress 进度显示
 */
- (void)downloadImageWithFilename:(NSString *)filename Withblock:(void(^)(BOOL isSuccessful, NSError *error, NSString *filepath))block andProgress:(void(^)(CGFloat progress))progress;

@end
