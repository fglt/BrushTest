//
//  Stroke.h
//  BrushTest
//
//  Created by Coding on 8/11/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brush.h"

@interface Stroke : NSObject
@property (nonatomic, strong) Brush* brush;
@property (nonatomic, strong) NSMutableArray* points;
@property (nonatomic) FigureType figureType;

- (instancetype)initWithBrush:(Brush *)brush;
- (instancetype)initWithBrush:(Brush *)brush figureType:(FigureType)figureType;
- (void)addPoint:(CGPoint)point;
- (void)drawInContext;
- (NSDictionary *)dictionary;
+ (instancetype)strokeWithDictionary:(NSDictionary *)dict;
- (void)addPointAndDraw:(CGPoint)point;
@end
