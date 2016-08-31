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
@property (nonatomic, strong) NSMutableArray *abandonedStrokes;
@property (nonatomic, strong) Stroke* currentStroke;
@end

@implementation DrawingLayer
+ (instancetype)drawingLayerWithSize:(CGSize)size
{
    DrawingLayer *layer = [[DrawingLayer alloc]initWithSize:size];
    return layer;
}

+ (instancetype)drawingLayerWithDictionary:(NSDictionary *)dict size:(CGSize)size
{
    NSMutableArray *strokes = [NSMutableArray array];
    NSArray *strokedict =dict[@"strokes"];
    for(NSDictionary *dict in strokedict){
        Stroke *stroke = [Stroke strokeWithDictionary:dict];
        [strokes addObject:stroke];
    }
    
    DrawingLayer *dlayer = [[DrawingLayer alloc]initWithSize:size];
    dlayer.blendMode = [dict[@"blendMode"] intValue];
    dlayer.visible = [dict[@"visible"] boolValue];
    dlayer.locked = [dict[@"locked"] boolValue];
    dlayer.alpha = [dict[@"alpha"] doubleValue];
    [dlayer addStrokes:strokes];
    dlayer.layer.opacity = dlayer.alpha;
    return dlayer;
}

- (instancetype)initWithSize:(CGSize)size{
    self =  [super init];
    _blendMode = kCGBlendModeNormal;
    _visible = TRUE;
    _locked = FALSE;
    _alpha = 1;
    _strokes = [NSMutableArray array];
    _layer = [CALayer layer];
    _layer.frame = CGRectMake(0, 0, size.width, size.height);
    //_activity = 1;
    _abandonedStrokes = [NSMutableArray array];
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    DrawingLayer *copy = [DrawingLayer drawingLayerWithSize:_layer.frame.size];
    copy.blendMode = _blendMode;
    copy.visible = _visible;
    copy.locked = _locked;
    copy.alpha = _alpha;
    [copy addStrokes:_strokes];
    copy.layer.opacity = _alpha;
    
    return copy;
}

- (void)clear
{
    [_strokes removeAllObjects];
    [[UIColor clearColor] set];
    UIRectFill(_layer.frame);
    _layer.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
}

- (void)undo
{
    if(_strokes.count<= 0) return;
    Stroke *stroke = [_strokes lastObject];
    [_strokes removeLastObject];
    [_abandonedStrokes addObject:stroke];
    [[UIColor clearColor] set];
    UIRectFill(_layer.frame);
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

- (void)newStrokeWithBrushIfNull:(Brush *)brush
{
    if(!_currentStroke) _currentStroke = [[Stroke alloc]initWithBrush:brush];
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
    NSAssert(_currentStroke !=nil, @"updateStrokeWithPoint: _currentStroke = nil");
    [_currentStroke addPoint:toPoint];
    [_currentStroke drawInContext];
    _layer.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
}

-(void)drawInContext
{
    for(Stroke* stroke in _strokes){
        [stroke drawInContext];
    }
}

- (void)setVisible:(BOOL)visible
{
    if(_visible == visible) return;
    _visible = visible;
    if(_visible) self.layer.opacity = self.alpha;
    else self.layer.opacity = 0;
}

- (NSDictionary *)dictionary
{
    NSMutableArray *strokesArray = [NSMutableArray array];
    for (Stroke *stroke in _strokes) {
        NSDictionary *dict = stroke.dictionary;
        [strokesArray addObject:dict];
    }
    NSDictionary *dict = @{@"blendMode":[NSNumber numberWithInteger:_blendMode], @"visible":[NSNumber numberWithBool:_visible], @"locked":[NSNumber numberWithBool:_locked], @"alpha":[NSNumber numberWithDouble:_alpha], @"strokes":strokesArray };
    return dict;
}

- (void)setAlpha:(CGFloat)alpha
{
    _alpha = alpha;
    self.layer.opacity = alpha;
}

- (void)addStrokes:(NSArray *)strokes
{
    for(Stroke *stroke in strokes)
    {
        [stroke drawInContext];
        [_strokes addObject:stroke];
    }
    _layer.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
}
@end
