//
//  HooHeaderView.h
//  MomentsLife
//
//  Created by HooJackie on 15/9/7.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HooMoment;
@interface HooHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**
 *  美图美文
 */
@property (nonatomic, strong)HooMoment *moment;
/**
 *  imageview的图片
 */
@property (nonatomic, strong)UIImage *headerImage;
/**
 *  是否显示文字
 */
@property (nonatomic, assign,getter=isShowAuthor) BOOL showQuote;

+ (instancetype)headerView;

@end
