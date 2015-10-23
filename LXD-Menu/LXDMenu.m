//
//  LXDMenu.m
//  LXD-Menu
//
//  Created by 刘 晓东 on 15/10/22.
//  Copyright © 2015年 刘 晓东. All rights reserved.
//
#define lxddebug
#import "LXDMenu.h"
#import "LXDMenuItem.h"

static const CGFloat defaultHeaderH = 44;
static const CGFloat mainViewH = 150.0f;

@interface LXDMenu()

@property (nonatomic, strong) UIView         *headerView;
@property (nonatomic, strong) UIView         *mainItemView;
@property (nonatomic, strong) UITableView    *bodyView;
@property (nonatomic, strong) UIToolbar      *backBLurView;
@property (nonatomic, strong) UIViewController *contentController;
@property (nonatomic, assign) CGFloat        headerHeight;
@property (nonatomic, strong) NSMutableArray *menuItemsStr;
@property (nonatomic, strong) NSMutableArray<LXDMenuItem *> *menuItems;

@property (nonatomic, strong) UIWindow   *myWindow;

@property (nonatomic, assign, getter=isOpened) BOOL opened;

@end

@implementation LXDMenu

+ (instancetype)menuViewWithItem:(NSArray *)items forViewController:(UIViewController*)vc {
    
    return [LXDMenu menuViewWithItem:items
                   forViewController:vc
                    withClickByIndex:nil];
}


+ (instancetype)menuViewWithItem:(NSArray *)items
               forViewController:(UIViewController*)vc
                withClickByIndex:(LXDMenuItemClickedBlock)clickhandle {
    return [LXDMenu menuViewWithItem:items
                   forViewController:vc
                        headerHeight:defaultHeaderH
                    withClickByIndex:nil];
}

+ (instancetype)menuViewWithItem:(NSArray *)items
               forViewController:(UIViewController*)vc
                    headerHeight:(CGFloat)headerHeigt
                withClickByIndex:(LXDMenuItemClickedBlock)clickhandle {
    
    return [LXDMenu menuViewWithItem:items
                   forViewController:vc
                        headerHeight:headerHeigt
                            mainItem:nil
                    withClickByIndex:clickhandle];
}

+ (instancetype)menuViewWithItem:(NSArray *)items
               forViewController:(UIViewController*)vc
                    headerHeight:(CGFloat)headerHeigt
                        mainItem:(UIView *)mainItem
                withClickByIndex:(LXDMenuItemClickedBlock)clickhandle {
    
    LXDMenu *menu = [[LXDMenu alloc] initWithFrame:CGRectMake(0, ScreenHeight - mainItem.height, ScreenWidth, ScreenHeight - defaultHeaderH )];
    
    //menu.backgroundColor = [UIColor colorWithRed:0.087 green:0.977 blue:0.959 alpha:1.000];
    menu.mainItemView = mainItem;
    menu.headerHeight = headerHeigt;
    menu.clickHandle = clickhandle;
    menu.contentController = vc;

    [menu commonInit];
    return  menu;
}

- (void)commonInit {
    
    _backBLurView = [[UIToolbar alloc] init];
    _backBLurView.barStyle = UIBarStyleBlackOpaque;
    
    [self addSubview:_backBLurView];
    
    if ( nil == _mainItemView) {
        _mainItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, mainViewH)];
        
        //_mainItemView.backgroundColor = [UIColor colorWithRed:1.000 green:0.177 blue:0.070 alpha:1.000];
    }
    [self setFrame:CGRectMake(0, ScreenHeight - _mainItemView.height, ScreenWidth, ScreenHeight - defaultHeaderH )];
    [_mainItemView setTag:101];
    [self addSubview:_mainItemView];
    
    if (0 == _headerHeight) {
        _headerHeight = defaultHeaderH;
    }
    
    if (nil == _headerView) {
        _headerView = [LXDMenuItem LXDMenuItemWithTitle:@"ceshi测试呢，这是测试啊" WithFrame:CGRectMake(0, -_headerHeight, ScreenWidth, _headerHeight)];
        _headerView.backgroundColor = [UIColor colorWithRed:0.153 green:0.419 blue:1.000 alpha:1.000];
    }
    
