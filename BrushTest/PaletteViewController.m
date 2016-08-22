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
    CGFloat bgr[] ={b, g, r};
    [self doSetText:bgr];
    //NSLog(@"touchCircleColorPicker");
}
- (IBAction)touchSquareColorPicker:(SquareColorPicker*)sender {
    CGPoint point = sender.point;
    self.color = [UIColor colorWithHue:sender.hue saturation:point.x brightness:point.y alpha:1];
    float r, g,b;
    HSVtoRGB(sender.hue*360, point.x, point.y, &r, &g, &b);
    CGFloat bgr[] ={b, g, r};
    [self doSetText:bgr];
     //NSLog(@"touchSquareColorPicker");
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

    //NSLog(@"moveColorSlider");
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
    
//    if(_slider1.value != bgr[2]){
//        _slider1.value = bgr[2];
//        _label1.text = [[NSNumber numberWithInt:bgr[2]*255] stringValue];
//        [self sliderImageSet:bgr slider:_slider1 :2];
//    }
//    if(_slider2.value != bgr[1]){
//        _slider2.value = bgr[1];
//        _label2.text = [[NSNumber numberWithInt:bgr[1]*255] stringValue];
//        [self sliderImageSet:bgr slider:_slider2 :1];
//    }
//    if(_slider3.value != bgr[0]){
//        _slider3.value = bgr[0];
//        _label3.text = [[NSNumber numberWithInt:bgr[0]*255] stringValue];
//        [self sliderImageSet:bgr slider:_slider3 :0];
//    }
}

-(void) sliderImageSet:(CGFloat *)bgr slider:(UISlider *)slider :(int) index
{
    UIImage *image = sliderImage(bgr, index, 6);
    UIImage *lImg = imageFromImage(image, CGRectMake(0, 0, bgr[index]*255, image.size.height));
    UIImage *rImg = imageFromImage(image, CGRectMake(bgr[index]*255, 0, 256 - bgr[index]*255, image.size.height));
    
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
