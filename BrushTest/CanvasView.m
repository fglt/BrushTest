//
//  BrushView.m
//  BrushTest
//
//  Created by Coding on 8/5/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "CanvasView.h"
#import "DrawingLayer.h"
#import "Canvas.h"

@interface CanvasView()
@end
@implementation CanvasView

- (void)addLayer:(DrawingLayer *)layer
{
    [_canvas addLayer:layer];
    [self.layer addSublayer:layer.layer];
}
- (void)addLayer
{
    [_canvas addLayer];
    [self.layer addSublayer:_canvas.foreLayer.layer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_canvas.foreLayer newStrokeWithBrush:_canvas.currentBrush];
    UITouch* touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [_canvas updateWithPoint:p];
    [self displayContent];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [_canvas updateWithPoint:p];
    [self displayContent];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_canvas.foreLayer addStroke];
}

- (void)displayContent
{
   // self.layer.contents = (id)_canvas.image.CGImage;
}

- (void)setForelayer:(DrawingLayer *)layer
{
    [_canvas setForeLayer:layer];
    
}
@end
