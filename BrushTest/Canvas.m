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
    _layer = [CALayer layer];
    _layer.frame = CGRectMake(0, 0, _canvasSize.width, _canvasSize.height);
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
    canvas.layer = [CALayer layer];
    canvas.layer.frame = CGRectMake(0, 0, canvas.canvasSize.width, canvas.canvasSize.height);
    NSArray *array = dict[@"layers"];
    NSMutableArray *layerArray = [NSMutableArray array];
    UIGraphicsBeginImageContextWithOptions(canvas.canvasSize, NO, 0.0);
    for (NSDictionary *dict in array) {
        DrawingLayer *layer = [DrawingLayer drawingLayerWithDictionary:dict size:canvas.canvasSize];
        [[UIColor clearColor] set];
        UIRectFill(CGRectMake(0, 0, canvas.canvasSize.width, canvas.canvasSize.height));
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
    [self updateLayer];
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
    [self updateLayer];

}
- (void)undo
{
    [_currentDrawingLayer undo];
    [self updateLayer];
}

- (void)redo
{
    [_currentDrawingLayer redo];
    [self updateLayer];

}

- (u_long)layerCount{
    return _drawingLayers.count;
}
- (void) newStrokeIfNullWithFigureType:(FigureType)type;
{
    [_currentDrawingLayer newStrokeWithBrushIfNull:_currentBrush WithFigureType:type];
}
- (void) newStrokeWithFigureType:(FigureType)type;
{
    [_currentDrawingLayer newStrokeWithBrush:_currentBrush WithFigureType:type];
   
    //UIGraphicsBeginImageContextWithOptions(_canvasSize, NO, 0.0);
    //[_image drawAtPoint:CGPointZero];
}
- (void) addStroke
{
    [_currentDrawingLayer addStroke];
}

- (void) addPoint:(CGPoint)point
{
    [_currentDrawingLayer addPoint:point];
}
- (void) addPointAndDraw:(CGPoint)point
{
    [_currentDrawingLayer addPointAndDraw:point];
    [self updateLayer];
}
- (void)addPointsAndDraw:(NSArray *)points
{
    [_currentDrawingLayer addPointsAndDraw:points];
    [self updateLayer];
}
- (void) setCurrentDrawingLayer:(DrawingLayer *)layer
{
    if(_currentDrawingLayer != layer){
        _currentDrawingLayer = layer;
        UIGraphicsEndImageContext();
        UIGraphicsBeginImageContextWithOptions(_canvasSize, NO, 0.0);
        CGImageRef cgimage = (__bridge CGImageRef)layer.layer.contents;
        UIImage *image = [UIImage imageWithCGImage:cgimage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        [image drawAtPoint:CGPointZero];
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
    int i = 0;
    DrawingLayer *startLayer;
    for(; i<_drawingLayers.count; i++){
        startLayer = _drawingLayers[i];
        if(startLayer.visible){
            break;
        }
    }
    if(!startLayer.visible){
        startLayer = _drawingLayers[0];
    }
    DrawingLayer *newLayer = [[DrawingLayer alloc]initWithSize:_canvasSize];

    newLayer.blendMode = startLayer.blendMode;
    newLayer.locked = startLayer.locked;
    
    for(i =0; i<_drawingLayers.count; i++){
        DrawingLayer *dlayer = _drawingLayers[i];
        if(dlayer.visible){
            [newLayer addStrokes:dlayer.strokes];
        }
    }
    [_drawingLayers removeAllObjects];
    [_drawingLayers addObject:newLayer];
    _currentDrawingLayer = newLayer;
    [[UIColor clearColor]set];
    UIRectFill(CGRectMake(0, 0, _canvasSize.width, _canvasSize.height));
    [_currentDrawingLayer drawInContext];
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    _currentDrawingLayer.layer.contents = (id)image.CGImage;
     _layer.contents = (id) image.CGImage;
}

- (void)mergeCurrentToDownLayerWithIndex:(NSUInteger)index
{
    
    NSAssert(index > 0, @"index of drawing layer = 0");
    self.currentDrawingLayer = _drawingLayers[index-1];
    DrawingLayer *dlayer = _drawingLayers[index];
    if(!_currentDrawingLayer.visible){
        [_currentDrawingLayer.strokes removeAllObjects];
    }
    if(dlayer.visible){
        [_currentDrawingLayer addStrokes:dlayer.strokes];
    }
    _currentDrawingLayer.visible = true;
    _currentDrawingLayer.alpha = 1;
    [[UIColor clearColor] set];
    UIRectFill(CGRectMake(0, 0, _canvasSize.width, _canvasSize.height));
    [_currentDrawingLayer drawInContext];
    [_drawingLayers removeObjectAtIndex:index];
    _currentDrawingLayer.layer.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    [self updateLayer];
}
- (void)removeDrawingLayer:(DrawingLayer *)drawingLayer
{
    [_drawingLayers removeObject:drawingLayer];
    [self updateLayer];
}
- (NSUInteger)indexOfDrawingLayer:(DrawingLayer *)dlayer
{
    return [_drawingLayers indexOfObject:dlayer];
}

- (void)dealloc
{
    UIGraphicsEndImageContext();
}

- (void)updateLayer{
    
    UIGraphicsBeginImageContextWithOptions(_canvasSize, NO, 0.0);
    [self.backgroundColor set];
    UIRectFill(CGRectMake(0, 0, _canvasSize.width, _canvasSize.height));
    CGContextRef context = UIGraphicsGetCurrentContext();

    for(DrawingLayer *dlayer in _drawingLayers){
        if(!dlayer.visible) continue;
        CGContextSetBlendMode(context, dlayer.blendMode);
        [dlayer.layer renderInContext:context];
    }
    _layer.contents = (id) UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
}
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    [self updateLayer];
}

- (void)changeBlendModeOfCurrentDrawingLayer:(CGBlendMode)blendMode
{
    _currentDrawingLayer.blendMode = blendMode;
    [self updateLayer];
}

- (void)changeAlphaOfCurrentDrawingLayer:(CGFloat)alpha
{
    _currentDrawingLayer.alpha = alpha;
    [self updateLayer];
}
@end
