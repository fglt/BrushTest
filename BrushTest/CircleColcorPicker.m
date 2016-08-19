//
//  CircleColcorPicker.m
//  Drawing
//
//  Created by Coding on 6/8/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "CircleColcorPicker.h"
#import "InfColorIndicatorView.h"
#import "InfHSBSupport.h"
#define kContentInsetX 20
#define kIndicatorSize 24.0

const double PI2 = 2*M_PI;

IB_DESIGNABLE
@implementation CircleColcorPicker{
    InfColorIndicatorView* indicator;
    CircleColorView *colorView;
}


- (void) layoutSubviews
{
    
    if(colorView == nil){
        colorView = [[CircleColorView  alloc] initWithFrame:self.bounds];
        colorView.backgroundColor = [UIColor clearColor];
        colorView.userInteractionEnabled = NO ;
        [self addSubview:colorView];
    }
    if (indicator == nil) {
        _value = CGPointMake(CGRectGetMidX(self.bounds) + colorView.middleRadius, CGRectGetMidY(self.bounds));
        
        indicator = [[InfColorIndicatorView alloc] initWithFrame: CGRectMake(_value.x, _value.y, kIndicatorSize, kIndicatorSize)];
        [self addSubview: indicator];
    }
    
    indicator.color = [UIColor colorWithHue: _hue
                                 saturation: 1.0f
                                 brightness: 1.0f
                                      alpha: 1.0f];
    
    
    indicator.center = _value;
    
    
    //NSLog(@"center: %f %f", indicator.center.x, indicator.center.y);
}

-(void) hueCal;
{
    
    CGPoint pcenter = CGPointMake( CGRectGetMidY(self.bounds), CGRectGetMidY(self.bounds));
    
    CGFloat alpha = asin( (pcenter.y - _value.y)/colorView.middleRadius );
    
    if(_value.x-pcenter.x >= 0 )
    {
        if(alpha < 0)
        {
            alpha = PI2 + alpha ;
        }
    }else
        alpha =  M_PI - alpha ;
    _hue = alpha/PI2 ;
    NSLog(@"hue: %f", _hue );
}

- (void) setValue: (CGPoint) newValue
{
    if (newValue.x != _value.x && newValue.y != _value.y) {
        _value = newValue;
        
        [self  hueCal];
        
        [self sendActionsForControlEvents: UIControlEventValueChanged];
        [self setNeedsLayout];
    }
}


-(void) setHue:(CGFloat)newHue
{
    if(newHue != _hue)
    {
        _hue = newHue;
        CGFloat  y =  CGRectGetMidY(self.bounds) - colorView.middleRadius * sin(_hue * PI2);
        CGFloat x =  CGRectGetMidX(self.bounds) + colorView.middleRadius * cos(_hue * PI2);
        [self setValue:CGPointMake(x, y)];
        NSLog(@"center: %f,  %f", x, y);
    }
}

- (void) trackIndicatorWithTouch: (UITouch*) touch
{
    CGPoint point = [touch locationInView: self];
    CGFloat sy = CGRectGetMidY(self.bounds);
    CGFloat sx = CGRectGetMidX(self.bounds);
    
    CGFloat dis = sqrt((sx-point.x)*(sx-point.x) + (sy-point.y)*(sy-point.y));

    self.value =  CGPointMake(sx + (colorView.middleRadius / dis) * (point.x-sx), sy + (colorView.middleRadius / dis) * (point.y-sy));

    NSLog(@"point: %f, y: %f", point.x, point.y);
}

- (BOOL) beginTrackingWithTouch: (UITouch*) touch
                      withEvent: (UIEvent*) event
{
    [self trackIndicatorWithTouch: touch];
    
    return YES;
}

//------------------------------------------------------------------------------

- (BOOL) continueTrackingWithTouch: (UITouch*) touch
                         withEvent: (UIEvent*) event
{
    [self trackIndicatorWithTouch: touch];
    
    return YES;
}

@end

IB_DESIGNABLE
@implementation CircleColorView
-(void) drawRect:(CGRect)rect
{
    UIBezierPath *bpath;
    
    CGPoint point1;
    CGPoint point2;
    
    //NSLog(@"%d", [bezierPoints count]);
    float r = _radius;
    for (int i = 0; i < 360 ; ++i)
    {
        UIColor *color = [UIColor colorWithHue:i/360.0 saturation:1 brightness:1 alpha:1];
        //NSLog(@"%f: ", i/360.0f);
        bpath = [UIBezierPath bezierPath];
        point1 = CGPointMake(self.center.x + r*cos(i/180.0*M_PI), self.center.y - r*sin(i/180.0*M_PI));
        point2 = CGPointMake(self.center.x + r*cos((i+1)/180.0*M_PI), self.center.y - r*sin((i+1)/180.0*M_PI));
        
        [bpath moveToPoint:self.center];
        [bpath addLineToPoint:point1];
        [bpath addLineToPoint:point2];
        
        [color set];
        [bpath fill];
        [bpath stroke];
        
    }
    
    r = r - 30;
    UIColor *fillColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    for (int i = 0; i < 360 ; ++i)
    {
        //NSLog(@"%f: ", i/360.0f);
        bpath = [UIBezierPath bezierPath];
        point1 = CGPointMake(self.center.x + r*cos(i/180.0*M_PI), self.center.y + r*sin(i/180.0*M_PI));
        point2 = CGPointMake(self.center.x + r*cos((i+1)/180.0*M_PI), self.center.y + r*sin((i+1)/180.0*M_PI));
        
        [bpath moveToPoint:self.center];
        [bpath addLineToPoint:point1];
        [bpath addLineToPoint:point2];
        
        [fillColor set];
        [bpath fill];
        [bpath stroke];
        
    }
    
}

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _radius =  MIN(frame.size.width-2, frame.size.height-2) / 2;
        _middleRadius =  _radius - 15;
    }
    
    return self;
}

@end