//
//  CircleColcorPicker.m
//  Drawing
//
//  Created by Coding on 6/8/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "CircleColcorPicker.h"
#import "InfColorIndicatorView.h"
#import "FGTHSBSupport.h"
#define kContentInsetX 20
#define kIndicatorSize 24.0

const double PI2 = 2*M_PI;
@interface CircleColcorPicker()
@property  (nonatomic) CGFloat indicatorDistanceToCenter;
@end

IB_DESIGNABLE
@implementation CircleColcorPicker{
    InfColorIndicatorView* indicator;
    UIImage *circleImage;
}


- (UIImage *)hueCircleImage
{
    UIImage *image;
    CGRect rect = self.frame;
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *bpath;
    float r = center.x - 1;
    
    CGPoint point1 = CGPointMake(center.x + r, center.y);
    CGPoint point2;
    register const CGFloat unitTheta = M_PI/180;
    const CGFloat unitHue = 1/360.0;
    CGFloat theta = unitTheta;
    CGFloat hue = 0;
    
   
    for (int i = 0; i < 360 ; i++)
    {
        UIColor *color = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
        bpath = [UIBezierPath bezierPath];
        point2 = CGPointMake(center.x + r*cos(theta), center.y - r*sin(theta));
        
        [bpath moveToPoint:self.center];
        [bpath addLineToPoint:point1];
        [bpath addLineToPoint:point2];

        [color set];
        [bpath fill];
        [bpath stroke];
        point1 = point2;
        theta += unitTheta;
        hue  += unitHue;
    }
    
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    r = r - 40;
    UIColor *fillColor = [UIColor clearColor];
    
    bpath = [UIBezierPath bezierPathWithArcCenter:center radius:r startAngle:0 endAngle:M_PI *2 clockwise:YES];
    [fillColor set];
    [bpath fill];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void) layoutSubviews
{
    if(circleImage == nil){
        circleImage = [self hueCircleImage];
        self.layer.contents = (id)circleImage.CGImage;
    }
    if (indicator == nil) {        
        indicator = [[InfColorIndicatorView alloc] initWithFrame: CGRectMake(0, 0, kIndicatorSize, kIndicatorSize)];
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
    CGFloat indicatorDistanceToCenter = self.frame.size.width/2 -16;
    CGFloat alpha = asin( (pcenter.y - _value.y)/indicatorDistanceToCenter );
    
    if(_value.x-pcenter.x >= 0 )
    {
        if(alpha < 0)
        {
            alpha = PI2 + alpha ;
        }
    }else
        alpha =  M_PI - alpha ;
    _hue = alpha/PI2 ;
    //NSLog(@"hue: %f", _hue );
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
        CGFloat indicatorDistanceToCenter = self.frame.size.width/2 -16;
        CGFloat  y =  CGRectGetMidY(self.bounds) - indicatorDistanceToCenter * sin(_hue * PI2);
        CGFloat x =  CGRectGetMidX(self.bounds) + indicatorDistanceToCenter * cos(_hue * PI2);
        [self setValue:CGPointMake(x, y)];
        // NSLog(@"center: %f,  %f", x, y);
    }
}

- (void) trackIndicatorWithTouch: (UITouch*) touch
{
    CGFloat indicatorDistanceToCenter = self.frame.size.width/2 -16;
    CGPoint point = [touch locationInView: self];
    CGFloat sy = CGRectGetMidY(self.bounds);
    CGFloat sx = CGRectGetMidX(self.bounds);
    
    CGFloat dis = sqrt((sx-point.x)*(sx-point.x) + (sy-point.y)*(sy-point.y));
    
    self.value =  CGPointMake(sx + (indicatorDistanceToCenter / dis) * (point.x-sx), sy + (indicatorDistanceToCenter / dis) * (point.y-sy));
    
    // NSLog(@"point: %f, y: %f", point.x, point.y);
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
