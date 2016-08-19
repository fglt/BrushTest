//
//  UIBezierPath+Brush.h
//  BrushTest
//
//  Created by Coding on 8/14/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Brush)
+ (UIBezierPath*)roundBezierPathWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint width:(CGFloat)width;
@end
