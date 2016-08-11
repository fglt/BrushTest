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
@property (nonatomic, strong) Brush* currentBrush;
@end
@implementation CanvasView


-(void)awakeFromNib
{
    [super awakeFromNib];
    _currentBrush = [[Brush alloc] init];
    _currentBrush.brushType = BrushTypeChineseBrush;
    _currentBrush.radius = 13;
    _currentBrush.color = [UIColor colorWithWhite:0 alpha:1];
    _drawingLayer =[[DrawingLayer alloc]initWithSize:[UIScreen mainScreen].bounds.size];
}

- (IBAction)clickClearButton:(UIButton *)sender {
    [_drawingLayer clear];
    self.image = nil;
}
- (IBAction)clickUndoButton:(UIButton *)sender {
    [_drawingLayer removeLastStroke];
    self.image = [_drawingLayer imageFromeContext];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    //[_drawingLayer newStroke];
    [_drawingLayer newStrokeWithBrush:_currentBrush];
    UITouch* touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [_drawingLayer updateStrokeWithPoint:p];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [_drawingLayer updateStrokeWithPoint:p];
    [_drawingLayer update];
    self.image = [_drawingLayer imageFromeContext];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_drawingLayer addStroke];
}
@end
