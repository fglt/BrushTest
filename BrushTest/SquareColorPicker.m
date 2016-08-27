//
//  SquareColorPicker.m
//  Drawing
//
//  Created by Coding on 6/8/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "SquareColorPicker.h"
#import "InfColorIndicatorView.h"
#import "FGTHSBSupport.h"
#import "constants.h"


IB_DESIGNABLE
@implementation SquareColorPicker{
    InfColorIndicatorView* indicator;
    UIView *imgView;
}

//------------------------------------------------------------------------------
#pragma mark	Properties
//------------------------------------------------------------------------------

- (void) setHue: (CGFloat) value
{
    if (value != _hue) {
        _hue = value;
       
        UIImage *img = createSaturationBrightnessSquareContentImageWithHue(self.hue);
        imgView.layer.contents = (id)img.CGImage;
    }
    
    [self setIndicatorColor];
}

- (void) setPoint: (CGPoint) newValue
{
    if (!CGPointEqualToPoint(newValue, _point)) {
        _point = newValue;
        
        [self sendActionsForControlEvents: UIControlEventValueChanged];
        [self setNeedsLayout];
    }
}

- (void) setIndicatorColor
{
    if (indicator == nil)
        return;
    
    indicator.color = [UIColor colorWithHue: self.hue
                                 saturation: self.point.x
                                 brightness: self.point.y
                                      alpha: 1.0f];
}

//------------------------------------------------------------------------------

- (NSString*) spokenValue
{
    return [NSString stringWithFormat: @"%d%% saturation, %d%% brightness",
            (int) (self.point.x * 100), (int) (self.point.y * 100)];
}

//------------------------------------------------------------------------------

- (void) layoutSubviews
{
    if (imgView == nil)
    {
        CGRect rect = CGRectMake(self.bounds.origin.x+kContentInset, self.bounds.origin.y+kContentInset, self.bounds.size.width-kIndicatorSize, self.bounds.size.height-kIndicatorSize);
        imgView = [[UIImageView alloc] initWithFrame: rect];
        UIImage *img = createSaturationBrightnessSquareContentImageWithHue(self.hue);
        imgView.layer.contents = (id)img.CGImage;

        [self addSubview: imgView];
    }

    if (indicator == nil) {
        CGRect indicatorRect = { CGPointZero, { kIndicatorSize, kIndicatorSize } };
        indicator = [[InfColorIndicatorView alloc] initWithFrame: indicatorRect];
        [self addSubview: indicator];
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(_roatation);
        [self setTransform:transform];
    }
    
    [self setIndicatorColor];
    
    CGFloat indicatorX = kContentInset + (self.point.x * (self.bounds.size.width - kIndicatorSize));
    CGFloat indicatorY = self.bounds.size.height - kContentInset
    - (self.point.y * (self.bounds.size.height - kIndicatorSize));
    
    indicator.center = CGPointMake(indicatorX, indicatorY);
}

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
#pragma mark	Tracking
//------------------------------------------------------------------------------

- (void) trackIndicatorWithTouch: (UITouch*) touch
{
    CGRect bounds = self.bounds;
    
    CGPoint touchValue;
    
    touchValue.x = ([touch locationInView: self].x - kContentInset)
    / (bounds.size.width - 2 * kContentInset);
    
    touchValue.y = ([touch locationInView: self].y - kContentInset)
    / (bounds.size.height - 2 * kContentInset);
    
    touchValue.x = pin(0.0f, touchValue.x, 1.0f);
    touchValue.y = 1.0f - pin(0.0f, touchValue.y, 1.0f);
    
    self.point = touchValue;
}

//------------------------------------------------------------------------------

- (BOOL) beginTrackingWithTouch: (UITouch*) touch
                      withEvent: (UIEvent*) event
{
    [self trackIndicatorWithTouch: touch];
    return YES;
}

//------------------------------------------------------------------------------

- (BOOL) continueTrackingWithTouch: (UITouch*) touch
                         withEvent: (UIEvent*) event
{
    [self trackIndicatorWithTouch: touch];
    return YES;
}

@end
