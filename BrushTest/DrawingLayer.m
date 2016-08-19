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
@property (nonatomic, strong) NSMutableArray* strokes;
@property (nonatomic, strong) Stroke* currenStroke;
@property (nonatomic) CGContextRef context;

@end

@implementation DrawingLayer

- (instancetype)initWithSize:(CGSize)size{
    self =  [super init];
    _contextSize = size;
    _strokes = [NSMutableArray array];
    //UIGraphicsBeginImageContext(_contextSize);
    UIGraphicsBeginImageContextWithOptions(_contextSize, NO, 0.0);
    _context = UIGraphicsGetCurrentContext();
    return self;
}

- (void)clear
{
    [_strokes removeAllObjects];
    CGRect rect = CGRectMake(0, 0, _contextSize.width, _contextSize.height);
    [[UIColor whiteColor] set];
    UIRectFill(rect);
    //UIGraphicsEndImageContext();
    //UIGraphicsBeginImageContextWithOptions(_contextSize, NO, 0.0);
    //_context = UIGraphicsGetCurrentContext();
}
- (void)removeLastStroke
{
    [_strokes removeLastObject];
    CGRect rect = CGRectMake(0, 0, _contextSize.width, _contextSize.height);
    [[UIColor whiteColor] set];
    UIRectFill(rect);
    for(Stroke* stroke in _strokes){
        [stroke drawInContext:_context];
    }
}

- (UIImage *)imageFromeContext
{
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}

- (void)newStrokeWithBrush:(Brush*)brush
{
    _currenStroke = [[Stroke alloc]initWithBrush:brush];
}

- (void)addStroke
{
    [_strokes addObject:_currenStroke];
    _currenStroke = nil;
}

- (void)updateStrokeWithPoint:(CGPoint)toPoint;
{
    [_currenStroke addPoint:toPoint inContext:_context];
}
@end
