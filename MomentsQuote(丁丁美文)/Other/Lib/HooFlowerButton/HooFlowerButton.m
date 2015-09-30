#import "HooFlowerButton.h"
#import "FXBlurView.h"


@interface HooFlowerButton ()
/**
 *  是否显示其他子视图，这里的其他子视图，需要通过代理
 - (BOOL) showOtherViews;
 - (NSArray *)clickCenterButton:(flowerButton *)centerButton addOtherViewsOnsuperView:(UIView *)superView aboveView:(UIView *)blackView;
 来获取
 */
@property (nonatomic, assign) BOOL showOtherViews;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) FXBlurView *blackView;

@end

@implementation HooFlowerButton

#pragma mark -  懒加载
- (NSMutableArray *)viewArray
{
    if (_viewArray == nil) {
        _viewArray = [NSMutableArray array];
        
    }
    return _viewArray;
}

- (instancetype)initFlowerButtonWithView:(UIView *)superView showInView:(UIView *)containerView
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 80, 80)]) {
        _damping = 0.5;
        _duration = 1.0;
        _currentState = HooFlowerButtonsStateNormal;
        _items = [NSMutableArray new];
        _containerView = containerView;
        [superView addSubview:self];
        self.center = superView.center;
        self.backgroundColor = [UIColor purpleColor];
        self.layer.cornerRadius = 40;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.clipsToBounds = YES;
        self.layer.zPosition = MAXFLOAT;
        [self addTarget:self
                 action:@selector(buttonPressed)
       forControlEvents:UIControlEventTouchUpInside];
        [self addObservers];
        self.translatesAutoresizingMaskIntoConstraints = YES;
        
    }

    return self;
}


#pragma mark - 监听屏幕旋转 UIInterfaceOrientation notifications
- (void)addObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
}

//旋转时候调用的方法
- (void)orientationChanged:(NSNotification *)note {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return;
    }

    if(self.currentState == HooFlowerButtonsStateOpened) {
        [self buttonPressed];
    }
}

#pragma mark - 中心按钮按下的事件

- (void)buttonPressed {
    
    //按钮点击代理
    if ([self.delegate respondsToSelector:@selector(flowerButtonDidClicked:)]) {
        [self.delegate flowerButtonDidClicked:self];
    }
    
    //是否允许添加View
    if ([self.delegate respondsToSelector:@selector(showOtherViews)]) {
        self.showOtherViews = [self.delegate showOtherViews];
    }
    
    if (self.selected) {
        
        if(self.currentState == HooFlowerButtonsStateNormal ||
           self.currentState == HooFlowerButtonsStateClosed) {
            
            _currentState = HooFlowerButtonsStateOpened;
            
        } else {
            _currentState = HooFlowerButtonsStateClosed;
        }
        [self setCurrentState:self.currentState animated:YES];
    }
    if (self.selected == NO) {
        self.selected = YES;
    }

    
}
- (void)setCurrentState:(HooFlowerButtonsState)state animated:(BOOL)animated {
    _currentState = state;
    

    CGFloat animationDelay = 0.0;
    

    
    if(self.currentState == HooFlowerButtonsStateNormal ||
       self.currentState == HooFlowerButtonsStateClosed) {
        

        animationDelay = 0.05;
        [self hideFlowerButtons];
        [self removeBlackView];
        [self removeOtherViews];
        
    } else {
        //添加遮盖
        [self addBlackView];
        //显示子按钮
        [self showButtons];
        //创建新的子控件
        if (self.showOtherViews) {
            [self addOtherViews];
        }
    }
    
}

#pragma  mark - 遮盖相关

- (void)addBlackView {
    
    self.enabled = NO;
    
    [self.containerView insertSubview:self.blackView belowSubview:self.superview];
    [UIView animateWithDuration:self.duration/2 animations:^{
        
        self.blackView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.enabled = YES;
    }];
}

- (UIView *)blackView {
    
    if(_blackView == nil) {
        _blackView = [[FXBlurView alloc] initWithFrame:self.containerView.bounds];
        
        _blackView.dynamic = YES;
        _blackView.blurRadius = 5;
        _blackView.autoresizingMask = [self allAutoresizingMasksFlags];
        [_blackView setTranslatesAutoresizingMaskIntoConstraints:YES];
        
        _blackView.backgroundColor = [UIColor whiteColor];
        _blackView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewPressed)];
        [_blackView addGestureRecognizer:tap];
    }
    return _blackView;
}

- (void)removeBlackView {
    self.enabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 0.0;

    } completion:^(BOOL finished) {
        
        [self.blackView removeFromSuperview];
        self.blackView = nil;
        
        self.enabled = YES;
    }];
}
- (void)blackViewPressed {
    [self buttonPressed];
}

#pragma  mark - 其他子视图
- (void)addOtherViews
{
    if ([self.delegate respondsToSelector:@selector(createOtherViewsIn:aboveView:)]) {
        NSArray *viewArray = [self.delegate createOtherViewsIn:self.containerView aboveView:self.blackView];
        [self.viewArray addObjectsFromArray:viewArray];
    }
}


