//
//  BrushAlphaAndWidthView.m
//  BrushTest
//
//  Created by Coding on 8/20/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "BrushSlider.h"

IB_DESIGNABLE
@implementation BrushSlider
-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self){
        _radiusSlider.minimumValue = 0.0;
        _radiusSlider.maximumValue = 1.0;
        
        _alphaSlider.minimumValue = 0.0;
        _alphaSlider.maximumValue = 1.0;
    }
    return self;
}

-(void)layoutSubviews{
    _radiusSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    //_radiusSlider.center = CGPointMake(self.frame.size.width - 20, 120);
    _alphaSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    //_alphaSlider.center = CGPointMake(self.frame.size.width - 20, self.frame.size.height - 120);
}
@end
