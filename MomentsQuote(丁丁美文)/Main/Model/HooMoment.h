//
//  HooMoment.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/15.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 id(int)主键
 文字内容
 quote(text)
 文字作者
 author(text)
 文字是否有背景(ColorBar/quote背景颜色或者引用)
 quote_style(text)
 文字颜色
 fontColorR(real)
 fontColorG(real)
 fontColorB(real)
 
 文字字体
 fontSize(real)
 文字位置
 positionX(real)
 positionY(real)
 
 图片
 image_filename(text)(唯一性)
 image_thumb_filename(text)
 
 
 是否被收藏
 isFavorite(int)
 是否自己创建
 isMine(int)
 创建时间
 create_date(string)
 修改时间
 modified_date(string)（唯一性，排序）
 */

@class HooPhoto;

@interface HooMoment : NSObject
/**
 *  美图美文的在数据库中的ID编号
 */
@property (nonatomic, assign) NSInteger ID;
/**
 *  美文的正文
 */
@property (nonatomic, copy) NSString *quote;
/**
 *  美文的原作者
 */
@property (nonatomic, copy) NSString *author;
/**
 *  字体名称
 */
@property (nonatomic, copy) NSString *fontName;

/**
 *  字体颜色RGB的R值
 */
@property (nonatomic, assign) CGFloat fontColorR;
/**
 *  字体颜色RGB的G值
 */
@property (nonatomic, assign) CGFloat fontColorG;
/**
 *  字体颜色RGB的B值
 */
@property (nonatomic, assign) CGFloat fontColorB;
/**
 *  字体大小
 */
@property (nonatomic, assign) CGFloat fontSize;
/**
 *  美图
 */
@property (nonatomic, strong) HooPhoto *photo;

/**
 *  在首页中的显示日期 格式：MM-DD
 */
@property (nonatomic, copy) NSString *show_date;
/**
 *  美图美文创建日期 距离1970年的间隔秒数 格式：1363503600
 */
@property (nonatomic, copy) NSString *created_date;
/**
 *  美图美文最后修改日期 距离1970年的间隔秒数 格式：1391603859
 */
@property (nonatomic, copy) NSString *modified_date;



@end
