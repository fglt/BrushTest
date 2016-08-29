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
    _backgroundColor = [UIColor whiteColor];
    _drawingLayers = [NSMutableArray array];
     _currentDrawingLayer = [DrawingLayer drawingLayerWithSize:_canvasSize];
    [_drawingLayers addObject:_currentDrawingLayer];
    _currentBrush = [Brush BrushWithColor:[UIColor redColor] width:26 type:BrushTypeCircle];
    UIGraphicsBeginImageContextWithOptions(_canvasSize, NO, 0.0);
    return self;
}

+ (instancetype) canvasWithDictionary:(NSDictionary *)dict
{
    Canvas* canvas = [[Canvas alloc] init];
    canvas.canvasName = dict[@"name"];
    canvas.canvasSize = CGSizeFromString(dict[@"size"]);
    uint32_t i = [dict[@"color"] unsignedIntValue];
    canvas.backgroundColor = [UIColor colorWithUint32:i];
    canvas.currentBrush = [Brush BrushWithDictionary:dict[@"brush"]];
    NSArray *array = dict[@"layers"];
    NSMutableArray *layerArray = [NSMutableArray array];
   UIGraphicsBeginImageContextWithOptions(canvas.canvasSize, NO, 0.0);
    for (NSDictionary *dict in array) {
        DrawingLayer *layer = [DrawingLayer drawingLayerWithDictionary:dict size:canvas.canvasSize];
        [[UIColor clearColor] set];
        UIRectFill(CGRectMake(0, 0, canvas.canvasSize.width, canvas.canvasSize.height));
        [layer drawInContext];
        [layerArray addObject:layer];
    }
    canvas.drawingLayers = layerArray;
    
    canvas.currentDrawingLayer = canvas.drawingLayers[canvas.drawingLayers.count-1];
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
    if(!_currentDrawingLayer){
        _currentDrawingLayer = layer;
        return;
    }
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
    NSDictionary *dict = @{ @"name":_canvasName, @"size":NSStringFromCGSize(_canvasSize), @"color":[UIColor numberFromRGBAColor:_backgroundColor], @"brush":_currentBrush.dictionary, @"layers":layerArray};
    return dict;
}
@end
