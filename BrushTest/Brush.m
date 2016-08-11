//
//  Brush.m
//  BrushTest
//
//  Created by Coding on 8/11/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "Brush.h"

@implementation Brush
-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    _brushType = [[dictionary objectForKey:@"BrushType"] intValue] ;
    _radius = [[dictionary objectForKey:@"Radius"] floatValue] ;
    _color =  [[dictionary objectForKey:@"Color"] copy];
    return self;
}

-(instancetype)copyWithZone:(NSZone *)zone
{
    Brush* copy = [[Brush alloc] init];
    copy.brushType = self.brushType;
    copy.radius = self.radius;
    copy.color = [self.color copy];
    return copy;
}
@end
