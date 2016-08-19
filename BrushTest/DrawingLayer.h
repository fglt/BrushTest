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
@property (nonatomic) CGSize contextSize;

- (void)undo;
- (UIImage *)imageFromeContext;
- (void)newStrokeWithBrush:(Brush*)brush;
- (void)addStroke;
- (instancetype)initWithSize:(CGSize)size;
- (void)updateStrokeWithPoint:(CGPoint)toPoint;
- (void)clear;
- (void)redo;
@end
