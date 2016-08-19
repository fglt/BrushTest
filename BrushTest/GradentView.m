//
//  GradentView.m
//  BrushTest
//
//  Created by Coding on 8/8/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "GradentView.h"
#import "UIColor+BFPaperColors.h"
#import "UIImage+FEBoxBlur.h"
@import Accelerate;

@implementation GradentView

//-(void)awakeFromNib{
//    UIGraphicsBeginImageContext(CGSizeMake(300, 300));
//    [[UIColor paperColorRed200] set];
//    CGRect bounds = CGRectMake(0, 0, 300, 300);
//    UIRectFill(bounds);
//    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    self.layer.contents = (__bridge id _Nullable)([GradentView coreBlurImage:image withBlurNumber:20].CGImage);
//    
//}
-(void)drawRect:(CGRect)rect{
    CGContextRef context=UIGraphicsGetCurrentContext();
   
    //[self drawLinearGradient:context];
    UIImage *image;
    //CGContextRef context;
    UIBezierPath* bpath;
    //UIGraphicsBeginImageContextWithOptions(CGSizeMake(300, 300), NO, 0.0);
//    UIGraphicsBeginImageContext(CGSizeMake(300, 300));
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIBezierPath * bpath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150) radius:150 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
//    CGContextAddPath(context, bpath.CGPath);
//    CGContextClip(context);
//    [[UIColor paperColorPink100] setFill];
//    CGRect bounds = CGRectMake(0, 0, 300, 300);
//    UIRectFill(bounds);
  //  image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //image = [UIImage imageNamed:@"Person"];
    //image = [UIImage imageNamed:@"IMG_0117"];
    //[image drawAtPoint:CGPointMake(0, 0)];
    //[[UIImage coreBlurImage:image withBlurNumber:40] drawAtPoint:CGPointMake(0, 0)];
    image = [self drawRadialGradient];
    image = [UIImage boxblurImage:image withBlurNumber:1] ;
    //image = [UIImage coreBlurImage:image withBlurNumber:40];
//    UIGraphicsBeginImageContext(CGSizeMake(300, 300));
//    context = UIGraphicsGetCurrentContext();

    bpath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150) radius:150 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CGContextAddPath(context, bpath.CGPath);
    CGContextClip(context);
    [image drawAtPoint:CGPointZero];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [image drawAtPoint:CGPointZero];
    //[self drawRadialGradient:UIGraphicsGetCurrentContext()];
}

//- (void)transformRGBToBGR:(const UInt8 *)pict
//{
//    rgb.data = (void *)pict;
//    
//    vImage_Error error = vImageConvert_RGB888toPlanar8(&rgb,&red,&green,&blue,kvImageNoFlags);
//    if (error != kvImageNoError) {
//        NSLog(@"vImageConvert_RGB888toPlanar8 error");
//    }
//    
//    error = vImageConvert_Planar8toRGB888(&blue,&green,&red,&bgr,kvImageNoFlags);
//    if (error != kvImageNoError) {
//        NSLog(@"vImageConvert_Planar8toRGB888 error");
//    }
//    
//    free((void *)pict);
//    
//}

-(void)drawLinearGradient:(CGContextRef)context{
    //使用rgb颜色空间
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat compoents[12]={
        255/255.0,127.0/255.0,127.0/255.0,1,
        255/255.0,86.0/255.0,86.0/255.0,1,
        255.0/255.0,127.0/255.0,127.0/255.0,1
    };
    CGFloat locations[3]={0,0.5,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    CGRect rect = CGRectMake(0, 0, 300, 300);
    UIRectClip(rect);     /*绘制线性渐变
     context:图形上下文
     gradient:渐变色
     startPoint:起始位置
     endPoint:终止位置
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
     */
    CGContextDrawLinearGradient(context, gradient, CGPointMake(150, 0), CGPointMake(150, rect.size.height), kCGGradientDrawsAfterEndLocation);
    
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}

#pragma mark 径向渐变
-(void)drawRadialGradient:(CGContextRef)context{
    //使用rgb颜色空间
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat compoents[12]={
        248.0/255.0,220.0/255.0,220.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3]={0,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 2);
    
    /*绘制径向渐变
     context:图形上下文
     gradient:渐变色
     startCenter:起始点位置
     startRadius:起始半径（通常为0，否则在此半径范围内容无任何填充）
     endCenter:终点位置（通常和起始点相同，否则会有偏移）
     endRadius:终点半径（也就是渐变的扩散长度）
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
     */
    CGContextDrawRadialGradient(context, gradient, CGPointMake(20, 20),0, CGPointMake(20, 20), 15, kCGGradientDrawsAfterEndLocation);
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}

-(UIImage*)drawRadialGradient{
    //使用rgb颜色空间
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGFloat compoents[12]={
        248.0/255.0,86.0/255.0,86/255.0,1,
        248.0/255.0,127.0/255.0,127/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3]={0,0.5,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    /*绘制径向渐变
     context:图形上下文
     gradient:渐变色
     startCenter:起始点位置
     startRadius:起始半径（通常为0，否则在此半径范围内容无任何填充）
     endCenter:终点位置（通常和起始点相同，否则会有偏移）
     endRadius:终点半径（也就是渐变的扩散长度）
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
     */
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(300, 300), NO,0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawRadialGradient(context, gradient, CGPointMake(150, 150),0, CGPointMake(150, 150), 150, kCGGradientDrawsAfterEndLocation);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
    return image;
}
@end
