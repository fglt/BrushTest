//
//  Oval.m
//  BrushTest
//
//  Created by Coding on 9/12/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "Oval.h"

@implementation Oval

- (instancetype)initWithCenter:(CGPoint) center axis:(CGPoint)point
{
    self = [super init];
    _axis = point;
    _center = center;
    return self;
}

- (CGFloat)radiusAtAngle:(CGFloat)angle
{
    return sqrt( pow(_axis.x*cos(angle),2) + pow(_axis.y*sin(angle), 2));
}

- (CGFloat)arcStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    
    int TOTAL_SIMPSON_STEP = 1000;
    int setpCount = TOTAL_SIMPSON_STEP/M_PI/2*(endAngle-startAngle);
    double dStep = 2*M_PI/TOTAL_SIMPSON_STEP;
    if(setpCount & 1) setpCount++;    //偶数
    if(setpCount==0) return 0.0;
    
    int halfCount = setpCount>>1;
    
    double sum1=0, sum2=0;
    for(int i = 0; i<halfCount; i++){
        sum1 += [self radiusAtAngle:(2*i+1)*dStep];
    }
    
    for(int i = 1; i<halfCount; i++){
        sum2 += [self radiusAtAngle:(2*i)*dStep];
    }
    
    return  dStep/3 * ([self radiusAtAngle:startAngle] + [self radiusAtAngle:endAngle] + sum1*4 + sum2 *2);
}


- (double)angle:(double) angle
{
    
    double len = angle *[self arcStartAngle:0 endAngle:2*M_PI]/2/M_PI;
    double a1 =angle, a2;
    
    do
        
    {
        double l = [self arcStartAngle:0 endAngle:a1];
        //double tmp = (l-len)/[self radiusAtAngle:a1];
        a2 = a1 - (l-len)/[self radiusAtAngle:a1];
        
        if(fabs(a1-a2)<0.01){
            break;
        }
        
        a1=a2;
        
    }while(true);
    
    return a2;
}

@end
