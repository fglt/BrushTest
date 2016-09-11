//
//  Brush.m
//  BrushTest
//
//  Created by Coding on 8/11/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "Brush.h"
#import "UIColor+FGTColor.h"
#import "FGTHSBSupport.h"
#import "UIbezierPath+brush.h"

const double M_PI2 = M_PI *2;
CGFloat const  MinWidth = 5;
CGFloat const  MaxWidth = 13;
CGFloat const  MinLength = 20;
CGFloat const  DeltaWidth = 0.05;
int const kBrushPixelStep = 3;
@implementation Brush

- (instancetype)initWithColor:(UIColor*)color width:(CGFloat)width type:(BrushType)type
{
    self = [self initWithColor:color width:width];
    _brushType = type;
    return self;
}

- (instancetype)initWithColor:(UIColor*)color width:(CGFloat)width
{
    self = [super init];
    _width = width;
    _color = [color copy];
    return self;
}

+ (instancetype)BrushWithColor:(UIColor*)color width:(CGFloat)width type:(BrushType)type
{
    Brush* brush;
    
    switch (type) {
        case BrushTypeChineseBrush:
            brush = [[ChineseBrush alloc] initWithColor:color width:width];
            break;
        case BrushTypeCircle:
            brush = [[CircleBrush alloc]  initWithColor:color width:width];
            break;
        case BrushTypeOval:
            brush = [[OvalBrush alloc]  initWithColor:color width:width];
            break;
        case BrushTypeGradient:
            brush = [[GradientBrush alloc]  initWithColor:color width:width];
            break;
        case BrushTypeClear:
            brush = [ [ClearBrush alloc] initWithColor:color width:width];
    }
    
    return brush;
}

+ (instancetype)BrushWithDictionary:(NSDictionary *)dict
{
    Brush* brush;
    BrushType type;
    UIColor *color;
    CGFloat width;
    type = [dict[@"type"] unsignedIntValue];
    width = [dict[@"width"] doubleValue];
    uint32_t i = [dict[@"color"] unsignedIntValue];
    color = [UIColor colorWithUint32:i];
    switch (type) {
        case BrushTypeChineseBrush:
            brush = [[ChineseBrush alloc] initWithColor:color width:width];
            break;
        case BrushTypeCircle:
            brush = [[CircleBrush alloc]  initWithColor:color width:width];
            break;
        case BrushTypeOval:
            brush = [[OvalBrush alloc]  initWithColor:color width:width];
            break;
        case BrushTypeGradient:
            brush = [[GradientBrush alloc]  initWithColor:color width:width];
            break;
        case BrushTypeClear:
            brush = [ [ClearBrush alloc] initWithColor:color width:width];
    }
    
    return brush;
}

- (NSDictionary *)dictionary
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithUnsignedInteger:_brushType], [_color number], [NSNumber numberWithDouble:_width]] forKeys:@[@"type", @"color", @"width"] ];
    
    return dict;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    Class brushClass = [self class];
    Brush* copy = [[brushClass alloc] initWithColor:self.color width:self.width];
    return copy;
}

- (void)drawWithPoints:(NSMutableArray *)points
{
    CGPoint point;
    [points[0] getValue:&point];
    UIBezierPath* bpath = [UIBezierPath roundBezierPathWithStartPoint:point width:self.width];
    
    for(NSValue * value in points){
        CGPoint tmpPoint;
        [value getValue:&tmpPoint];
        [bpath addLineToPoint:tmpPoint];
    }
    
    [_color set];
    [bpath stroke];
}

- (void)drawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    UIImage *image = [self imageForDraw];
    CGFloat width = self.width;
    NSArray* points = [self arrayFromPoint:fromPoint toPoint:toPoint];
    CGPoint curPoint;
    for(int i = 0; i<points.count; i++){
        [points[i] getValue:&curPoint];
//        CGRect rect = CGRectMake(curPoint.x- width/2, curPoint.y - width/2, width,  width);
//        [image drawInRect:rect];
        CGPoint point = CGPointMake(curPoint.x- width/2, curPoint.y);
        [image drawAtPoint:point];
    }
}


