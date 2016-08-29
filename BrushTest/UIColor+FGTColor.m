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
        uint32_t rgb[4];
        rgb[0] = rgba[0] *255;
        rgb[1] = rgba[1] *255;
        rgb[2] = rgba[2] *255;
        rgb[3] = rgba[3] *255;
        c = (rgb[0]<<24)|(rgb[1]<<16)|(rgb[2]<<8)|(rgb[3]);
    }
    return [NSNumber numberWithUnsignedInt:c];
}
@end
