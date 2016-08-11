//
//  Stroke.h
//  BrushTest
//
//  Created by Coding on 8/11/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Brush;

@interface Path : NSObject
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, strong) UIBezierPath* path;
@end

@interface Stroke : NSObject
@property (nonatomic, strong) Brush* brush;
@property (nonatomic, strong) NSMutableArray *items;

-(instancetype)initWithBrush:(Brush*)brush;
-(void) addPoint:(CGPoint)point;
-(void) updateInContext:(CGContextRef)context;
-(void) drawInContext:(CGContextRef)context;
@end
