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
    _abandonedStrokes = [NSMutableArray array];
    UIGraphicsBeginImageContextWithOptions(_contextSize, NO, 0.0);
    _context = UIGraphicsGetCurrentContext();
    _image = UIGraphicsGetImageFromCurrentImageContext();
    return self;
}

- (void)clear
{
    [_strokes removeAllObjects];
    CGRect rect = CGRectMake(0, 0, _contextSize.width, _contextSize.height);
    [[UIColor clearColor] set];
    UIRectFill(rect);
    //UIGraphicsEndImageContext();
    //UIGraphicsBeginImageContextWithOptions(_contextSize, NO, 0.0);
    //_context = UIGraphicsGetCurrentContext();
    _image = UIGraphicsGetImageFromCurrentImageContext();
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
        [stroke drawInContext:_context];
    }
    _image = UIGraphicsGetImageFromCurrentImageContext();
}

-(void)redo
{
    if(_abandonedStrokes.count<=0) return;
    Stroke *stroke = [_abandonedStrokes lastObject];
    [_abandonedStrokes removeLastObject];
    [_strokes addObject:stroke];
    [stroke drawInContext:_context];
    _image = UIGraphicsGetImageFromCurrentImageContext();
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
    [_currentStroke addPoint:toPoint inContext:_context];
    _image = UIGraphicsGetImageFromCurrentImageContext();
}

- (void)setActivity:(BOOL)activity
{
    _activity = activity;
    if(_activity){
        UIGraphicsEndImageContext();
        self.context = nil;
    }else{
        UIGraphicsBeginImageContextWithOptions(_contextSize, NO, 0.0);
        _context = UIGraphicsGetCurrentContext();
    }
}
@end