//    CGRect iFrame = CGRectMake(0, _headerHeight, ScreenWidth, _headerHeight);
//    self.myWindow = [[UIWindow alloc] initWithFrame:iFrame];
//    self.myWindow.backgroundColor = [UIColor colorWithRed:0.955 green:0.110 blue:0.122 alpha:1.000];
//    self.myWindow.userInteractionEnabled = YES;
//    self.myWindow.windowLevel = UIWindowLevelNormal;
//    UIViewController *rootViewController = [[UIViewController alloc] init];
//    
//    self.myWindow.rootViewController = rootViewController;
//    self.myWindow.hidden = NO;
    
    [_contentController.view insertSubview:_headerView atIndex:INT_MAX];

    [self setPanPressAction];
    
#ifdef lxddebug
    NSLog(@" menu view self=%f, self=%f", self.width, self.height);
#endif
}

- (void)layoutSubviews {
    _backBLurView.frame = self.bounds;
    [super layoutSubviews];
}

- (void)setSwipePressAction {
    UISwipeGestureRecognizer *swipGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_handleActionForSwipPressGesture:)];
    
    [self addGestureRecognizer:swipGesture];
}

- (void)_handleActionForSwipPressGesture:(UISwipeGestureRecognizer *)gesture {
    
}

- (void)setPanPressAction {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleActionForPanPressGesture:)];
    
    [self addGestureRecognizer:panGesture];
}

- (void)_handleActionForPanPressGesture:(UIPanGestureRecognizer *)gesture {
    
    __block CGPoint viewCenter = gesture.view.center;
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state ==
        UIGestureRecognizerStateChanged) {
        CGPoint translate = [gesture translationInView:self.superview];
        if ( viewCenter.y <= (ScreenHeight + self.height/2 - _mainItemView.height) && viewCenter.y >= self.height/2 + _headerHeight ) {
            viewCenter.y = ABS(viewCenter.y + translate.y);
            if (viewCenter.y < (ScreenHeight  + self.height/2 - _mainItemView.height) && viewCenter.y >= self.height/2 + _headerHeight ) {
                self.center = viewCenter;
                
                CGFloat a = (self.top - _headerHeight);
                CGFloat b = (ScreenHeight - _headerHeight -_mainItemView.height);

                 _headerView.frame  = CGRectMake(0, _headerView.height*(b-a)/b - _headerView.height, _headerView.width, _headerView.height);
                //_myWindow.frame  = CGRectMake(0, _myWindow.height*(b-a)/b - _myWindow.height, _myWindow.width, _myWindow.height);
                [gesture setTranslation:CGPointZero inView:self];
            }
        }
    }
    else if(gesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [gesture velocityInView:self.superview];
        if(velocity.y > 1000)
            [self closeMenuWithVelocity:velocity.y];
        else if(velocity.y < -1000)
            [self openMenuWithVelocity:ABS(velocity.y)];
        else if( viewCenter.y >=  (ScreenHeight/2 + (gesture.view.height - _mainItemView.height)/2) ){
            [self closeMenuWithVelocity:1200];
        }
        else if(viewCenter.y < (ScreenHeight/2 + (gesture.view.height - _mainItemView.height)/2) ){
            [self openMenuWithVelocity:1200];
        }
    }
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)openMenuWithVelocity:(CGFloat)velocity {
    
    [UIView animateWithDuration:(self.top - _headerHeight) / velocity
                     animations: ^{
                         self.center = CGPointMake(ScreenWidth/2, _headerHeight + self.height/2);
                         _headerView.center =CGPointMake(ScreenWidth/2, _headerHeight/2);
                         //_myWindow.center =CGPointMake(ScreenWidth/2, _headerHeight/2);
                     }
                     completion:^(BOOL completed){}];
}

- (void)closeMenuWithVelocity:(CGFloat)velocity {
    
    [UIView animateWithDuration: ABS( (ScreenHeight - self.top - _mainItemView.height/2) ) / velocity
                     animations: ^{
                         self.center = CGPointMake(ScreenWidth/2, ScreenHeight + self.height/2 - _mainItemView.height);
                         _headerView.center =CGPointMake(ScreenWidth/2, -_headerHeight);
                         //_myWindow.center =CGPointMake(ScreenWidth/2, -_headerHeight);

                     }
                     completion:^(BOOL completed){}];
}

@end
