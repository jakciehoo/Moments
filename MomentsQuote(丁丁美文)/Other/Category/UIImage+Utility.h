//
//  UIImage+Utility.h
//
//  Created by sho yakushiji on 2013/05/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

+ (UIImage*)fastImageWithData:(NSData*)data;
+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path;

- (UIImage*)deepCopy;

- (UIImage*)grayScaleImage;

- (UIImage*)resize:(CGSize)size;
- (UIImage*)aspectFit:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset;
/**
 *  截取一定区域大小的图片
 *
 *  @param rect 截取的范围
 *
 *  @return 返回截取后的图片
 */
- (UIImage*)crop:(CGRect)rect;
/**
 *  截取图片中的一个区域大小的图片
 *
 *  @param image 需要截取的原图片
 *  @param rect  截取的范围
 *
 *  @return 返回截取后的图片
 */
+ (UIImage*)crop:(UIImage *)image InRect:(CGRect)rect;

- (UIImage*)maskedImage:(UIImage*)maskImage;

- (UIImage*)gaussBlur:(CGFloat)blurLevel;       //  {blurLevel | 0 ≤ t ≤ 1}
/**
 *  从图片中获取主色调
 *
 *  @return 返回图片的主要颜色
 */
- (UIColor *)mostColorFromImage;
/**
 *  根据滤镜名称给图片添加滤镜
 *
 *  @param filterName 滤镜名称
 *
 *  @return 返回添加滤镜后的图片
 */
- (instancetype)filterImagewithFilterName:(NSString *)filterName;
/**
 *  随机从照片库中获取照片
 *
 *  @return 返回照片
 */
+ (instancetype)getRandomImageFromPhotoLibrary:(void(^)(NSString * failAuthorizationInfo))failToAuthorization;

/**
 *  将照片写到app的Document目录
 *
 *  @param image          照片对象
 *  @param photoName      照片名称
 *  @param photoThumbName 照片缩略图名称
  *  @return 保存图片成功返回YES，否则返回NO
 */
- (BOOL)writeImageToDocumentDirectoryWithPhotoName:(NSString *)photoName;
/**
 *  删除照片
 *
 *  @param photoName 照片名
 *  @return 删除成功返回YES，否则返回NO
 */
+ (BOOL)removeImageWithImageName:(NSString *)photoName;
/**
 *  根据照片名称从用户Document获取照片
 *
 *  @param photoName 照片名
 *
 *  @return 照片
 */
+(instancetype)imageForPhotoName:(NSString *)photoName;
/**
 *  将视图快照为照片
 *
 *  @param view 截图目标视图
 * @param rect 截图的区域
 *
 *  @return 返回照片
 */
+(instancetype)imageDrawInView:(UIView *)view Inrect:(CGRect)rect;
/**
 *  根据图片裁剪视图
 *
 *  @param image     image是被剪裁的图片
 *  @param maskImage maskImage是需要剪裁的形状
 *
 *  @return 返回裁剪后的图片
 */
+ (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

/**
 *  修复选择图片后颠倒的bug
 *
 *  @return 返回修复后的效果
 */
- (UIImage *)fixOrientation;
/**
 *  颜色转图片
 *
 *  @param color 颜色
 *  @param rect  图片大小
 *
 *  @return 返回新图片
 */
+(instancetype)imageWithColor:(UIColor*) color withRect:(CGRect)rect;
@end
