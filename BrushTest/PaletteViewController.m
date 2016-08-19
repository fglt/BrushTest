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
#import "InfHSBSupport.h"
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

@end

@implementation PaletteViewController

-(void) viewDidLoad
{
    _color = [ _delegate currentColor];

    float h, s, v;
    HSVFromUIColor(_color, &h, &s, &v);
    _circleColorPicker.hue = h;
    _squareColorPicker.hue = h;
    _squareColorPicker.point = CGPointMake(s, v);
}

- (IBAction)touchCircleColorPicker:(CircleColcorPicker*)sender {
    self.squareColorPicker.hue = sender.hue;
    CGPoint point = self.squareColorPicker.point;
    self.color = [UIColor colorWithHue:sender.hue saturation:point.x brightness:point.y alpha:1];
    float r, g,b;
    HSVtoRGB(sender.hue*360, point.x, point.y, &r, &g, &b);
    [self doSetText:r :g :b];
}
- (IBAction)touchSquareColorPicker:(SquareColorPicker*)sender {
    CGPoint point = sender.point;
    self.color = [UIColor colorWithHue:sender.hue saturation:point.x brightness:point.y alpha:1];
    float r, g,b;
    HSVtoRGB(sender.hue*360, point.x, point.y, &r, &g, &b);
    [self doSetText:r :g :b];
}
- (IBAction)moveColorSlider:(id)sender {
    float r = _slider1.value;
    float g = _slider2.value ;
    float b = _slider3.value ;
    float h, s,v;
    RGBToHSV(r, g, b, &h, &s, &v, YES);
    _circleColorPicker.hue = h;
    _squareColorPicker.hue = h;
    _squareColorPicker.point = CGPointMake(s, v);
    self.color = [UIColor colorWithRed:r green:g blue:b alpha:1];
}

-(void)doSetText:(float)rf :(float)gf :(float)bf
{
    _slider1.value = rf;
    _slider2.value = gf;
    _slider3.value = bf;
    int r = (int) (rf* 255);
    int g = (int) (gf* 255);
    int b = (int) (bf* 255);
    
    _label1.text = [[NSNumber numberWithInt:r] stringValue];
    _label2.text = [[NSNumber numberWithInt:g] stringValue];
    _label3.text = [[NSNumber numberWithInt:b] stringValue];
    
    [self sliderBGset:r :g :b :r :_slider1 :0];
    [self sliderBGset:r :g :b :g :_slider2 :1];
    [self sliderBGset:r :g :b :b :_slider3 :2];
}

-(void) sliderBGset:(int)r :(int)g :(int)b : (int) w  :(UISlider *)slider :(int) index
{
    
    UIImage * lImg = createSlideImage(r,g,b, index,true,w,6);
    UIImage * rImg = createSlideImage(r,g,b, index,false,256-w,6);
    
    [slider setMinimumTrackImage:lImg forState:UIControlStateNormal ];
    [slider setMaximumTrackImage:rImg forState:UIControlStateNormal ];
}


-(void) setColor:(UIColor *)color
{
    if(![_color isSameRGBToColor: color]){
        _color = color;
        [_delegate colorChanged:color];
    }
}

@end
