//
//  LXDMenu.m
//  LXD-Menu
//
//  Created by 刘 晓东 on 15/10/22.
//  Copyright © 2015年 刘 晓东. All rights reserved.
//
#define lxddebug
#import "LXDMenu.h"
#import "LXDMenuHeaderVIew.h"
#import "LXDUIArrow.h"

static const CGFloat defaultHeaderH = 44;
static const CGFloat mainViewH = 50.0f;
static const CGFloat arrowStartDegree = 180.f;
static const CGFloat arrowEndDegree = 150.f;


@implementation LXDMenuItem

-(LXDMenuItem *)initMenuItemWithTitle:(NSString *)title
               withCompletionHandler:(void (^)(BOOL))completion;
{
    self.title = title;
    self.completion = completion;
    return self;
}

@end

@interface LXDMenu()

@property (nonatomic, strong) LXDMenuHeaderVIew *headerView;
@property (nonatomic, strong) UIView            *mainItemView;
@property (nonatomic, strong) UITableView       *bodyView;
@property (nonatomic, strong) UIToolbar         *backBLurView;
@property (nonatomic, strong) UIViewController  *contentController;
@property (nonatomic, assign) CGFloat           headerHeight;
@property (nonatomic, strong) UIFont            *menuItemFont;
@property (nonatomic, strong) LXDUIArrow        *arrow;
@property (nonatomic, strong) NSArray<LXDMenuItem *>   *menuItems;


@property (nonatomic, assign, getter = isOpened) BOOL opened;

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
    
    UIFont *menuItemFont = [UIFont systemFontOfSize:20];
 
    return  [LXDMenu menuViewWithItem:items forViewController:vc headerHeight:headerHeigt mainItem:mainItem menuItemFont:menuItemFont withClickByIndex:clickhandle];
}

+ (instancetype)menuViewWithItem:(NSArray *)items
               forViewController:(UIViewController*)vc
                    headerHeight:(CGFloat)headerHeigt
                        mainItem:(UIView *)mainItem
                    menuItemFont:(UIFont*)font
                withClickByIndex:(LXDMenuItemClickedBlock)clickhandle {
    
    LXDMenu *menu = [[LXDMenu alloc] initWithFrame:CGRectMake(0, ScreenHeight - mainItem.height, ScreenWidth, ScreenHeight - defaultHeaderH )];
    
    menu.mainItemView = mainItem;
    menu.headerHeight = headerHeigt;
    menu.clickHandle = clickhandle;
    menu.contentController = vc;
    menu.menuItems = items;
    menu.menuItemFont = font;
    [menu commonInit];
    return  menu;

}

- (void)commonInit {
    
    _backBLurView = [[UIToolbar alloc] init];
    _backBLurView.barStyle = UIBarStyleBlackOpaque;
    
    [self addSubview:_backBLurView];
    
    if ( nil == _mainItemView) {
        _mainItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, mainViewH)];
    }
    [self setFrame:CGRectMake(0, ScreenHeight - _mainItemView.height, ScreenWidth, ScreenHeight - defaultHeaderH )];

    [self addSubview:_mainItemView];
    
    _bodyView = [[UITableView alloc] initWithFrame:CGRectMake(0, _mainItemView.height, ScreenWidth, ScreenHeight-_mainItemView.height)];
    
    [_bodyView setDelegate:self];
    [_bodyView setDataSource:self];
    [_bodyView setShowsVerticalScrollIndicator:NO];
    [_bodyView setSeparatorColor:[UIColor clearColor]];
    [_bodyView setAllowsMultipleSelection:NO];
    [_bodyView setBackgroundColor: [UIColor clearColor]];
    [self addSubview:_bodyView];
    _bodyView.backgroundView.backgroundColor = [UIColor clearColor];
    [_bodyView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    if (0 == _headerHeight) {
        _headerHeight = defaultHeaderH;
    }
    
    _arrow = [LXDUIArrow arrowWithFrame:CGRectMake(ScreenWidth/2 - 25, 0, 50, 30)];
    _arrow.degree = arrowStartDegree;
    [self addSubview:_arrow];
    
    [self setPanPressAction];
    
#ifdef lxddebug
    NSLog(@" menu view self=%f, self=%f", self.width, self.height);
#endif
}

- (void)layoutSubviews {
    _backBLurView.frame = self.bounds;
    [super layoutSubviews];
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
                 _arrow.degree = arrowStartDegree - (arrowStartDegree - arrowEndDegree)*((b-a)/b);
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

- (void)createHeaderWindow {
    if (nil == _headerView) {
        _headerView = [LXDMenuHeaderVIew LXDMenuItemWithTitle:@"做某某事情的菜单标题" WithFrame:CGRectMake(0, -_headerHeight, ScreenWidth, _headerHeight)];
        _headerView.windowLevel = UIWindowLevelAlert;
        //_headerView.backgroundColor = [UIColor clearColor];
        [_headerView setHidden:NO];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self createHeaderWindow];
}

- (void)openMenuWithVelocity:(CGFloat)velocity {
    
    [UIView animateWithDuration:(self.top - _headerHeight) / velocity
                     animations: ^{
                         self.center = CGPointMake(ScreenWidth/2, _headerHeight + self.height/2);
                         _headerView.center =CGPointMake(ScreenWidth/2, _headerHeight/2);
                         _arrow.degree = arrowEndDegree;
                     }
                     completion:^(BOOL completed){
                         [_arrow shine];
                         
                    }];
}

- (void)closeMenuWithVelocity:(CGFloat)velocity {
    
    [UIView animateWithDuration: ABS( (ScreenHeight - self.top - _mainItemView.height/2) ) / velocity
                     animations: ^{
                         self.center = CGPointMake(ScreenWidth/2, ScreenHeight + self.height/2 - _mainItemView.height);
                         _headerView.center =CGPointMake(ScreenWidth/2, -_headerHeight);
                         _arrow.degree = arrowStartDegree;

                     }
                     completion:^(BOOL completed){}];
}
- (void)closeMenuWithCallBack:(void (^)(BOOL ))callBack {
    [UIView animateWithDuration:.3
                     animations:^{
                         self.center = CGPointMake(ScreenWidth/2, ScreenHeight + self.height/2 - _mainItemView.height);
                         _headerView.center =CGPointMake(ScreenWidth/2, -_headerHeight);
                         _arrow.degree = arrowStartDegree;
                     }
                     completion:^(BOOL finshed){
                         if (finshed && callBack) {
                             callBack(finshed);
                         }
    }];
}

#pragma-mark <uitabledatasource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.menuItems count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (nil != _menuItems) {
        cell.textLabel.text = [_menuItems objectAtIndex: indexPath.row].title;
        cell.textLabel.textColor = [UIColor colorWithRed:( arc4random() % 256 / 256.0 ) green:( arc4random() % 256 / 256.0 ) blue:( arc4random() % 256 / 256.0 ) alpha:1.0f ];
    }
    return cell;
}


#pragma-mark uitabledelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (nil == _menuItems) {
        return;
    }
    [self closeMenuWithCallBack:[_menuItems objectAtIndex: indexPath.row].completion];
    
}



@end
