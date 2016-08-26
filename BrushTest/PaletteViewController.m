//
//  PaletteViewController.m
//  BrushTest
//
//  Created by Coding on 8/18/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "PaletteViewController.h"
#import "CircleColcorPicker.h"
#import "SquareColorPicker.h"
#import "FGTHSBSupport.h"
#import "UIColor+BFPaperColors.h"

@interface PaletteViewController()
@property (weak, nonatomic) IBOutlet CircleColcorPicker *circleColorPicker;
@property (weak, nonatomic) IBOutlet SquareColorPicker *squareColorPicker;
@property (weak, nonatomic) IBOutlet UISlider *slider1;
@property (weak, nonatomic) IBOutlet UISlider *slider2;
@property (weak, nonatomic) IBOutlet UISlider *slider3;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIView *lastColorView;
@property (weak, nonatomic) IBOutlet UIView *currentColorView;

@end

@implementation PaletteViewController

-(void) viewDidLoad
{
    //_color = [ _delegate currentColor];
    _currentColorView.backgroundColor = [ _delegate currentColor];
    CGFloat hsv[3];
    HSVFromUIColor(_currentColorView.backgroundColor, hsv);
    _circleColorPicker.hue = hsv[0];
    _squareColorPicker.hue = hsv[0];
    _squareColorPicker.point = CGPointMake(hsv[1], hsv[2]);
}

- (IBAction)touchColorPicker:(id)sender {
    _squareColorPicker.hue = _circleColorPicker.hue;
    CGFloat hsv[3] = {_squareColorPicker.hue, _squareColorPicker.point.x, _squareColorPicker.point.y};
    CGFloat bgr[3];
    HSVtoRGB(hsv,bgr);
//    _currentColorView.backgroundColor =  [UIColor colorWithHue:hsv[0] saturation:hsv[1] brightness:hsv[2] alpha:1];
    _currentColorView.backgroundColor =  [UIColor colorWithRed:bgr[2] green:bgr[1] blue:bgr[0] alpha:1];
    [self doSetText:bgr];
}

- (IBAction)moveColorSlider:(id)sender {
    CGFloat bgr[3] = {_slider3.value,_slider2.value,_slider1.value};
    CGFloat hsv[3] = { self.circleColorPicker.hue, self.squareColorPicker.point.x, self.squareColorPicker.point.y};
    RGBToHSV(bgr, hsv, YES);
    _circleColorPicker.hue = hsv[0];
    _squareColorPicker.hue = hsv[0];
    _squareColorPicker.point = CGPointMake(hsv[1], hsv[2]);
    _currentColorView.backgroundColor = [UIColor colorWithRed:bgr[2] green:bgr[1] blue:bgr[0] alpha:1];
}

-(void)doSetText:(CGFloat *)bgr
{
    _slider1.value = bgr[2];
    _slider2.value = bgr[1];
    _slider3.value = bgr[0];

    _label1.text = [[NSNumber numberWithInt:bgr[2]*255] stringValue];
    _label2.text = [[NSNumber numberWithInt:bgr[1]*255] stringValue];
    _label3.text = [[NSNumber numberWithInt:bgr[0]*255] stringValue];
    
    [self sliderImageSet:bgr slider:_slider1 :2];
    [self sliderImageSet:bgr slider:_slider2 :1];
    [self sliderImageSet:bgr slider:_slider3 :0];
}

-(void) sliderImageSet:(CGFloat *)bgr slider:(UISlider *)slider :(int) index
{
    UIImage *image = sliderImage(bgr, index, 6);
    UIImage *lImg = imageFromImage(image, CGRectMake(0, 0, bgr[index]*255, image.size.height));
    UIImage *rImg = imageFromImage(image, CGRectMake(bgr[index]*255, 0, 256 - bgr[index]*255, image.size.height));
    
    [slider setMinimumTrackImage:lImg forState:UIControlStateNormal ];
    [slider setMaximumTrackImage:rImg forState:UIControlStateNormal ];
}

- (IBAction)touchUp:(id)sender {
    [_delegate colorChanged:_currentColorView.backgroundColor];
}

- (void)setLastColor:(UIColor *)color
{
    _lastColorView.backgroundColor = color;
}

@end
