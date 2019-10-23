//
//  HooProductColor.h
//  MomentsLife
//
//  Created by HooJackie on 15/9/28.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface HooProductColor : NSObject<MJKeyValue>
/**
 *  颜色编号
 */
@property (nonatomic, copy)NSString *color_id;
/**
 *  颜色名称
 */
@property (nonatomic, copy)NSString *color_name;
/**
 *  颜色值
 */
@property (nonatomic, copy)NSString *color_hexa;
/**
 *  产品图片地址
 */
@property (nonatomic, strong)NSURL *product_imageURL;
/**
 *  产品库存数量
 */
@property (nonatomic, assign)NSInteger product_inventory_count;
/**
 *  可DIY图案区域大小
 */
@property (nonatomic, copy)NSString *patern_size;
/**
 *  图案或产品与屏幕显示效果图的比例
 */
@property (nonatomic, assign)CGFloat size_ratio;
/**
 *  尺寸数组
 */
@property (nonatomic, strong)NSArray *sizes;


@end
