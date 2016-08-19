//
//  Brush.m
//  BrushTest
//
//  Created by Coding on 8/11/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "Brush.h"
#import "UIColor+BFPaperColors.h"
#import "InfHSBSupport.h"

const double M_PI2 = M_PI *2;
CGFloat const  MinWidth = 5;
CGFloat const  MaxWidth = 13;
CGFloat const  MinLength = 20;
CGFloat const  DeltaWidth = 0.05;

@implementation Brush

- (instancetype)initWithColor:(UIColor*)color radius:(CGFloat)radius type:(BrushType)type
{
    self = [super init];
    _brushType = type;
    _radius = radius;
    _color = color;
    return self;
}

- (instancetype)initWithColor:(UIColor*)color radius:(CGFloat)radius
{
    self = [super init];
    _radius = radius;
    _color = color;
    return self;
}

+ (instancetype)BrushWithColor:(UIColor*)color radius:(CGFloat)radius type:(BrushType)type{
    Brush* brush;
    
    switch (type) {
        case BrushTypeChineseBrush:
            brush = [[ChineseBrush alloc] initWithColor:color radius:radius];
            break;
        case BrushTypeCircle:
            brush = [[CircleBrush alloc]  initWithColor:color radius:radius];
            break;
        case BrushTypeOval:
            brush = [[OvalBrush alloc]  initWithColor:color radius:radius];
            break;
        case BrushTypeGradient:
            brush = [[GradientBrush alloc]  initWithColor:color radius:radius];
            break;
        default:
            break;
    }
    
    return brush;
}

-(instancetype)copyWithZone:(NSZone *)zone
{
    Brush* copy = [[Brush alloc] init];
    copy.brushType = self.brushType;
    copy.radius = self.radius;
    copy.color = [self.color copy];
    return copy;
}

- (UIImage*)imageFromPoint:(CGPoint)fromPoint ToPoint:(CGPoint)toPoint;
{
    UIImage* image;
    CGFloat deltax = fromPoint.x-toPoint.x;
    CGFloat deltay = fromPoint.y-toPoint.y;
    CGSize insize = CGSizeMake(ABS(deltax) + self.radius, ABS(deltay) + self.radius);
    CGSize size = CGSizeMake(insize.width + self.radius, insize.height + self.radius);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    CGPoint newFromPoint;
    CGPoint newToPoint;
    
    CGPoint leftTop = CGPointMake(self.radius, self.radius);
    CGPoint leftDown = CGPointMake(self.radius,insize.height);
    CGPoint rightTop = CGPointMake(insize.width, self.radius);
    CGPoint rightDown = CGPointMake(insize.width , insize.height );
    
    if( ( (int)deltax^(int)deltay) >= 0 ){
        newFromPoint = leftTop;
        newToPoint = rightDown;
    }else{
        newFromPoint = rightTop;
        newToPoint = leftDown;
    }

    UIBezierPath* bpath = [UIBezierPath roundBezierPathWithStartPoint:newFromPoint endPoint:newToPoint width: _radius*2];
    [_color set];
    [bpath stroke];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)drawInContext:(CGContextRef)context fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    UIBezierPath* bpath = [UIBezierPath roundBezierPathWithStartPoint:fromPoint endPoint:toPoint width: _radius*2];
    [_color set];
    [bpath stroke];
    //NSLog(@"do default drawing");
}

- (int)lengthFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    CGFloat deltax = fromPoint.x-toPoint.x;
    CGFloat deltay = fromPoint.y-toPoint.y;
    return (int)(sqrt( deltax *deltax + deltay * deltay) );
}

- (NSMutableArray*)arrayFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint WithCount:(int)count
{
    NSMutableArray *array = [NSMutableArray array];
    CGFloat delx = (toPoint.x -fromPoint.x)/count;
    CGFloat dely = (toPoint.y -fromPoint.y)/count;
    CGPoint  prePoint = fromPoint;
    for(int i= 0; i< count; i++){
        prePoint.x += delx;
        prePoint.y += dely;
        [array addObject:[NSValue valueWithCGPoint:prePoint]];
    }
    
    return array;
}

- (void) clear{
    
}
@end

#pragma mark - ChineseBrush
@implementation ChineseBrush

-(instancetype)initWithColor:(UIColor*)color radius:(CGFloat)radius
{
    self =[super initWithColor:(UIColor*)color radius:(CGFloat)radius];
    _curWidth = self.radius;
    
    return self;
}

