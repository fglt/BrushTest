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
    _items = [NSMutableArray array];
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
            [_items[0] getValue:&fromPoint];
            for(int i=1; i<_items.count; i++){
                [_items[i] getValue:&toPoint];
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
            [[_items lastObject] getValue:&toPoint];
            [[_items objectAtIndex:_items.count-2] getValue:&fromPoint];
            [self updateChineseBrushInContext:context FromPoint:fromPoint toPoint:toPoint];
            break;
            
        default:
            break;
    }
    
}

-(void) addPoint:(CGPoint)point
{
    NSValue* pointValue = [NSValue valueWithCGPoint:point];
    [_items addObject:pointValue];
}

-(void) updateChineseBrushInContext:(CGContextRef)context FromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    int len  = (int)(sqrt( pow(fromPoint.x-toPoint.x,2) + pow(fromPoint.y-toPoint.y,2)) );
    
    len = MIN(len, MaxLength);
    if(len == 0) return;
    
    CGFloat aimWidth = MinLength * MaxWidth/len ;
    NSArray* points = [self ArrayFromPoint:fromPoint toPoint:toPoint WithCount:len];
    CGPoint lastPoint =fromPoint;
    
    for(int i = 0; i<points.count; i++){
        
        CGPoint point = CGPointFromString(points[i]);
        UIBezierPath* bpath = [self newBezierPathWithStartPoint:lastPoint endPoint:point];
        Path* path = [[Path alloc]init];
        path.color = [self curColor];
        path.path = bpath;
        
        [path.color set];
        [path.path stroke];
        if( _brush.radius > aimWidth) {
            _brush.radius -= DeltaWidth;
        }else{
            _brush.radius += DeltaWidth;
        }
        _brush.radius = MAX(MIN(_brush.radius, MaxWidth), MinWidth);
        lastPoint = point;
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

-(NSArray*) ArrayFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint WithCount:(int)count
{
    NSMutableArray *array = [NSMutableArray array];
    CGFloat delx = (toPoint.x -fromPoint.x)/count;
    CGFloat dely = (toPoint.y -fromPoint.y)/count;
    CGPoint  prePoint = fromPoint;
    for(int i= 0; i< count; i++){
        CGFloat px = prePoint.x + delx;
        CGFloat py = prePoint.y + dely;
        prePoint = CGPointMake(px, py);
        [array addObject:NSStringFromCGPoint(prePoint)];
    }
    
    return array;
}

@end