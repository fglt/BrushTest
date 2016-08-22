//
//  barImage.m
//  Drawing
//
//  Created by Coding on 6/8/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "BarColorPicker.h"
#import "constants.h"
#import "FGTHSBSupport.h"
#import "InfColorIndicatorView.h"

IB_DESIGNABLE
@implementation BarColorPicker{
    InfColorIndicatorView* indicator;
    UIImageView *imgView;
}

static UIImage* createContentImage()
{
    float hsv[] = { 0.0f, 1.0f, 1.0f };
    return createHSVBarContentImage(FGTColorHSVIndexHue, hsv);
}

//------------------------------------------------------------------------------

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}

- (void) layoutSubviews
{
    if (imgView == nil) {

        imgView = [[UIImageView alloc] initWithFrame: CGRectMake(self.bounds.origin.x+20, self.bounds.origin.y+7, self.bounds.size.width-40, self.bounds.size.height-14)];
        UIImage *image = createContentImage();
        imgView.image = image;
        [self addSubview: imgView];
    }
    
    if (indicator == nil) {

        indicator = [[InfColorIndicatorView alloc] initWithFrame: CGRectMake(0, 0, kIndicatorSize, kIndicatorSize)];
        [self addSubview: indicator];
    }
    
    indicator.color = [UIColor colorWithHue: self.value
                                 saturation: 1.0f
                                 brightness: 1.0f
                                      alpha: 1.0f];
    
    CGFloat indicatorLoc = kContentInsetX + (self.value * (self.bounds.size.width - 2 * kContentInsetX));
    indicator.center = CGPointMake(indicatorLoc, CGRectGetMidY(self.bounds));
    
    
}

- (void) setValue: (float) newValue
{
    if (newValue != _value) {
        _value = newValue;
        
        [self sendActionsForControlEvents: UIControlEventValueChanged];
        [self setNeedsLayout];
    }
}

- (void) trackIndicatorWithTouch: (UITouch*) touch
{
    float percent = ([touch locationInView: self].x - kContentInsetX)
    / (self.bounds.size.width - 2 * kContentInsetX);
    
    self.value = pin(0.0f, percent, 1.0f);
}

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
