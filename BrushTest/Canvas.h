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

@property (nonatomic, strong) NSString *canvasName;
@property (nonatomic, strong) Brush* currentBrush;
@property (nonatomic) CGSize canvasSize;
@property (nonatomic, strong) NSMutableArray *drawingLayers;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) DrawingLayer *currentDrawingLayer;
- (void)clear;
- (void)undo;
- (void)redo;
- (void)addLayer:(DrawingLayer *)layer;
- (void)addLayer;
- (void)addLayerAboveCurrentDrawingLayer;
- (instancetype)initWithSize:(CGSize)size;
- (instancetype)initWithSize:(CGSize)size backgroundColor:(UIColor *)color;
- (void) updateWithPoint:(CGPoint)point;
- (void) addStroke;
- (NSDictionary *)dictionary;
+ (instancetype) canvasWithDictionary:(NSDictionary *)dict;
- (void)mergeAllLayers;
- (void)mergeCurrentToDownLayerWithIndex:(NSUInteger)index;
- (NSUInteger) indexOfDrawingLayer:(DrawingLayer *)dlayer;
@end
