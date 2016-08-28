//
//  UIBezierPath+Brush.m
//  BrushTest
//
//  Created by Coding on 8/14/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "UIBezierPath+Brush.h"

@implementation UIBezierPath (Brush)
+ (UIBezierPath*)roundBezierPathWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint width:(CGFloat)width
{
    UIBezierPath* bpath = [UIBezierPath bezierPath];
    
    CGFloat deltax = (endPoint.x - startPoint.x)>=0 ? 1:-1;
    CGFloat deltay = (endPoint.y - startPoint.y)>=0 ? 1:-1;
    [bpath moveToPoint:startPoint];
    [bpath addLineToPoint:CGPointMake(endPoint.x - deltax , endPoint.y -deltay)];
    bpath.lineWidth = width;
    bpath.lineCapStyle = kCGLineCapRound;
    bpath.lineJoinStyle = kCGLineJoinRound;
    return bpath;
}

+ (UIBezierPath*)roundBezierPathWithStartPoint:(CGPoint)startPoint width:(CGFloat)width
{
    UIBezierPath* bpath = [UIBezierPath bezierPath];
    
    [bpath moveToPoint:startPoint];
    bpath.lineWidth = width;
    bpath.lineCapStyle = kCGLineCapRound;
    bpath.lineJoinStyle = kCGLineJoinRound;
    return bpath;
}
@end