- (void)drawWithFirstPoint:(CGPoint)point1 secondPoint:(CGPoint)point2 withFigureType:(FigureType)figureType
{
    UIImage *image = [self imageForDraw];
    CGFloat width = self.width;
    NSArray* points = [self arrayFromPoint:point1 toPoint:point2 withFigureType:figureType];
    CGPoint curPoint;
    for(int i = 0; i<points.count; i++){
        [points[i] getValue:&curPoint];
//                CGRect rect = CGRectMake(curPoint.x- width/2, curPoint.y - width/2, width,  width);
//                [image drawInRect:rect];
        CGPoint point = CGPointMake(curPoint.x- width/2, curPoint.y- width/2);
        [image drawAtPoint:point];
    }
}

- (UIImage *)imageForDraw
{
    UIImage *image;
    
    CGRect rect = CGRectMake(0, 0, self.width, self.width);
    CGFloat radius = rect.size.width/2;
    UIBezierPath* bpath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    [self.color set];
    [bpath fill];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (int)lengthFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    CGFloat deltax = fromPoint.x-toPoint.x;
    CGFloat deltay = fromPoint.y-toPoint.y;
    return ceilf(sqrt( deltax *deltax + deltay * deltay) );
}

- (NSMutableArray*)arrayFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    int count  = MAX(1,[self lengthFromPoint:fromPoint toPoint:toPoint]/kBrushPixelStep);
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

- (NSMutableArray*)arrayFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint withFigureType:(FigureType)figureType
{
    NSMutableArray *array = [NSMutableArray array];
    switch (figureType) {
        
        case FigureTypeNone:
        case FigureTypeLine:{
            array = [self arrayFromPoint:fromPoint toPoint:toPoint];
            break;
        }
        case FigureTypeOval:{
            CGFloat a = fabs(fromPoint.x - toPoint.x);
            CGFloat b = fabs(fromPoint.y - toPoint.y);
            //椭圆周长公式 L=2πb+4(a-b) (a>b)
            //x=acosθ ， y=bsinθ。
            int count = (2*M_PI* MIN(a, b) + 4*(fabs(a-b)))/kBrushPixelStep;
            CGFloat unit = 2*M_PI * kBrushPixelStep/(2*M_PI* MIN(a, b) + 4*(fabs(a-b)));
            for(int i=0; i< count; i++){
                CGFloat arc = unit * i;
                CGFloat x = a *cos(arc);
                CGFloat y = b *sin(arc);
                CGPoint point = CGPointMake(fromPoint.x + x, fromPoint.y +y);
                [array addObject:[NSValue valueWithCGPoint:point]];
            }
            break;
        }
        case FigureTypeRectangle:{
            CGRect rect = CGRectMake(MIN(fromPoint.x, toPoint.x), MIN(fromPoint.y, toPoint.y), ABS(fromPoint.x-toPoint.x), ABS(fromPoint.y-toPoint.y));
            CGPoint p1 = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
            CGPoint p2 = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
            CGPoint p3 = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
            [array addObjectsFromArray:[self arrayFromPoint:rect.origin toPoint:p1]];
            [array addObjectsFromArray:[self arrayFromPoint:p1 toPoint:p2]];
            [array addObjectsFromArray:[self arrayFromPoint:p2 toPoint:p3]];
            [array addObjectsFromArray:[self arrayFromPoint:p3 toPoint:rect.origin]];
            break;
        }

    }
    return array;
}

//- (NSArray *)pointsWithPoints:(NSArray *)sourcePoints
//{
//    NSMutableArray *outPoints = [NSMutableArray array];
//    if(sourcePoints.count == 0) return nil;
//    [outPoints addObject:sourcePoints[0]];
//    if(sourcePoints.count == 1) {
//        return outPoints;
//    }
//    CGPoint fromPoint;
//    CGPoint toPoint;
//    [sourcePoints[0] getValue:&fromPoint];
//    for(int i=1; i<sourcePoints.count; i++){
//        [sourcePoints[i] getValue:&toPoint];
//        
//    }
//    
//    return outPoints;
//}

- (void) clear{
    
}

@end

#pragma mark - ChineseBrush
@implementation ChineseBrush

-(instancetype)initWithColor:(UIColor*)color width:(CGFloat)width
{
    self =[super initWithColor:(UIColor*)color width:(CGFloat)width];
    _curWidth =  MIN(MaxWidth,self.width);
    self.brushType = BrushTypeChineseBrush;
    return self;
}

