//
//  LayerView.m
//  BrushTest
//
//  Created by Coding on 8/21/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "LayerControl.h"

IB_DESIGNABLE
@implementation LayerControl


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    return self;
}

- (void)layoutSubviews
{
    if( !_visableButton){
        UIImage * visableImage = [UIImage imageNamed:@"palette_layer_show_on"];
        _visableButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, visableImage.size.width, visableImage.size.height)];
        [_visableButton setImage:visableImage forState:UIControlStateNormal];
        [self addSubview:_visableButton];
    }
    
    if( !_lockButton){
        UIImage * lockImage = [UIImage imageNamed:@"palette_layer_locktrans"];
        _lockButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - lockImage.size.height, lockImage.size.width, lockImage.size.height)];
        [_lockButton setImage:lockImage forState:UIControlStateNormal];
        [self addSubview:_lockButton];
    }
}
@end

IB_DESIGNABLE
@implementation CanvasBackgroundControl

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(!_colorView){
        UIImage *maskImage = [UIImage imageNamed:@"layer_background_color_mask"];
        CGRect rect = CGRectMake((self.bounds.size.width - maskImage.size.width)/2, (self.bounds.size.height- maskImage.size.height)/2, maskImage.size.width, maskImage.size.height);
        _colorView = [[UIView alloc] initWithFrame:rect];
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
        maskLayer.contents = (id)maskImage.CGImage;
        _colorView.layer.mask = maskLayer;
        _colorView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_colorView];
    }
    if( !_visableButton){
        UIImage * visableImage = [UIImage imageNamed:@"palette_layer_show_on"];
        _visableButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, visableImage.size.width, visableImage.size.height)];
        [_visableButton setImage:visableImage forState:UIControlStateNormal];
        [self addSubview:_visableButton];
    }
}

@end
