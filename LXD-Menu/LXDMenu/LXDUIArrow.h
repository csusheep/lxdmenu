//
//  LXDUIArrow.h
//  LXD-Menu
//
//  Created by 刘 晓东 on 15/10/26.
//  Copyright © 2015年 刘 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXDUIArrow : UIView

@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, assign) CGFloat weight;
@property (nonatomic, assign) CGFloat degree;


+(instancetype)arrowWithFrame:(CGRect) frame;

+(instancetype)arrowWithFrame:(CGRect) frame
                        color:(UIColor *)color;

+(instancetype)arrowWithFrame:(CGRect) frame
                        color:(UIColor *)color
                       weight:(CGFloat)weight;

+(instancetype)arrowWithFrame:(CGRect) frame
                        color:(UIColor *)color
                       weight:(CGFloat)weight
                       degree:(CGFloat)degree;

- (void)shine;

@end
