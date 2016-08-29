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
    BrushTypeClear
} BrushType;


@interface Brush : NSObject<NSCopying>
@property (nonatomic) CGFloat width;
@property (nonatomic, copy) UIColor* color;
@property (nonatomic) BrushType brushType;
@property (nonatomic) CGFloat MaxWidth;
@property (nonatomic) CGFloat MinWidth;

- (instancetype)initWithColor:(UIColor*)color width:(CGFloat)width;
+ (instancetype)BrushWithColor:(UIColor*)color width:(CGFloat)width type:(BrushType)type;
+ (instancetype)BrushWithDictionary:(NSDictionary *)dict;
- (UIImage*)imageFromPoint:(CGPoint)fromPoint ToPoint:(CGPoint)toPoint;
- (void)drawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
- (void)drawWithPoints:(NSMutableArray *)points;
- (void) clear;
- (NSDictionary *)dictionary;

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

@interface ClearBrush : Brush

@end

