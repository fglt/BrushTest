//
//  DrawingLayer.h
//  BrushTest
//
//  Created by Coding on 8/7/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Brush;

@interface DrawingLayer : NSObject
@property (nonatomic) CGBlendMode blendMode;
@property (nonatomic) BOOL visible;
@property (nonatomic) BOOL locked;
@property (nonatomic) CGFloat alpha;
//@property (nonatomic) BOOL activity;
@property (nonatomic, strong) CALayer *layer;

//- (UIImage *)imageFromeContext;
- (void)newStrokeWithBrush:(Brush*)brush;
- (void)addStroke;
- (instancetype)initWithSize:(CGSize)size;
- (void)updateStrokeWithPoint:(CGPoint)toPoint;
- (void)clear;
- (void)redo;
- (void)undo;
+ (instancetype)drawingLayerWithSize:(CGSize)size;
+ (instancetype)drawingLayerWithDictionary:(NSDictionary *)dict size:(CGSize)size;

-(void)drawInContext;

- (NSDictionary *)dictionary;
@end
