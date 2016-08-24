//
//  Canvas.h
//  BrushTest
//
//  Created by Coding on 8/23/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  Brush;
@class DrawingLayer;

@interface Canvas : NSObject

@property (nonatomic, strong) Brush* currentBrush;
@property (nonatomic) CGSize canvasSize;
@property (nonatomic, readonly) u_long layerCount;

@property (nonatomic, strong) NSMutableArray *drawingLayers;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) DrawingLayer *foreLayer;
@property (nonatomic, strong) UIImage *image;

- (void)clear;
- (void)undo;
- (void)redo;
- (void)addLayer:(DrawingLayer *)layer;
- (void)addLayer;
- (instancetype)initWithSize:(CGSize)size;
- (instancetype)initWithSize:(CGSize)size backgroundColor:(UIColor *)color;
- (void) updateWithPoint:(CGPoint)point;
@end
