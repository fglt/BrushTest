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
    UIImageView *imgView;
}

//------------------------------------------------------------------------------
#pragma mark	Properties
//------------------------------------------------------------------------------
//
//-(id) initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//
//    self.hue = 0;
//
//    _point.x = 0.5;
//    _point.y = 0.8;
//    return self;
//}
- (void) setHue: (CGFloat) value
{
    if (value != _hue || imgView.image == nil) {
        _hue = value;
       
        UIImage *img = createSaturationBrightnessSquareContentImageWithHue(self.hue);
        imgView.image = img;
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
        imgView = [[UIImageView alloc] initWithFrame: CGRectMake(self.bounds.origin.x+20, self.bounds.origin.y+20, self.bounds.size.width-40, self.bounds.size.height-40)];
        UIImage *img = createSaturationBrightnessSquareContentImageWithHue(self.hue);
        imgView.image = img;

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
    
    CGFloat indicatorX = kContentInsetX + (self.point.x * (self.bounds.size.width - 2 * kContentInsetX));
    CGFloat indicatorY = self.bounds.size.height - kContentInsetY
    - (self.point.y * (self.bounds.size.height - 2 * kContentInsetY));
    
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
    
    touchValue.x = ([touch locationInView: self].x - kContentInsetX)
    / (bounds.size.width - 2 * kContentInsetX);
    
    touchValue.y = ([touch locationInView: self].y - kContentInsetY)
    / (bounds.size.height - 2 * kContentInsetY);
    
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
