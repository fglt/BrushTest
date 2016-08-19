//
//  Brush.h
//  BrushTest
//
//  Created by Coding on 8/11/16.
//  Copyright © 2016 Coding. All rights reserved.
//


#import <UIKit/UIKit.h>



extern const double M_PI2;
extern const CGFloat  MinWidth ;
extern CGFloat const  MaxWidth ;
extern CGFloat const  MinLength ;
extern CGFloat const  DeltaWidth ;

typedef enum {
    BrushTypeCircle,
    BrushTypeOval,
    BrushTypeGradient,
    BrushTypeChineseBrush,
} BrushType;


@interface Brush : NSObject<NSCopying>
@property (nonatomic) CGFloat width;
@property (nonatomic, copy) UIColor* color;
@property (nonatomic) BrushType brushType;
@property (nonatomic) CGFloat MaxWidth;
@property (nonatomic) CGFloat MinWidth;
@property (nonatomic) UIImage* image;

- (instancetype)initWithColor:(UIColor*)color radius:(CGFloat)radius;
+ (instancetype)BrushWithColor:(UIColor*)color radius:(CGFloat)radius type:(BrushType)type;
- (UIImage*)imageFromPoint:(CGPoint)fromPoint ToPoint:(CGPoint)toPoint;
- (void)drawInContext:(CGContextRef)context fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
- (void) clear;

@end

@interface ChineseBrush : Brush
@property (nonatomic) CGFloat curWidth;;
@end

@interface CircleBrush : Brush

@end

@interface OvalBrush : Brush
@property(nonatomic) CGFloat angle;
@end

@interface GradientBrush : Brush
@end

