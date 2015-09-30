/*!
 非常酷的一个单击按钮显示更多按钮的，类似开花的效果
 */

#import <UIKit/UIKit.h>
#import "HooFlowerItem.h"
@class HooFlowerButton;

//按钮是否打开的状态枚举
typedef enum {
    HooFlowerButtonsStateOpened,
    HooFlowerButtonsStateClosed,
    HooFlowerButtonsStateNormal
}HooFlowerButtonsState;


//---------------------HooFlowerButtonDelegate----------------------
@protocol HooFlowerButtonDelegate <NSObject>
/**
 *  选中子按钮时候触发的代理事件
 *
 *  @param flowerButton 中心按钮
 *  @param item            子按钮
 */
- (void)flowerButton:(HooFlowerButton*)flowerButton
          didSelectItem:(HooFlowerItem*)item;


/**
 *  设置子控件个数代理
 *
 *  @param flowerButton 中心按钮
 *
 *  @return 返回子控件的个数
 */
- (NSInteger)flowerButtonNumberOfItems:(HooFlowerButton*)flowerButton;
/**
 *  设置子按钮的标题
 *
 *  @param flowerButton 中心按钮
 *  @param index           索引
 *
 *  @return 返回标题
 */
- (NSString*)flowerButton:(HooFlowerButton*)flowerButton
         titleForItemAtIndex:(NSInteger)index;
/**
 *  设置子按钮的图片 建议大小为30*30
 *
 *  @param flowerButton 中心按钮
 *  @param index           索引
 *
 *  @return 返回子按钮图片
 */
- (UIImage *)flowerButton:(HooFlowerButton *)flowerButton
         imageForItemAtIndex:(NSInteger)index;
@optional
/**
 *  允许显示其在createOtherViewsIn:aboveView:方法中新添加的View.
 *
 *  @return YES  允许添加新View, NO 不允许
 */
- (BOOL) showOtherViews;
/**
 *  新增view到中心按钮的父视图
 *
 *  @param superView 按钮的父视图
 *  @param blackView 蒙版
 *
 *  @return 返回添加的视图数组
 */
- (NSArray *)createOtherViewsIn:(UIView *)superView aboveView:(UIView *)blackView;
/*! 设置按钮的样式
 */
- (void)flowerButton:(HooFlowerButton*)optionsButton
  willDisplayButtonItem:(HooFlowerItem*)button;
/**
 *  中心按钮点击时的调用的方法
 *
 *  @param flowerButton 中心按钮
 */
- (void)flowerButtonDidClicked:(HooFlowerButton *)flowerButton;


@end


//----------------------flowerButton--------------------
@interface HooFlowerButton : UIButton
/**
 *  容器
 */
@property (nonatomic, weak) UIView *containerView;

/**
 *  定义HooFlowerButtonDelegate代理属性
 */
@property (nonatomic, weak)   id<HooFlowerButtonDelegate> delegate;


/**
 *  按钮当前的状态
 */
@property (nonatomic, readonly) HooFlowerButtonsState currentState;


/*!
 * 动画振动的幅度customize the animation dynamic behaviour.
 * Dont change it if you dont know what the heck is this
 */
@property (nonatomic, assign) CGFloat damping;
/**
 *  动画执行时长
 */
@property (nonatomic, assign) CGFloat duration;

- (instancetype)initFlowerButtonWithView:(UIView *)superView showInView:(UIView *)containerView;

/**
 *  删除子按钮和蒙板
 */
- (void)removeItemsAndBlackView;
- (void)showOrHideSubviews;
- (void)hideFlowerButtons;

@end



