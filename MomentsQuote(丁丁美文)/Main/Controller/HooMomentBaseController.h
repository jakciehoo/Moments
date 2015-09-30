//
//  HooHomeViewController.h
//  MomentsQuote(丁丁美文)
//
//  Created by HooJackie on 15/8/15.
//  Copyright (c) 2015年 jackieHoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HooEditToolView.h"
#import "HooFlowerButton.h"
@class HooMoment;
@class HooQuoteView;

typedef enum : NSUInteger {
    MomentModeOrigin,//初始状态，不显示返回和保存按钮
    MomentModeNext,//点击下一个进入Next状态，显示返回按钮，不显示保存按钮
    MomentModeEdit,//点击编辑按钮，进入编辑状态，显示返回按钮，也显示保存按钮,保存到数据库t_moment
    MomentModeCreate //点击顶部椭圆按钮，进入创建模式，显示返回按钮，也显示保存按钮，保存到数据库t_myMoment
} MomentMode;

@interface HooMomentBaseController : UIViewController<HooFlowerButtonDelegate,HooEditToolViewDelegate>
/**
 *  美文美图类型的属性
 */
@property (nonatomic, strong) HooMoment *originMoment;
/**
 *  下一个美文美图
 */
@property (nonatomic, strong)HooMoment *editMoment;
/**
 *  美图
 */
@property (nonatomic, strong) UIImage *momentImage;

/**
 *  美图视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**
 *  美文视图
 */
@property (nonatomic, weak) HooQuoteView *quoteView;
/**
 *  中心按钮
 */
@property (nonatomic, weak) HooFlowerButton *centerButton;
/**
 *  美图主要的颜色
 */
@property (nonatomic, strong) UIColor *imageColor;
/**
 *  是否来源于我创建的美文美图
 */
@property (nonatomic, assign)BOOL fromMine;


@property (nonatomic, assign)MomentMode mode;


@end
