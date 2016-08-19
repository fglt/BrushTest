//
//  BrushView.m
//  BrushTest
//
//  Created by Coding on 8/5/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "CanvasView.h"
#import "DrawingLayer.h"
#import "Brush.h"

@interface CanvasView()

@property (nonatomic, strong) DrawingLayer* drawingLayer;

@end
@implementation CanvasView


-(void)awakeFromNib
{
    [super awakeFromNib];
    _drawingLayer =[[DrawingLayer alloc]initWithSize:[UIScreen mainScreen].bounds.size];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:)
//                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)clear
{
    [_drawingLayer clear];
    self.image = nil;
}
- (void)clickUndo
{
    [_drawingLayer removeLastStroke];
    self.image = [_drawingLayer imageFromeContext];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_drawingLayer newStrokeWithBrush:_currentBrush];
    UITouch* touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [_drawingLayer updateStrokeWithPoint:p];
    self.image = [_drawingLayer imageFromeContext];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [_drawingLayer updateStrokeWithPoint:p];
    self.image = [_drawingLayer imageFromeContext];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_drawingLayer addStroke];
}
@end
