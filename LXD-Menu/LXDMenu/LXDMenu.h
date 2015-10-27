//
//  LXDMenu.h
//  LXD-Menu
//
//  Created by 刘 晓东 on 15/10/22.
//  Copyright © 2015年 刘 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

typedef void(^LXDMenuItemClickedBlock)(NSInteger index);

@interface LXDMenuItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) void (^completion) (BOOL);

-(LXDMenuItem *)initMenuItemWithTitle:(NSString *)title withCompletionHandler:(void (^)(BOOL))completion;

@end


@interface LXDMenu : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) CGFloat                 animaDuration;
@property (nonatomic, copy  ) LXDMenuItemClickedBlock clickHandle;

+ (instancetype)menuViewWithItem:(NSArray *)items
               forViewController:(UIViewController*)vc;

+ (instancetype)menuViewWithItem:(NSArray *)items
               forViewController:(UIViewController*)vc
                withClickByIndex:(LXDMenuItemClickedBlock)clickhandle;

+ (instancetype)menuViewWithItem:(NSArray *)items
                 forViewController:(UIViewController*)vc
                      headerHeight:(CGFloat)headerHeigt
                withClickByIndex:(LXDMenuItemClickedBlock)clickhandle;

+ (instancetype)menuViewWithItem:(NSArray *)items
               forViewController:(UIViewController*)vc
                    headerHeight:(CGFloat)headerHeigt
                        mainItem:(UIView *)mainItem
                withClickByIndex:(LXDMenuItemClickedBlock)clickhandle;

@end
