//
//  LXDUIArrow.m
//  LXD-Menu
//
//  Created by 刘 晓东 on 15/10/26.
//  Copyright © 2015年 刘 晓东. All rights reserved.
//

#import "LXDUIArrow.h"
#import "UIView+Utils.h"

#define DEGREES_TO_RADIANS(angle) ((angle) * M_PI / 180 )

static const CGFloat WEIGHT = 7.f;
static const CGFloat DEFAULTDEGREE = 150.0f;
static const CGFloat MARGIN = 8.0f;


@interface LXDUIArrow()

@property(nonatomic, assign) CGPoint startPoint;
@property(nonatomic, assign) CGPoint endPoint;
@property(nonatomic, assign) CGPoint cornerPoint;

@end

@implementation LXDUIArrow

+(instancetype)arrowWithFrame:(CGRect) frame {
    UIColor * color = [UIColor grayColor];
    return [LXDUIArrow arrowWithFrame:frame color:color];
}

+(instancetype)arrowWithFrame:(CGRect) frame
                        color:(UIColor *)color{
    return [LXDUIArrow arrowWithFrame:frame color:color weight:WEIGHT];
}

+(instancetype)arrowWithFrame:(CGRect) frame
                        color:(UIColor *)color
                       weight:(CGFloat)weight{
    
    return [LXDUIArrow arrowWithFrame:frame color:color weight:weight degree:DEFAULTDEGREE];
}

+(instancetype)arrowWithFrame:(CGRect) frame
                        color:(UIColor *)color
                       weight:(CGFloat)weight
                       degree:(CGFloat)degree{
    LXDUIArrow *arrow = [[LXDUIArrow alloc] initWithFrame:frame];
    arrow.arrowColor = color;
    arrow.weight = weight;
    arrow.degree = degree;
    [arrow commonInit];
    return arrow;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _startPoint = CGPointMake(MARGIN, MARGIN);
        _endPoint = CGPointMake(self.width-MARGIN, MARGIN);
    }
    return self;
}

- (void)commonInit {
    if (nil == _arrowColor) {
        _arrowColor = [UIColor grayColor];
    }
    if (!_weight) {
        _weight = WEIGHT;
    }
    if (!_degree) {
        _degree = DEFAULTDEGREE;
    }

}

- (void)setDegree:(CGFloat)degree {
    if (_degree != degree) {
        _degree = degree;

        CGFloat dc = ( (_endPoint.x - _startPoint.x) / 2 ) * sin(DEGREES_TO_RADIANS(90 - _degree/2)) / sin(DEGREES_TO_RADIANS(_degree/2));
        
        CGFloat x = (_endPoint.x - _startPoint.x) / 2 + _startPoint.x;
        CGFloat y = _startPoint.x + dc;
        _cornerPoint = CGPointMake(x, y);
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context, WEIGHT);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, _startPoint.x, _startPoint.y);
    CGContextAddLineToPoint(context, _cornerPoint.x, _cornerPoint.y);
    CGContextAddLineToPoint(context, _endPoint.x, _endPoint.y);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, _startPoint.x, _startPoint.y, WEIGHT/2, 0, 2*M_PI, 0);
    CGContextAddArc(context, _endPoint.x, _endPoint.y, WEIGHT/2, 0, 2*M_PI, 0);
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
    
    
    // Drawing code
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // 本View不响应用户事件
    return NO;
    
}

@end
