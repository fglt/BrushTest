//
//  UIImage+FEBoxBlur.m
//  iOS-UIImageBoxBlur
//
//  Created by keso on 16/1/14.
//  Copyright © 2016年 FlyElephant. All rights reserved.
//

#import "UIImage+FEBoxBlur.h"

@implementation UIImage (FEBoxBlur)

+(UIImage *)coreBlurImage:(UIImage *)image
           withBlurNumber:(CGFloat)blur {
    //博客园-FlyElephant
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage  *inputImage=[CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    //CGImageRef outImage=[context createCGImage:result fromRect:CGRectMake([result extent].size.width/2 - image.size.width/2 , [result extent].size.height/2 - image.size.height/2 , image.size.width, image.size.height)];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    NSLog(@"source:%f %f ", image.size.width, image.size.height);
    NSLog(@"result:%@ ", NSStringFromCGSize([result extent].size));
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 200);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGBitmapInfo info = CGImageGetBitmapInfo(img);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //注意：CGBitmapContextCreate的最后一个参数必须和原始图像相同，否则有些图片的rgb会颠倒！！
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             info);
//    NSLog(@"  kCGBitmapAlphaInfoMask    = %s\n"
//          "  kCGBitmapFloatComponents   = %s\n"
//          "  kCGBitmapByteOrderMask     = %s\n"
//          "  kCGBitmapByteOrderDefault  = %s\n"
//          "  kCGBitmapByteOrder16Little = %s\n"
//          "  kCGBitmapByteOrder32Little = %s\n"
//          "  kCGBitmapByteOrder16Big    = %s\n"
//          "  kCGBitmapByteOrder32Big    = %s\n",
//          (info & kCGBitmapAlphaInfoMask)     ? "YES" : "NO",
//          (info & kCGBitmapFloatComponents)   ? "YES" : "NO",
//          (info & kCGBitmapByteOrderMask)     ? "YES" : "NO",
//          (info & kCGBitmapByteOrderDefault)  ? "YES" : "NO",
//          (info & kCGBitmapByteOrder16Little) ? "YES" : "NO",
//          (info & kCGBitmapByteOrder32Little) ? "YES" : "NO",
//          (info & kCGBitmapByteOrder16Big)    ? "YES" : "NO",
//          (info & kCGBitmapByteOrder32Big)    ? "YES" : "NO"   );

    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
//    NSLog(@"1%@",NSStringFromCGSize( image.size));
//    NSLog(@"2%@",NSStringFromCGSize( returnImage.size));
    
    return returnImage;
}

+ (void)convertBGRA: (vImage_Buffer) bgraImageBuffer toRGBA:(vImage_Buffer)rgbaImageBuffer
{
    const uint8_t byteSwapMap[4] = { 2, 1, 0, 3 };
    
    vImage_Error error;
    error = vImagePermuteChannels_ARGB8888(&bgraImageBuffer, &rgbaImageBuffer, byteSwapMap, kvImageNoFlags);
    if (error != kvImageNoError) {
        NSLog(@"%s, vImage error %zd", __PRETTY_FUNCTION__, error);
    }
}

@end
