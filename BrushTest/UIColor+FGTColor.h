//
//  UIColor+FGTColor.h
//  BrushTest
//
//  Created by Coding on 8/29/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FGTColor)

+ (UIColor *) colorWithUint32:(uint32_t)rgbaValue;
- (NSNumber *)number;
@end