- (UIColor*)curColor{
    return [self.color colorWithAlphaComponent: 0.2 + (_curWidth- MinWidth)/(MaxWidth-MinWidth) * (CGColorGetAlpha(self.color.CGColor) -0.2)];
}

- (void)drawWithPoints:(NSMutableArray *)points
{
    CGPoint point;
    [points[0] getValue:&point];
    UIBezierPath* bpath = [UIBezierPath roundBezierPathWithStartPoint:point width:self.width];
    
    for(NSValue * value in points){
        CGPoint tmpPoint;
        [value getValue:&tmpPoint];
        [bpath addLineToPoint:tmpPoint];
    }
    
    [self.color set];
    [bpath stroke];
}

- (void)drawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    int len  = [self lengthFromPoint:fromPoint toPoint:toPoint];
    CGFloat const  MaxLength = MinLength *MaxWidth/MinWidth + MinLength;
    len = MIN(len, MaxLength);
    self.curWidth = MAX(MIN(self.curWidth, MaxWidth), MinWidth);
    if(len == 0){
        UIBezierPath* bpath = [UIBezierPath bezierPathWithArcCenter:fromPoint radius:self.curWidth/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [[self curColor] set];
        [bpath fill];
        return;
    }
    
    CGFloat aimWidth = MinLength * MaxWidth/len ;
    NSArray* points = [self arrayFromPoint:fromPoint toPoint:toPoint];
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
    _curWidth = self.width;
}

@end

#pragma mark - CircleBrush
@implementation CircleBrush

-(instancetype)initWithColor:(UIColor*)color width:(CGFloat)width
{
    self =[super initWithColor:(UIColor*)color width:(CGFloat)width];
    self.brushType = BrushTypeCircle;
    return self;
}

- (UIImage *)imageForDraw
{
    UIImage *image;
    
    CGRect rect = CGRectMake(0, 0, self.width, self.width);
    CGFloat radius = rect.size.width/2;
    UIBezierPath* bpath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    [self.color set];
    [bpath fill];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//-(instancetype) copyWithZone:(NSZone *)zone
//{
//    CircleBrush* copy = [[CircleBrush alloc] init];
//    copy.brushType = self.brushType;
//    copy.width = self.width;
//    copy.color = [self.color copy];
//    return copy;
//}
@end


#pragma mark - OvalBrush
@implementation OvalBrush

-(instancetype)initWithColor:(UIColor*)color width:(CGFloat)width
{
    self =[super initWithColor:(UIColor*)color width:(CGFloat)width];
    self.brushType = BrushTypeOval;
    return self;
}

- (void)drawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    CGFloat deltax = toPoint.x-fromPoint.x;
    CGFloat deltay = toPoint.y-fromPoint.y;
    _angle = 0;
    if(deltax != 0 ){
        _angle = atan(deltay/deltax) - M_PI_2;
    }
    [super drawFromPoint:fromPoint toPoint:toPoint];
}

-(UIImage* )imageForDraw{

    UIImage* image;
    
    CGRect rect = CGRectMake(-self.width/2, -self.width/4, self.width, self.width/2);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.width, self.width), NO, 0.0);
    UIBezierPath* bpath = [UIBezierPath bezierPathWithOvalInRect:rect];
    [self.color set];
    [bpath applyTransform:CGAffineTransformMakeRotation(_angle)];
    [bpath applyTransform:CGAffineTransformMakeTranslation(self.width/2, self.width/2)];
    
    [bpath fill];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
//-(instancetype) copyWithZone:(NSZone *)zone
//{
//    OvalBrush* copy = [[OvalBrush alloc] init];
//    copy.brushType = self.brushType;
//    copy.width = self.width;
//    copy.color = [self.color copy];
//    copy.angle = self.angle;
//
//    return copy;
//}
@end


#pragma  mark - GradientBrush
@implementation GradientBrush

-(instancetype)initWithColor:(UIColor*)color width:(CGFloat)width
{
    self =[super initWithColor:(UIColor*)color width:(CGFloat)width];
    self.brushType = BrushTypeGradient;
    return self;
}

