//
//  Stroke.m
//  BrushTest
//
//  Created by Coding on 8/11/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "Stroke.h"
#import "Brush.h"

@implementation Stroke

- (instancetype)init
{
    self = [super init];
    _points = [NSMutableArray array];
    return self;
}

- (instancetype)initWithBrush:(Brush*)brush
{
    self = [self init];
    _brush = [brush copy];
    return self;
}

- (void)drawInContext
{
    CGPoint toPoint;
    CGPoint fromPoint;
    [_points[0] getValue:&fromPoint];
    [_brush clear];
    for(int i=1; i<_points.count; i++){
        [_points[i] getValue:&toPoint];
        [_brush drawFromPoint:fromPoint toPoint:toPoint];
        fromPoint = toPoint;
    }
}

- (void)addPoint:(CGPoint)point
{
    NSValue* pointValue = [NSValue valueWithCGPoint:point];
    CGPoint fromPoint;
    if(_points.count ==0) fromPoint = point;
    else [[_points lastObject] getValue:&fromPoint];
    [_brush drawFromPoint:fromPoint toPoint:point];
    [_points addObject:pointValue];
}

@end