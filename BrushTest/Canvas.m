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

@implementation Canvas

- (instancetype)initWithSize:(CGSize)size
{
    self= [super init];
    self.canvasSize = size;
    _drawingLayers = [NSMutableArray array];
    UIGraphicsBeginImageContextWithOptions(_canvasSize, NO, 0.0);
    return self;
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
    self.foreLayer = layer;
}

- (void)addLayer
{
    DrawingLayer *layer = [DrawingLayer drawingLayerWithSize:_canvasSize];
    [self addLayer:layer];
    self.foreLayer = layer;
}

- (void)clear
{
    [_foreLayer clear];
}
- (void)undo
{
    [_foreLayer undo];
}

- (void)redo
{
    [_foreLayer redo];
}

- (u_long)layerCount{
    return _drawingLayers.count;
}

- (void) updateWithPoint:(CGPoint)point
{
    [_foreLayer updateStrokeWithPoint:point];
}

- (void) setForeLayer:(DrawingLayer *)foreLayer
{
    if(_foreLayer != foreLayer){
        _foreLayer.activity = false;

        _foreLayer = foreLayer;
        UIGraphicsEndImageContext();
        UIGraphicsBeginImageContextWithOptions(_canvasSize, NO, 0.0);
        [_foreLayer.layer renderInContext:UIGraphicsGetCurrentContext()];
        _foreLayer.activity = true;
    }
}
@end
