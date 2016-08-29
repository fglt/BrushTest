//
//  Canvas.m
//  BrushTest
//
//  Created by Coding on 8/23/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "Canvas.h"
#import "DrawingLayer.h"
#import "Brush.h"
#import "UIColor+BFPaperColors.h"

@implementation Canvas

- (instancetype)initWithSize:(CGSize)size
{
    self= [super init];
    _canvasName = [NSString stringWithFormat:@"%@",[NSDate date]];
    _canvasSize = size;
    _drawingLayers = [NSMutableArray array];
    UIGraphicsBeginImageContextWithOptions(_canvasSize, NO, 0.0);
    return self;
}

+ (instancetype) canvasWithDictionary:(NSDictionary *)dict
{
    Canvas* canvas = [[Canvas alloc] init];
    canvas.canvasName = dict[@"name"];
    CGSize size;
    [dict[@"size"] getValue:&size];
    canvas.canvasSize = size;
    canvas.backgroundColor = UIColorFromRGBA([dict[@"color"] integerValue]);
    NSMutableArray *array = dict[@"layers"];
    for (NSDictionary *dict in array) {
        DrawingLayer *layer = [DrawingLayer drawingLayerWithDictionary:dict size:size];
        [array addObject:layer];
    }
    canvas.drawingLayers = array;
    return canvas;
}

- (instancetype)initWithSize:(CGSize)size backgroundColor:(UIColor *)color
{
    self=  [self initWithSize:size];
    _backgroundColor = color;
    return self;
}
- (void)addLayer:(DrawingLayer *)layer
{
    [_drawingLayers addObject:layer];
    self.currentDrawingLayer = layer;
}

- (void)addLayer
{
    DrawingLayer *layer = [DrawingLayer drawingLayerWithSize:_canvasSize];
    [self addLayer:layer];
    self.currentDrawingLayer = layer;
}

- (void)clear
{
    [_currentDrawingLayer clear];
}
- (void)undo
{
    [_currentDrawingLayer undo];
}

- (void)redo
{
    [_currentDrawingLayer redo];
}

- (u_long)layerCount{
    return _drawingLayers.count;
}

- (void) updateWithPoint:(CGPoint)point
{
    [_currentDrawingLayer updateStrokeWithPoint:point];
}

- (void) setCurrentDrawingLayer:(DrawingLayer *)layer
{
    if(_currentDrawingLayer != layer){
        _currentDrawingLayer = layer;
        UIGraphicsEndImageContext();
        UIGraphicsBeginImageContextWithOptions(_canvasSize, NO, 0.0);
        [_currentDrawingLayer.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
}

- (NSDictionary *)dictionary
{
    NSMutableArray *layerArray= [NSMutableArray array];
    for (DrawingLayer *layer in _drawingLayers) {
        NSDictionary *dict = layer.dictionary;
        [layerArray addObject:dict];
    }
    NSDictionary *dict = @{@"size":[NSValue valueWithCGSize:_canvasSize], @"color":[UIColor hexStringFromRGBAColor:_backgroundColor], @"layers":layerArray, @"name":_canvasName};
    return dict;
}
@end
