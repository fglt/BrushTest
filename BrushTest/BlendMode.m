//
//  blendMode.m
//  BrushTest
//
//  Created by Coding on 9/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "BlendMode.h"

@implementation BlendMode
- (instancetype) initWithMode:(CGBlendMode)mode description:(NSString *)desc
{
    self  = [super init];
    _blendMode = mode;
    _blendModeName = desc;
    return self;
}
@end
