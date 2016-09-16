//
//  FIgureView.m
//  BrushTest
//
//  Created by Coding on 9/10/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "FigureView.h"

@implementation FigureView

- (void)drawRect:(CGRect)rect
{
    if(!_bezierPath) return;
    [[UIColor blackColor]setStroke];
    _bezierPath.lineWidth = 1;
    CGFloat dash[2] = {10, 10};
    [_bezierPath setLineDash:dash count:2 phase:0];
    [_bezierPath stroke];

    [ [UIColor whiteColor]setStroke];
    [_bezierPath setLineDash:dash count:2 phase:10];
    [_bezierPath stroke];
}

 - (void)setBezierPath:(UIBezierPath *)bezierPath
{
    _bezierPath =bezierPath;
    [self setNeedsDisplay];
}
@end
