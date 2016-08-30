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
#import "UIColor+FGTColor.h"

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
    //UIGraphicsBeginImageContextWithOptions(_canvasSize, NO, 0.0);
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
    UIGraphicsEndImageContext();
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

- (void)addLayerAboveCurrentDrawingLayer
{
    DrawingLayer *layer = [DrawingLayer drawingLayerWithSize:_canvasSize];
    NSUInteger index = [_drawingLayers indexOfObject:_currentDrawingLayer];
    [_drawingLayers insertObject:layer atIndex:index+1];
    self.currentDrawingLayer = layer;
}

- (void)clear
{
    [_currentDrawingLayer clear];
    _image = nil;
}
- (void)undo
{
    [_currentDrawingLayer undo];
    CGImageRef cgimage = (__bridge CGImageRef)_currentDrawingLayer.layer.contents;
    _image = [UIImage imageWithCGImage:cgimage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

- (void)redo
{
    [_currentDrawingLayer redo];
}

- (u_long)layerCount{
    return _drawingLayers.count;
}

- (void) newStroke
{
    [_currentDrawingLayer newStrokeWithBrush:_currentBrush];
    UIGraphicsBeginImageContextWithOptions(_canvasSize, NO, 0.0);
    [_image drawAtPoint:CGPointZero];
}
- (void) addStroke
{
    [_currentDrawingLayer addStroke];
    CGImageRef cgimage = (__bridge CGImageRef)_currentDrawingLayer.layer.contents;
    _image = [UIImage imageWithCGImage:cgimage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

- (void) addPoint:(CGPoint)point
{
    [_currentDrawingLayer updateStrokeWithPoint:point];
}

- (void) setCurrentDrawingLayer:(DrawingLayer *)layer
{
    if(_currentDrawingLayer != layer){
        _currentDrawingLayer = layer;
         UIGraphicsEndImageContext();
        UIGraphicsBeginImageContextWithOptions(_canvasSize, NO, 0.0);
        [_currentDrawingLayer drawInContext];
        _image = UIGraphicsGetImageFromCurrentImageContext();
        layer.layer.contents = (id)_image.CGImage;
    }
}

- (NSDictionary *)dictionary
{
    NSMutableArray *layerArray= [NSMutableArray array];
    for (DrawingLayer *layer in _drawingLayers) {
        NSDictionary *dict = layer.dictionary;
        [layerArray addObject:dict];
    }
    NSDictionary *dict = @{ @"name":_canvasName, @"size":NSStringFromCGSize(_canvasSize), @"color":[_backgroundColor number], @"brush":_currentBrush.dictionary, @"layers":layerArray};
    return dict;
}

- (void)mergeAllLayers
{
    self.currentDrawingLayer = _drawingLayers[0];
    while (_drawingLayers.count >1) {
        DrawingLayer *dlayer = _drawingLayers[1];
        CGImageRef cgimage = (__bridge CGImageRef)dlayer.layer.contents;
        UIImage *image = [UIImage imageWithCGImage:cgimage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        [image drawAtPoint:CGPointZero blendMode:dlayer.blendMode alpha:dlayer.alpha];
        [dlayer.layer removeFromSuperlayer];
        [_drawingLayers removeObjectAtIndex:1];
    }
    _currentDrawingLayer.layer.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
}

- (void)mergeCurrentToDownLayerWithIndex:(NSUInteger)index
{
    NSAssert(index > 0, @"index of drawing layer = 0");
    self.currentDrawingLayer = _drawingLayers[index-1];
    DrawingLayer *dlayer = _drawingLayers[index];
    CGImageRef cgimage = (__bridge CGImageRef)dlayer.layer.contents;
    UIImage *image = [UIImage imageWithCGImage:cgimage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    [image drawAtPoint:CGPointZero blendMode:dlayer.blendMode alpha:dlayer.alpha];
    [dlayer.layer removeFromSuperlayer];
    [_drawingLayers removeObjectAtIndex:index];
    _currentDrawingLayer.layer.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
}

- (NSUInteger) indexOfDrawingLayer:(DrawingLayer *)dlayer
{
    return [_drawingLayers indexOfObject:dlayer];
}
@end
