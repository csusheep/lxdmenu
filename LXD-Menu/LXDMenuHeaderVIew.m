//
//  LXDMenuItem.m
//  LXD-Menu
//
//  Created by 刘 晓东 on 15/10/22.
//  Copyright © 2015年 刘 晓东. All rights reserved.
//

#import "LXDMenuHeaderVIew.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface LXDMenuHeaderVIew()

@property (nonatomic, strong) UIToolbar   *backBLurView;

@end

@implementation LXDMenuHeaderVIew

+(instancetype)LXDMenuItemWithTitle:(NSString*)title {
    
    CGRect rect = CGRectMake(0,0,ScreenWidth,50);
    return [LXDMenuHeaderVIew LXDMenuItemWithTitle:title WithFrame:rect];
}

+(instancetype)LXDMenuItemWithTitle:(NSString*)title WithFrame:(CGRect)frame {
    
    LXDMenuHeaderVIew *item = [[LXDMenuHeaderVIew alloc] initWithFrame:frame];
    
    item.titleLabel.text = title;
    [item setNeedsLayout];
    return item;
}

-(id)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    
    _backBLurView          = [[UIToolbar alloc] init];
    _backBLurView.barStyle = UIBarStyleDefault;
    [self addSubview:_backBLurView];
    
    if (nil == _titleLabel) {
        _titleLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height/2, self.width, self.height/3)];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font          = [UIFont systemFontOfSize:18];
    }
    [self addSubview:_titleLabel];

}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    _backBLurView.frame = self.bounds;
    CGSize size         = CGSizeMake(MAXFLOAT, _titleLabel.height);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:_titleLabel.font, NSFontAttributeName,nil];
    size = [_titleLabel.text
           boundingRectWithSize:size
           options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
           attributes:tdic
           context:nil].size;
    //根据计算结果重新设置UILabel的尺寸
    //[_titleLabel setFrame:CGRectMake(0, self.height/2, size.width, self.height/3)];
}

@end
