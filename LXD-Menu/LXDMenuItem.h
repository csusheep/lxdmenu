//
//  LXDMenuItem.h
//  LXD-Menu
//
//  Created by 刘 晓东 on 15/10/22.
//  Copyright © 2015年 刘 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Utils.h"

@interface LXDMenuItem : UIView

@property(nonatomic, strong) UILabel * titleLabel;

+(instancetype)LXDMenuItemWithTitle:(NSString*)title;
+(instancetype)LXDMenuItemWithTitle:(NSString*)title WithFrame:(CGRect)frame;

@end
