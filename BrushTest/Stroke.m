//
//  Stroke.m
//  BrushTest
//
//  Created by Coding on 8/11/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "Stroke.h"
#import "Brush.h"

static CGFloat const  MinWidth = 5;
static CGFloat const  MaxWidth = 13;
static CGFloat const  MinLength = 20;
static CGFloat const  MaxLength = MinLength *MaxWidth/MinWidth + MinLength;
static CGFloat const  DeltaWidth = 0.05;

@implementation Path

@end

@implementation Stroke

-(instancetype)init
{
    self = [super init];
    _points = [NSMutableArray array];
    return self;
}

-(instancetype)initWithBrush:(Brush*)brush
{
    self = [self init];
    _brush = [brush copy];
    return self;
}

-(void) drawInContext:(CGContextRef)context
{
    CGPoint toPoint;
    CGPoint fromPoint;
    switch (_brush.brushType) {
        case BrushTypeChineseBrush:
            [_points[0] getValue:&fromPoint];
            for(int i=1; i<_points.count; i++){
                [_points[i] getValue:&toPoint];
                [self updateChineseBrushInContext:context FromPoint:fromPoint toPoint:toPoint];
                fromPoint = toPoint;
            }
            break;
            
        default:
            break;
    }
}

-(void) updateInContext:(CGContextRef)context
{
    CGPoint toPoint;
    CGPoint fromPoint;
    switch (_brush.brushType) {
        case BrushTypeChineseBrush:
            [[_points lastObject] getValue:&toPoint];
            if(_points.count == 1){
                fromPoint = toPoint;
            }else{
                [[_points objectAtIndex:_points.count-2] getValue:&fromPoint];
            }
            [self updateChineseBrushInContext:context FromPoint:fromPoint toPoint:toPoint];
            break;
            
        default:
            break;
    }
    
}

-(void) addPoint:(CGPoint)point inContext:(CGContextRef)context
{
    NSValue* pointValue = [NSValue valueWithCGPoint:point];
    [_points addObject:pointValue];
    [self updateInContext:context];
}

-(void) updateChineseBrushInContext:(CGContextRef)context FromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    int len  = (int)(sqrt( pow(fromPoint.x-toPoint.x,2) + pow(fromPoint.y-toPoint.y,2)) );
    
    len = MIN(len, MaxLength);
    if(len == 0){
        UIBezierPath* bpath = [UIBezierPath bezierPathWithArcCenter:fromPoint radius:_brush.radius/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [[self curColor] set];
        [bpath fill];
        return;
    }
    
    CGFloat aimWidth = MinLength * MaxWidth/len ;
    NSArray* points = [self ArrayFromPoint:fromPoint toPoint:toPoint WithCount:len];
    CGPoint lastPoint =fromPoint;
    CGPoint curPoint;
    for(int i = 0; i<points.count; i++){
        [points[i] getValue:&curPoint];
        UIBezierPath* bpath = [self newBezierPathWithStartPoint:lastPoint endPoint:curPoint];
        [[self curColor] set];
        [bpath stroke];
        if( _brush.radius > aimWidth) {
            _brush.radius -= DeltaWidth;
        }else{
            _brush.radius += DeltaWidth;
        }
        _brush.radius = MAX(MIN(_brush.radius, MaxWidth), MinWidth);
        lastPoint = curPoint;
    }
}

-(UIColor*)curColor{
    return [UIColor colorWithWhite:0 alpha:0.1 + (_brush.radius-MinWidth)/(MaxWidth -MinWidth)*0.3 ];
}

-(UIBezierPath*)newBezierPathWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    UIBezierPath* bpath = [UIBezierPath bezierPath];
    [bpath moveToPoint:startPoint];
    [bpath addLineToPoint:endPoint];
    bpath.lineWidth = _brush.radius;
    bpath.lineCapStyle = kCGLineCapRound;
    bpath.lineJoinStyle = kCGLineJoinRound;
    return bpath;
}

-(NSMutableArray*) ArrayFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint WithCount:(int)count
{
    NSMutableArray *array = [NSMutableArray array];
    CGFloat delx = (toPoint.x -fromPoint.x)/count;
    CGFloat dely = (toPoint.y -fromPoint.y)/count;
    CGPoint  prePoint = fromPoint;
    for(int i= 0; i< count; i++){
        prePoint.x += delx;
        prePoint.y += dely;
        [array addObject:[NSValue valueWithCGPoint:prePoint]];
    }
    
    return array;
}

@end