//
//  LXDMenu.m
//  LXD-Menu
//
//  Created by 刘 晓东 on 15/10/22.
//  Copyright © 2015年 刘 晓东. All rights reserved.
//

#import "LXDMenu.h"

@class LXDMenuItem;

@interface LXDMenu()

@property(nonatomic, strong) UIView * headerView;
@property(nonatomic, strong) UIScrollView * bodyView;
@property(nonatomic, strong) UIToolbar *backBLurView;
@property (assign, nonatomic) CGFloat headerHeight;



@property(nonatomic, strong) NSArray<LXDMenuItem *> *menuItems;

@property (nonatomic, assign, getter=isOpened) BOOL opened;

@end

@implementation LXDMenu



- (id)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit {
    
}
@end
