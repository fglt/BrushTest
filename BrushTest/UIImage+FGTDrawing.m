//
//  UIImage+FGTDrawing.m
//  BrushTest
//
//  Created by Coding on 9/8/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "UIImage+FGTDrawing.h"

@implementation UIImage (FGTDrawing)
- (UIImage *)imageWithScale:(float)scale
{
    CGSize size =CGSizeMake(self.size.width * scale, self.size.height * scale);
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
                               
    [self drawInRect:(CGRect){CGPointZero,size}];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
                                
    return scaledImage;
                                
}

- (UIImage *)imageWithRect:(CGRect)rect
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef,rect);
    UIImage* cropImage = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return cropImage;
}
@end
