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
    [self addLayer];
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
    _foreLayer = layer;
}

- (void)addLayer
{
    DrawingLayer *layer = [DrawingLayer drawingLayerWithSize:_canvasSize];
    [_drawingLayers addObject:layer];
    _foreLayer = layer;
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

- (UIImage *)imageFromContext;
{
    CGRect rect = CGRectMake(0, 0, _canvasSize.width, _canvasSize.height);
    UIGraphicsBeginImageContextWithOptions(_canvasSize, NO, 0.0);
    [_backgroundColor set];
    UIRectFill(rect);
    
    for(DrawingLayer *layer in _drawingLayers){
        if(layer.visable){
            [layer.image drawInRect:rect blendMode:layer.blendMode alpha:layer.alpha];
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(u_long)layerCount{
    return _drawingLayers.count;
}

- (void) updateWithPoint:(CGPoint)point
{
    [_foreLayer updateStrokeWithPoint:point];
    _image = [self imageFromContext];
}
@end
