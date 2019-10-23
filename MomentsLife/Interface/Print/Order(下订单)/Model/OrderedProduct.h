//
//  HooOrderedProduct.h
//  MomentsLife
//
//  Created by HooJackie on 15/10/6.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <BmobSDK/BmobObject.h>

@interface OrderedProduct : BmobObject
/**
 *  产品名称
 */
@property (nonatomic, copy)NSString *product_name;
/**
 *  品质
 */
@property (nonatomic, copy)NSString *model_name;
/**
 *  属组
 */
@property (nonatomic, copy)NSString *group_name;
/**
 *  颜色
 */
@property (nonatomic, copy)NSString *color_name;
/**
 *  尺寸
 */
@property (nonatomic, copy)NSString *size_value;
/**
 *  产品价格
 */
@property (nonatomic, copy)NSString *product_price;
/**
 *  产品库存数量
 */
@property (nonatomic, assign)NSInteger product_inventory_count;
///**
// *  DIY设计原图地址
// */
@property (nonatomic, copy)NSString *origin_image_url;
///**
// *  DIY产品效果图地址
// */
@property (nonatomic, copy)NSString *designed_image_url;
///**
// *  DIY产品效果图地址缩略图
// */
@property (nonatomic, copy)NSString *designed_thumbImage_filename;
///**
// *  DIY设计原图
// */
//@property (nonatomic, strong)UIImage *origin_image;
///**
// *  DIY产品效果图
// */
//@property (nonatomic, strong)UIImage *designed_image;

@end