- (UIColor*)curColor{
    return [self.color colorWithAlphaComponent:0.1 + (_curWidth-MinWidth)/(MaxWidth -MinWidth)*0.3];
}

- (void)drawInContext:(CGContextRef)context fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    int len  = [self lengthFromPoint:fromPoint toPoint:toPoint];
    CGFloat const  MaxLength = MinLength *MaxWidth/MinWidth + MinLength;
    len = MIN(len, MaxLength);
    if(len == 0){
        UIBezierPath* bpath = [UIBezierPath bezierPathWithArcCenter:fromPoint radius:self.curWidth/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [[self curColor] set];
        [bpath fill];
        return;
    }
    
    CGFloat aimWidth = MinLength * MaxWidth/len ;
    NSArray* points = [self arrayFromPoint:fromPoint toPoint:toPoint WithCount:len];
    CGPoint lastPoint =fromPoint;
    CGPoint curPoint;
    for(int i = 1; i<points.count; i++){
        [points[i] getValue:&curPoint];
        UIBezierPath* bpath = [UIBezierPath roundBezierPathWithStartPoint:lastPoint endPoint:curPoint width:self.curWidth];
        [[self curColor] set];
        [bpath stroke];
        if( self.curWidth > aimWidth) {
            self.curWidth -= DeltaWidth;
        }else{
            self.curWidth += DeltaWidth;
        }
        self.curWidth = MAX(MIN(self.curWidth, MaxWidth), MinWidth);
        lastPoint = curPoint;
    }
}

- (void) clear{
    _curWidth = self.radius;
}

-(instancetype) copyWithZone:(NSZone *)zone
{
    ChineseBrush* copy = [[ChineseBrush alloc] init];
    copy.brushType = self.brushType;
    copy.radius = self.radius;
    copy.color = [self.color copy];
    copy.curWidth = self.curWidth;
    return copy;
}
@end

#pragma mark - CircleBrush
@implementation CircleBrush

-(instancetype)initWithColor:(UIColor*)color radius:(CGFloat)radius
{
    self =[super initWithColor:(UIColor*)color radius:(CGFloat)radius];
    return self;
}

-(UIImage*) imageFromBrush
{
    CGSize imageSize = CGSizeMake(self.radius * 2, self.radius * 2);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClip(context);
    
//    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
//    [[UIColor clearColor] set];
//    UIRectFill(rect);
    [self.color set];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)drawInContext:(CGContextRef)context fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    UIBezierPath* bpath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(fromPoint.x ,fromPoint.y);
    [bpath applyTransform:translationTransform];
    
    [self.color set];
    int len  = [self lengthFromPoint:fromPoint toPoint:toPoint];
    if(len == 0){
        [bpath fill];
        return;
    }
    
    NSArray* points = [self arrayFromPoint:fromPoint toPoint:toPoint WithCount:len];
    CGPoint curPoint;
    translationTransform = CGAffineTransformMakeTranslation((toPoint.x-fromPoint.x)/len, (toPoint.y-fromPoint.y)/len);
    for(int i = 0; i<points.count; i++){
        [bpath fill];
        [points[i] getValue:&curPoint];
        [bpath applyTransform:translationTransform];
    }
}

-(instancetype) copyWithZone:(NSZone *)zone
{
    CircleBrush* copy = [[CircleBrush alloc] init];
    copy.brushType = self.brushType;
    copy.radius = self.radius;
    copy.color = [self.color copy];
    return copy;
}
@end


#pragma mark - OvalBrush
@implementation OvalBrush

-(instancetype)initWithColor:(UIColor*)color radius:(CGFloat)radius
{
    self =[super initWithColor:(UIColor*)color radius:(CGFloat)radius];
    return self;
}

-(UIImage*)imageFromBrush
{

    CGSize imageSize = CGSizeMake(self.radius * 2, self.radius);
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClip(context);
    [self.color set];

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)drawInContext:(CGContextRef)context fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    CGFloat deltax = toPoint.x-fromPoint.x;
    CGFloat deltay = toPoint.y-fromPoint.y;
    int len  = [self lengthFromPoint:fromPoint toPoint:toPoint];
    if(len == 0){
        return;
    }
    NSArray* points = [self arrayFromPoint:fromPoint toPoint:toPoint WithCount:len];
    
    CGFloat angle = 0;
    if(deltax != 0 ){
        angle = atan(deltay/deltax) - M_PI_2;
    }
    
    CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(fromPoint.x ,fromPoint.y);
    CGAffineTransform transform = CGAffineTransformRotate(translationTransform, angle);
    CGRect rect = CGRectMake(- self.radius, self.radius/2, self.radius * 2, self.radius);
    UIBezierPath* bpath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    [bpath applyTransform:transform];
    
    translationTransform = CGAffineTransformMakeTranslation(deltax/len, deltay/len);
    [self.color set];
    
    CGPoint curPoint;
    for(int i = 0; i<points.count; i++){
        [bpath fill];
        [points[i] getValue:&curPoint];
        [bpath applyTransform:translationTransform];
    }
}