-(UIImage* )imageForDraw{
    UIImage* image = [UIImage imageNamed:@"Particle"];

    CGRect rect = CGRectMake(0, 0, self.width, self.width);
    
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    UIBezierPath* bpath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.width/2) radius:self.width/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [self.color set];
    
    [bpath fill];
    
    [image drawInRect:rect blendMode:kCGBlendModeOverlay alpha:1];
    [image drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//-(instancetype) copyWithZone:(NSZone *)zone
//{
//    GradientBrush* copy = [[GradientBrush alloc] init];
//    copy.brushType = self.brushType;
//    copy.width = self.width;
//    copy.color = [self.color copy];
//
//    return copy;
//}
@end

#pragma mark - ClearBrush
@implementation ClearBrush


-(instancetype)initWithColor:(UIColor*)color width:(CGFloat)width
{
    self =[super initWithColor:(UIColor*)color width:(CGFloat)width];
    self.brushType =  BrushTypeClear;
    return self;
}

- (UIImage *)imageForDraw
{
    UIImage *image;
  
    CGRect rect = CGRectMake(0, 0, self.width, self.width);
    UIBezierPath* bpath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.width/2) radius:self.width/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    CGFloat dash[]= {8,8};
    [bpath setLineDash:dash count:2 phase:0];
    CGFloat alpha = CGColorGetAlpha(self.color.CGColor);
    UIColor *color = [UIColor colorWithWhite:0 alpha:alpha];
    [color set];
    [bpath fill];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




//- (UIImage *)imageForDraw
//{
//    UIImage *image;
//    CGFloat alpha = CGColorGetAlpha(self.color.CGColor);
//    CGRect rect = CGRectMake(0, 0, self.width, self.width);
//    
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
//    UIBezierPath* bpath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.width/2) radius:self.width/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddPath(context, bpath.CGPath);
//    CGContextClip(context);
//
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    effectView.layer.backgroundColor = self.color.CGColor;
//    effectView.alpha = alpha;
//    effectView.frame = rect;
// 
//    [effectView.layer renderInContext:context];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}

- (void)drawWithFirstPoint:(CGPoint)point1 secondPoint:(CGPoint)point2 withFigureType:(FigureType)figureType
{
    UIImage *image = [self imageForDraw];
    CGFloat width = self.width;
    NSArray* points = [self arrayFromPoint:point1 toPoint:point2 withFigureType:figureType];
    CGPoint curPoint;
    for(int i = 0; i<points.count; i++){
        [points[i] getValue:&curPoint];
        CGRect rect = CGRectMake(curPoint.x- width/2, curPoint.y - width/2, width,  width);
        [image drawInRect:rect blendMode:kCGBlendModeDestinationOut alpha:1];
    }
}

- (void)drawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    UIImage *image = [self imageForDraw];

    CGFloat width = self.width;
    NSArray* points = [self arrayFromPoint:fromPoint toPoint:toPoint];
    CGPoint curPoint;
    for(int i = 0; i<points.count; i++){
        [points[i] getValue:&curPoint];
        CGRect rect = CGRectMake(curPoint.x- width/2, curPoint.y - width/2, width,  width);
        [image drawInRect:rect blendMode:kCGBlendModeDestinationOut alpha:1];
    }
}
//- (void)drawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
//{
//    UIBezierPath* bpath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.width/2     startAngle:0 endAngle:M_PI*2 clockwise:YES];
//    CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(fromPoint.x ,fromPoint.y);
//    [bpath applyTransform:translationTransform];
//
//    CGFloat alpha = CGColorGetAlpha(self.color.CGColor);
//    UIColor *color = [UIColor colorWithWhite:1 alpha:1-alpha];
//    [color set];
//    int len  = MAX(1,[self lengthFromPoint:fromPoint toPoint:toPoint]/kBrushPixelStep);
//
//    NSArray* points = [self arrayFromPoint:fromPoint toPoint:toPoint WithCount:len];
//    CGPoint curPoint;
//    translationTransform = CGAffineTransformMakeTranslation((toPoint.x-fromPoint.x)/len, (toPoint.y-fromPoint.y)/len);
//    for(int i = 0; i<points.count; i++){
//        [bpath fillWithBlendMode:kCGBlendModeDestinationIn alpha:1-alpha ];
//        //[bpath fill];
//        [points[i] getValue:&curPoint];
//        [bpath applyTransform:translationTransform];
//    }
//}
//- (instancetype)copyWithZone:(NSZone *)zone
//{
//    ClearBrush* copy = [[ClearBrush alloc] init];
//    copy.brushType = self.brushType;
//    copy.width = self.width;
//    copy.color = [self.color copy];
//    return copy;
//}



@end

