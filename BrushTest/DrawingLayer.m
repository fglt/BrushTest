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
    dlayer.strokes = strokes;
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
    _layer.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
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
@end