- (void)removeOtherViews
{
    for (UIView *view in self.viewArray) {

        self.enabled = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
           view.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            [self removeViewArray];
            self.enabled = YES;
        }];
    }
}
- (void)removeViewArray
{
    for(UIView *view in self.viewArray) {
        [view removeFromSuperview];
        
    }
    [self.viewArray removeAllObjects];
}

#pragma  mark - 子按钮相关

- (void)showButtons {
        NSInteger numberOfItems = [self.delegate flowerButtonNumberOfItems:self];
        NSAssert(numberOfItems > 0 , @"number of items should be more than 0");

    
    CGFloat angle = 0.0;
    CGFloat radius = 25 * numberOfItems;
    angle = (180.0 / numberOfItems);
    // convert to radians

    angle = angle / 180.0f * M_PI;
    
    for(int i = 0; i<numberOfItems; i++) {
        CGFloat buttonX = radius * cosf((angle * i) + angle/2);
        CGFloat buttonY = radius * sinf((angle * i) + angle/2);

        HooFlowerItem *brOptionItem = [self createButtonItemAtIndex:i];
        CGPoint mypoint = [self.containerView convertPoint:self.center fromView:self.superview];
        CGPoint buttonPoint = CGPointMake(mypoint.x + buttonX, 
        (mypoint.y -  buttonY) - self.frame.size.height/2);
        
        brOptionItem.layer.anchorPoint = self.layer.anchorPoint;
        brOptionItem.center = mypoint;
        brOptionItem.defaultLocation = buttonPoint;
    
        [self.containerView insertSubview:brOptionItem aboveSubview:self.blackView];
        
        [UIView animateWithDuration:self.duration/2 animations:^{
            brOptionItem.center = buttonPoint;
        } completion:nil];
        [self.items addObject:brOptionItem];
    }
}

/*! 创建按钮 Just make new button, set the index
 * and customise it
 */
- (HooFlowerItem*)createButtonItemAtIndex:(NSInteger)index {
    
    HooFlowerItem *brOptionItem = [[HooFlowerItem alloc] initWithIndex:index];
    [brOptionItem addTarget:self
                     action:@selector(buttonItemPressed:)
           forControlEvents:UIControlEventTouchUpInside];
    brOptionItem.autoresizingMask = UIViewAutoresizingNone;
    //按钮图片和位子
    UIImage *image;
    NSString *buttonTitle;
    
    if([_delegate respondsToSelector:@selector(flowerButton:imageForItemAtIndex:)]) {
        
        image = [self.delegate flowerButton:self
                                    imageForItemAtIndex:index];
        if(image) {
            [brOptionItem setImage:image forState:UIControlStateNormal];

        }
        
    }
    
    if([_delegate respondsToSelector:@selector(flowerButton:titleForItemAtIndex:)]) {
        
        buttonTitle = [self.delegate flowerButton:self
                                           titleForItemAtIndex:index];
        if(buttonTitle != nil) {
            brOptionItem.titleLabel.font = [UIFont systemFontOfSize:11];
            [brOptionItem setTitle:buttonTitle forState:UIControlStateNormal];
            [brOptionItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            brOptionItem.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    if (image != nil && buttonTitle != nil) {
        brOptionItem.imageEdgeInsets = UIEdgeInsetsMake(-10,11,0,0);
        brOptionItem.titleEdgeInsets = UIEdgeInsetsMake(30, -brOptionItem.imageView.image.size.width, 0, 0);
    }
    

    brOptionItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    return brOptionItem;
}

- (void)hideFlowerButtons {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:self.duration/2 animations:^{
            
            for(int i = 0; i < self.items.count; i++) {
                
                UIView *item = [self.items objectAtIndex:i];
                item.center = [self.containerView convertPoint:self.center fromView:self.superview];
            }
        } completion:^(BOOL finished) {
            
            [self removeItems];
            //NSLog(@"finished");
        }];
    });
}

- (void)removeItems {
    for(UIView *view in self.items) {
        [view removeFromSuperview];
    }
    [self.items removeAllObjects];

}

- (void)buttonItemPressed:(HooFlowerItem*)button {
    
    // removeing the object will not animate it with others
    [self.items removeObject:button];
    [self buttonPressed];
    if ([self.delegate respondsToSelector:@selector(flowerButton:didSelectItem:)]) {
        
        [self.delegate flowerButton:self didSelectItem:button];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        button.transform = CGAffineTransformMakeScale(3, 3);
        button.alpha  = 0.0;
       // button.center = CGPointMake(button.center.x,
                                    //button.superview.frame.size.height / 2);
    } completion:^(BOOL finished) {
        [button removeFromSuperview];
    }];
}


#pragma mark - 删除子视图


- (void)removeItemsAndBlackView
{
    if(self.currentState == HooFlowerButtonsStateOpened){
        [self removeItems];
        [self removeBlackView];
        [self removeViewArray];
        

        _currentState = HooFlowerButtonsStateClosed;
    }
}
//#pragma mark - 显示子视图
- (void)showOrHideSubviews
{
    [self buttonPressed];
}

#pragma mark - autoResize
- (UIViewAutoresizing)allAutoresizingMasksFlags {
    UIViewAutoresizing mask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    return mask;
}
#pragma mark - 释放通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
