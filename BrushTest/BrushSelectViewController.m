//
//  BrushSelectViewController.m
//  BrushTest
//
//  Created by Coding on 8/18/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "BrushSelectViewController.h"
#import "Brush.h"
#import "BrushView.h"

@interface BrushSelectViewController()
@property (strong, nonatomic) IBOutlet BrushView *brushView;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;

@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@end

@implementation BrushSelectViewController

-(void)viewDidLoad
{
    _brush = [_brushSelectViewControllerDelegate currentBrush];
    _radiusSlider.value = (_brush.width-1)/30 ;
    _alphaSlider.value = CGColorGetAlpha( _brush.color.CGColor);
}
- (IBAction)radiusSliderChanged:(UISlider *)sender {
    _brush.width = sender.value*30 +1;
}
- (IBAction)alphaSliderChanged:(UISlider *)sender {
    _brush.color = [_brush.color colorWithAlphaComponent:sender.value];
}

- (IBAction)clickBrush:(UIButton *)sender {
    BrushType type;
    switch (sender.tag) {
        case 11:
            type = BrushTypeCircle;
            break;
        case 12:
            type = BrushTypeOval;
            break;
        case 13:
            type = BrushTypeGradient;
            break;
        case 14:
            type = BrushTypeChineseBrush;
            break;
        default:
            type = BrushTypeCircle;
            break;
    }
    
    UIColor *color = [[_brushSelectViewControllerDelegate brushColor] colorWithAlphaComponent:_alphaSlider.value];
    _brush = [Brush BrushWithColor:color radius:_radiusSlider.value *30 + 1 type:type];
    
    [_brushSelectViewControllerDelegate brushSelected:_brush];
}

@end
