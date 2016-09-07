//
//  DrawingLayer.h
//  BrushTest
//
//  Created by Coding on 8/7/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Brush;

@interface DrawingLayer : NSObject<NSCopying>
@property (nonatomic) CGBlendMode blendMode;
@property (nonatomic) BOOL visible;
@property (nonatomic) BOOL locked;
@property (nonatomic) CGFloat alpha;
//@property (nonatomic) BOOL activity;
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, strong, readonly) NSMutableArray *strokes;

- (void)newStrokeWithBrushIfNull:(Brush *)brush;
- (void)newStrokeWithBrush:(Brush*)brush;
- (void)addStroke;
- (void)addStrokes:(NSArray *)strokes;
- (instancetype)initWithSize:(CGSize)size;
- (void)addPointAndDraw:(CGPoint)toPoint;
- (void)addPoint:(CGPoint)toPoint;
- (void)clear;
- (void)redo;
- (void)undo;
+ (instancetype)drawingLayerWithSize:(CGSize)size;
+ (instancetype)drawingLayerWithDictionary:(NSDictionary *)dict size:(CGSize)size;

-(void)drawInContext;

- (NSDictionary *)dictionary;
@end
