//
//  Stroke.h
//  BrushTest
//
//  Created by Coding on 8/11/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Brush;

@interface Stroke : NSObject
@property (nonatomic, strong) Brush* brush;
@property (nonatomic, strong) NSMutableArray* points;

- (instancetype)initWithBrush:(Brush*)brush;
- (void)addPoint:(CGPoint)point;
- (void)drawInContext;
- (NSDictionary *)dictionary;
+ (instancetype)strokeWithDictionary:(NSDictionary *)dict;
- (void)addPointAndDraw:(CGPoint)point;
@end
