//
//  Canvas.h
//  BrushTest
//
//  Created by Coding on 8/23/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
@class  Brush;
@class DrawingLayer;

@interface Canvas : NSObject

@property (nonatomic, strong) NSString *canvasName;
@property (nonatomic, strong) Brush* currentBrush;
@property (nonatomic) CGSize canvasSize;
@property (nonatomic, strong) NSMutableArray *drawingLayers;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) DrawingLayer *currentDrawingLayer;
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, weak) UIView *view;
- (void)clear;
- (void)undo;
- (void)redo;
- (void)addLayer:(DrawingLayer *)layer;
- (void)addLayer;
- (void)addLayerAboveCurrentDrawingLayer;
- (instancetype)initWithSize:(CGSize)size;
- (instancetype)initWithSize:(CGSize)size backgroundColor:(UIColor *)color;
- (void) newStroke;
- (void) newStrokeIfNull;
- (void) addPoint:(CGPoint)point;
- (void) addPointAndDraw:(CGPoint)point;
- (void) addStroke;
- (NSDictionary *)dictionary;
+ (instancetype) canvasWithDictionary:(NSDictionary *)dict;
- (void)mergeAllLayers;
- (void)mergeCurrentToDownLayerWithIndex:(NSUInteger)index;
- (NSUInteger) indexOfDrawingLayer:(DrawingLayer *)dlayer;
- (void)updateLayer;
@end
