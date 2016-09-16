//
//  Oval.h
//  BrushTest
//
//  Created by Coding on 9/12/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Oval : NSObject
@property (nonatomic) CGPoint center;
@property (nonatomic) CGPoint axis;

- (instancetype)initWithCenter:(CGPoint) center axis:(CGPoint)point;
- (CGFloat)arcStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;
- (CGFloat)angle:(CGFloat) angle;
- (CGFloat)radiusAtAngle:(CGFloat)angle;
@end
