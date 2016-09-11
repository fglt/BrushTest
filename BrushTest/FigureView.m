//
//  FIgureView.m
//  BrushTest
//
//  Created by Coding on 9/10/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "FigureView.h"

@implementation FigureView

//+ (Class)layerClass
//{
//    return [CAShapeLayer class];
//}

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

// - (void)setBezierPath:(UIBezierPath *)bezierPath
//{
//    _bezierPath =bezierPath;
//    
//        [[UIColor whiteColor]setStroke];
//        [ [UIColor clearColor]setFill];
//        _bezierPath.lineWidth = 1;
//        CGFloat dash[2] = {8, 8};
//        [_bezierPath setLineDash:dash count:2 phase:0];
//   
//    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
//    layer.strokeColor = [UIColor redColor].CGColor;
//    layer.fillColor = [UIColor clearColor].CGColor;
//    layer.lineWidth = 1;
//    layer.lineDashPattern = @[[NSNumber numberWithInteger:8], [NSNumber numberWithInteger:8]];
//    layer.backgroundColor = [UIColor clearColor].CGColor;
//    layer.path =_bezierPath.CGPath;
//}
@end
