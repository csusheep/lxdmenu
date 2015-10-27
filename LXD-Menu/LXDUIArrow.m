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
static const CGFloat MARGIN = 10.0f;


@interface LXDUIArrow()

@property(nonatomic, assign) CGPoint startPoint;
@property(nonatomic, assign) CGPoint endPoint;
@property(nonatomic, assign) CGPoint cornerPoint;
@property(nonatomic, strong) CADisplayLink *displaylink;
@property(nonatomic, assign) CFTimeInterval shineDuration;
@property(nonatomic, assign) CFTimeInterval beginTime;
@property(nonatomic, assign) CFTimeInterval endTime;

@end

@implementation LXDUIArrow

+(instancetype)arrowWithFrame:(CGRect) frame {

    return [LXDUIArrow arrowWithFrame:frame color:nil];
}

+(instancetype)arrowWithFrame:(CGRect) frame
                        color:(UIColor *)color{
    return [LXDUIArrow arrowWithFrame:frame color:color weight:0];
}

+(instancetype)arrowWithFrame:(CGRect) frame
                        color:(UIColor *)color
                       weight:(CGFloat)weight{
    
    return [LXDUIArrow arrowWithFrame:frame color:color weight:weight degree:0];
}

+(instancetype)arrowWithFrame:(CGRect) frame
                        color:(UIColor *)color
                       weight:(CGFloat)weight
                       degree:(CGFloat)degree{
    LXDUIArrow *arrow = [[LXDUIArrow alloc] initWithFrame:frame];
    arrow.arrowColor  = color;
    arrow.weight      = weight;
    arrow.degree      = degree;
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
        _arrowColor = [UIColor colorWithRed:150/255.0 green:156/225.0 blue:144/225.0 alpha:1];
    }
    if (!_weight) {
        _weight = WEIGHT;
    }
    if (!_degree) {
        _degree = DEFAULTDEGREE;
    }
    
    _shineDuration = .3f;

    _displaylink        = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateArrowColor)];
    _displaylink.paused = YES;
    [_displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)shine {
    [self animationWithDuration:_shineDuration];
}

- (void)animationWithDuration:(CFTimeInterval)duration {
    _beginTime = CACurrentMediaTime();
    _endTime = _beginTime + _shineDuration;
    _displaylink.paused = NO;
}

- (void)updateArrowColor {
    
    CFTimeInterval now = CACurrentMediaTime();
    CGFloat percentage = ( now - _beginTime ) / _shineDuration;
    if ( now < ( _endTime - _beginTime ) / 2 + _beginTime ) {
        percentage = 1 - percentage;
    }
    [self setArrowColor:[_arrowColor colorWithAlphaComponent:percentage]];
    if (now > _endTime) {

        _displaylink.paused = YES;
        
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

- (void)setArrowColor:(UIColor *)arrowColor {
    _arrowColor = arrowColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context, _weight);
    CGContextSetStrokeColorWithColor(context, _arrowColor.CGColor);
    
    CGContextSetStrokeColorWithColor(context, _arrowColor.CGColor);
    CGContextSetFillColorWithColor(context, _arrowColor.CGColor);
    CGContextSetBlendMode(context, kCGBlendModeLuminosity);
    CGContextSetLineWidth(context, .1);
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, _startPoint.x, _startPoint.y , _weight/2, DEGREES_TO_RADIANS(180 - (_degree/2)), DEGREES_TO_RADIANS(360-_degree/2), 0);

    CGFloat a = _weight/2 * sin(DEGREES_TO_RADIANS(_degree/2)) / sin(DEGREES_TO_RADIANS(90));
    CGFloat b = _weight/2 * sin(DEGREES_TO_RADIANS(90 - _degree/2)) / sin(DEGREES_TO_RADIANS(90));

    CGContextMoveToPoint(context, _startPoint.x + b, _startPoint.y - a);
    CGContextAddLineToPoint(context, _cornerPoint.x, _cornerPoint.y - _weight/2);
    CGContextAddLineToPoint(context, _endPoint.x - b, _endPoint.y - a);
    CGContextAddLineToPoint(context, _endPoint.x + b, _endPoint.y + a);
    CGContextAddArc(context, _endPoint.x, _endPoint.y, _weight/2, DEGREES_TO_RADIANS(180 + (_degree/2)), DEGREES_TO_RADIANS(_degree/2), 0);
    CGContextAddLineToPoint(context, _cornerPoint.x, _cornerPoint.y + _weight/2);
    CGContextAddLineToPoint(context, _startPoint.x - b, _startPoint.y + a);
    CGContextAddLineToPoint(context, _startPoint.x + b, _startPoint.y - a);
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}

 // 不响应用户事件
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

@end
