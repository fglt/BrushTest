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
extern int const kBrushPixelStep;
typedef enum {
    BrushTypeCircle,
    BrushTypeOval,
    BrushTypeGradient,
    BrushTypeChineseBrush,
    BrushTypeClear,
} BrushType;

typedef NS_ENUM(NSInteger, FigureType) {
    FigureTypeNone,
    FigureTypeLine,
    FigureTypeOval,
    FigureTypeRectangle
};

@interface Brush : NSObject<NSCopying>
@property (nonatomic) CGFloat width;
@property (nonatomic, copy) UIColor* color;
@property (nonatomic) BrushType brushType;
@property (nonatomic) CGFloat MaxWidth;
@property (nonatomic) CGFloat MinWidth;

- (instancetype)initWithColor:(UIColor*)color width:(CGFloat)width;
+ (instancetype)BrushWithColor:(UIColor*)color width:(CGFloat)width type:(BrushType)type;
+ (instancetype)BrushWithDictionary:(NSDictionary *)dict;
- (void)drawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
- (void)drawWithPoints:(NSMutableArray *)points;
- (void)clear;
- (NSDictionary *)dictionary;
- (void)drawWithFirstPoint:(CGPoint)point1 secondPoint:(CGPoint)point2 withFigureType:(FigureType)figureType;

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

@interface FigureBrush : Brush

@end