-(instancetype) copyWithZone:(NSZone *)zone
{
    OvalBrush* copy = [[OvalBrush alloc] init];
    copy.brushType = self.brushType;
    copy.radius = self.radius;
    copy.color = [self.color copy];
    copy.angle = self.angle;

    return copy;
}
@end


#pragma  mark - GradientBrush
@implementation GradientBrush

-(instancetype)initWithColor:(UIColor*)color radius:(CGFloat)radius
{
    self =[super initWithColor:(UIColor*)color radius:(CGFloat)radius];
    return self;
}

- (void)drawInContext:(CGContextRef)context fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    UIImage *image = [self imageFrom2];
    int len  = [self lengthFromPoint:fromPoint toPoint:toPoint]/2;
    if(len == 0){
        CGRect rect = CGRectMake(fromPoint.x- self.radius, fromPoint.y - self.radius, self.radius*2,  self.radius*2);
        [image drawInRect:rect];
        return;
    }
    image = [self imageFrom2];
    NSArray* points = [self arrayFromPoint:fromPoint toPoint:toPoint WithCount:len];
    CGPoint curPoint;
    for(int i = 0; i<points.count-1; i++){
        [points[i] getValue:&curPoint];
        CGRect rect = CGRectMake(curPoint.x- self.radius, curPoint.y - self.radius, self.radius*2,  self.radius*2);
        [image drawInRect:rect];
    }
}

-(UIImage* )imageFrom{
    UIImage* image;

    CGSize size = CGSizeMake(self.radius*2,self.radius*2);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawRadialGradient:(CGContextRef)context atPoint:CGPointMake(self.radius, self.radius)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;

}

-(UIImage* )imageFrom2{
    UIImage* image;
    
    CGSize size = CGSizeMake(self.radius*2,self.radius*2);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawRadialGradient2:(CGContextRef)context atPoint:CGPointMake(self.radius, self.radius)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)drawRadialGradient2:(CGContextRef)context atPoint:(CGPoint)point{
    
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[3]={0,0.5,1.0};
    UIColor *startColor = [UIColor blackColor];
    
    startColor = [startColor colorWithAlphaComponent:0.2];
    UIColor *centerColor = [startColor colorWithAlphaComponent:0.1];
    UIColor *endColor = [startColor colorWithAlphaComponent:0.01];
    CFArrayRef array =  CFArrayCreate(kCFAllocatorDefault, (const void*[]){startColor.CGColor, centerColor.CGColor,endColor.CGColor}, 3, nil);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,array,locations);
    /*绘制径向渐变
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
     */
    CGContextDrawRadialGradient(context, gradient, point,0, point, self.radius, kCGGradientDrawsBeforeStartLocation);
    
    CGColorSpaceRelease(colorSpace);
}


-(void)drawRadialGradient:(CGContextRef)context atPoint:(CGPoint)point{

    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[3]={0,0.5,1.0};
    UIColor *startColor = [UIColor blackColor];
     startColor = [startColor colorWithAlphaComponent: self.radius * 0.5/255];
    UIColor *centerColor = [startColor colorWithAlphaComponent: self.radius * 0.5/255 ];
    UIColor *endColor = [startColor colorWithAlphaComponent:0.0];
    CFArrayRef array =  CFArrayCreate(kCFAllocatorDefault, (const void*[]){startColor.CGColor, centerColor.CGColor,endColor.CGColor}, 3, nil);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,array,locations);
    /*绘制径向渐变
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
     */
    CGContextDrawRadialGradient(context, gradient, point,0, point, self.radius, kCGGradientDrawsBeforeStartLocation);

    CGColorSpaceRelease(colorSpace);
}



-(instancetype) copyWithZone:(NSZone *)zone
{
    GradientBrush* copy = [[GradientBrush alloc] init];
    copy.brushType = self.brushType;
    copy.radius = self.radius;
    copy.color = [self.color copy];

    return copy;
}
@end