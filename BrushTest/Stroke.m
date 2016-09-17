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
    _figureType = FigureTypeNone;
    return self;
}

- (instancetype)initWithBrush:(Brush*)brush
{
    self = [self init];
    _brush = [brush copy];
    _figureType = FigureTypeNone;
    return self;
}

- (instancetype)initWithBrush:(Brush *)brush figureType:(FigureType)figureType
{
    self = [self init];
    _brush = [brush copy];
    _figureType = figureType;
    return self;
}

+ (instancetype)strokeWithDictionary:(NSDictionary *)dict
{
    Stroke *stroke=[[Stroke alloc] init];
    stroke.brush = [Brush BrushWithDictionary:dict[@"brush"]];
    stroke.figureType = [dict[@"FigureType"] integerValue];
    NSArray *p = dict[@"points"];
    NSMutableArray *points = [NSMutableArray array];
    for (NSString *pstr in p) {
        NSValue *value = [NSValue valueWithCGPoint:CGPointFromString(pstr)];
        [points addObject:value];
    }
    stroke.points = points;
    return stroke;
}

- (void)drawInContext
{
    if(_figureType == FigureTypeNone || _figureType == FigureTypeLine || _figureType == FigureTypeRectangle){
    CGPoint toPoint;
    CGPoint fromPoint;
    if(_points.count<1) return;
    [_points[0] getValue:&fromPoint];
    [_brush clear];
    if(_points.count==1){
        toPoint = fromPoint;
        [_brush drawFromPoint:fromPoint toPoint:toPoint];
    }
    for(int i=1; i<_points.count; i++){
        [_points[i] getValue:&toPoint];
        [_brush drawFromPoint:fromPoint toPoint:toPoint];
        fromPoint = toPoint;
    }
    }else{
        [_brush drawWithPoints:_points];
    }
}

- (void)addPoint:(CGPoint)point
{
    NSValue* pointValue = [NSValue valueWithCGPoint:point];
    [_points addObject:pointValue];
}

- (void)addPointsAndDraw:(NSArray *)points
{
    [_points addObjectsFromArray:points];
    [self drawInContext];
}

- (void)addPointAndDraw:(CGPoint)point
{
    NSValue* pointValue = [NSValue valueWithCGPoint:point];
    CGPoint fromPoint;
    if(_points.count ==0){
        fromPoint = point;
        [_brush drawFromPoint:fromPoint toPoint:point];
        [_points addObject:pointValue];
    }
    else {
        [[_points lastObject] getValue:&fromPoint];
    
        if(ccpFuzzyEqual(fromPoint, point, kBrushPixelStep)){
            if(_points.count==1){
                [_brush drawFromPoint:fromPoint toPoint:point];
            }
            return;
        }
        [_brush drawFromPoint:fromPoint toPoint:point];
        [_points addObject:pointValue];
    }

}

BOOL ccpFuzzyEqual(CGPoint a, CGPoint b, float var)
{
    if(a.x - var <= b.x && b.x <= a.x + var)
        if(a.y - var <= b.y && b.y <= a.y + var)
            return true;
    return false;
}

- (NSDictionary *)dictionary
{
    NSMutableArray *stringArray = [NSMutableArray array];
    for(NSValue *value in _points){
        CGPoint point;
        [value getValue:&point];
        [stringArray addObject:NSStringFromCGPoint(point)];
    }
    NSDictionary *dict = @{@"brush":_brush.dictionary, @"points":stringArray, @"FigureType":[NSNumber numberWithInteger:_figureType]};
    return dict;
}
@end
