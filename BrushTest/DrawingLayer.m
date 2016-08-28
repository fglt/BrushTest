//
//  DrawingLayer.m
//  BrushTest
//
//  Created by Coding on 8/7/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "DrawingLayer.h"
#import "Stroke.h"

@interface DrawingLayer()
@property (nonatomic, strong) NSMutableArray *strokes;
@property (nonatomic, strong) NSMutableArray *abandonedStrokes;
@property (nonatomic, strong) Stroke* currentStroke;
@property (nonatomic) CGContextRef context;

@end

@implementation DrawingLayer
+ (instancetype)drawingLayerWithSize:(CGSize)size
{
    DrawingLayer *layer = [[DrawingLayer alloc]initWithSize:size];
    return layer;
}

- (instancetype)initWithSize:(CGSize)size{
    self =  [super init];
    _contextSize = size;
    _blendMode = kCGBlendModeNormal;
    _visable = TRUE;
    _locked = FALSE;
    _alpha = 1;
    _strokes = [NSMutableArray array];
    _layer = [CALayer layer];
    _layer.frame = CGRectMake(0, 0, _contextSize.width, _contextSize.height);
    _activity = 1;
    _abandonedStrokes = [NSMutableArray array];
    return self;
}

- (void)clear
{
    [_strokes removeAllObjects];
    CGRect rect = CGRectMake(0, 0, _contextSize.width, _contextSize.height);
    [[UIColor clearColor] set];
    UIRectFill(rect);
    _layer.contents = nil;
}

- (void)undo
{
    if(_strokes.count<= 0) return;
    Stroke *stroke = [_strokes lastObject];
    [_strokes removeLastObject];
    [_abandonedStrokes addObject:stroke];
    CGRect rect = CGRectMake(0, 0, _contextSize.width, _contextSize.height);
    [[UIColor clearColor] set];
    UIRectFill(rect);
    for(Stroke* stroke in _strokes){
        [stroke drawInContext];
    }
    _layer.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
}

-(void)redo
{
    if(_abandonedStrokes.count<=0) return;
    Stroke *stroke = [_abandonedStrokes lastObject];
    [_abandonedStrokes removeLastObject];
    [_strokes addObject:stroke];
    [stroke drawInContext];
    _layer.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
}

- (void)newStrokeWithBrush:(Brush*)brush
{
    _currentStroke = [[Stroke alloc]initWithBrush:brush];
}

- (void)addStroke
{
    [_strokes addObject:_currentStroke];
    _currentStroke = nil;
}

- (void)updateStrokeWithPoint:(CGPoint)toPoint;
{
    [_currentStroke addPoint:toPoint];
    _layer.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
}

-(void)drawInContext
{
    for(Stroke* stroke in _strokes){
        [stroke drawInContext];
    }
}
@end
