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

-(instancetype)initWithSize:(CGSize)size{
    self =  [super init];
    _contextSize = size;
    _strokes = [NSMutableArray array];
    UIGraphicsBeginImageContext(_contextSize);
    _context = UIGraphicsGetCurrentContext();
    return self;
}

-(void) clear
{
    [_strokes removeAllObjects];
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(self.contextSize);
    _context = UIGraphicsGetCurrentContext();
}
-(void) removeLastStroke
{
    [_strokes removeLastObject];
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(self.contextSize);
    _context = UIGraphicsGetCurrentContext();
    for(Stroke* stroke in _strokes){
        [stroke drawInContext:UIGraphicsGetCurrentContext()];
    }
}

-(UIImage *)imageFromeContext
{
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}

-(void)update{
    
    [_currenStroke updateInContext:UIGraphicsGetCurrentContext()];
}

-(void) newStrokeWithBrush:(Brush*)brush
{
    _currenStroke = [[Stroke alloc]initWithBrush:brush];
}

-(void) addStroke
{
    [_strokes addObject:_currenStroke];
}

-(void) updateStrokeWithPoint:(CGPoint)toPoint;
{
    [_currenStroke addPoint:toPoint inContext:_context];
}
@end
