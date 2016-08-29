//
//  UIColor+FGTColor.m
//  BrushTest
//
//  Created by Coding on 8/29/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "UIColor+FGTColor.h"

@implementation UIColor (FGTColor)
+ (UIColor *) colorWithUint32:(uint32_t)rgbaValue
{
    //NSLog(@"%0x", rgbaValue);
    CGFloat r = ((rgbaValue & 0xFF000000) >> 24)/255.0;
    CGFloat g = ((rgbaValue & 0xFF0000) >> 16)/255.0;
    CGFloat b = ((rgbaValue & 0xFF00) >> 8)/255.0;
    CGFloat a = ((rgbaValue & 0xFF))/255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

-(NSNumber *)number
{
    uint32_t c;
    if (self) {
        CGFloat rgba[4];
        [self getRed:rgba green:rgba+1 blue:rgba+2 alpha:rgba+3];
        c = ((uint32_t)(rgba[0] *255)<<24)|((uint32_t)(rgba[1] *255)<<16)|((uint32_t)(rgba[2] *255)<<8)|((uint32_t)(rgba[3] *255));
    }
    return [NSNumber numberWithUnsignedInt:c];
}
@end
