//
//  LXDMenuItem.m
//  LXD-Menu
//
//  Created by 刘 晓东 on 15/10/22.
//  Copyright © 2015年 刘 晓东. All rights reserved.
//

#import "LXDMenuItem.h"
#import "UIView+Utils.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@implementation LXDMenuItem

+(instancetype)LXDMenuItemWithTitle:(NSString*)title {
    
    
    CGRect rect = CGRectMake(0,0,ScreenWidth,50);
    return [LXDMenuItem LXDMenuItemWithTitle:title WithFrame:rect];
}

+(instancetype)LXDMenuItemWithTitle:(NSString*)title WithFrame:(CGRect)frame {
    
    LXDMenuItem *item = [[LXDMenuItem alloc] initWithFrame:frame];
    
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
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2, self.height/2, self.width/2, self.height/3)];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    [self addSubview:_titleLabel];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = CGSizeMake(MAXFLOAT, _titleLabel.height);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:_titleLabel.font, NSFontAttributeName,nil];
    size =[_titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
    //根据计算结果重新设置UILabel的尺寸
    [_titleLabel setFrame:CGRectMake(self.width/2, self.height/2, size.width, self.height/3)];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
