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

static UIImage *showOnImage;
static UIImage *showOffImage;
static UIImage *lockImage;
static UIImage *unlockImage;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    _visible = YES;
    _locked =  NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        showOnImage = [UIImage imageNamed:@"palette_layer_show_on"];
        showOffImage = [UIImage imageNamed:@"palette_layer_show_off"];
        lockImage = [UIImage imageNamed:@"palette_layer_locktrans"];
        unlockImage = [UIImage imageNamed:@"palette_layer_unlocktrans"];
    });
    return self;
}

- (void) updateContents
{
    self.layer.contents = _drawingLayer.layer.contents;
}
- (void)layoutSubviews
{
    if( !_visableButton){
        _visableButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, showOnImage.size.width, showOnImage.size.height)];
        [_visableButton setImage:showOnImage forState:UIControlStateNormal];
        [self addSubview:_visableButton];
        [_visableButton addTarget:self action:@selector(visityChanged) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if( !_lockButton){
        _lockButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - unlockImage.size.height, unlockImage.size.width, unlockImage.size.height)];
        [_lockButton setImage:unlockImage forState:UIControlStateNormal];
        [self addSubview:_lockButton];
        [_lockButton addTarget:self action:@selector(lockChanged) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)visityChanged
{
    self.visible = !self.visible;
    [_LayerControlDelegate visableChanged];
}

- (void)lockChanged
{
    self.locked = !self.locked;
}

- (void)setVisible:(BOOL)visible{
    if(_visible != visible){
         _visible = visible;
        if(_visible){
            [_visableButton setImage:showOnImage forState:UIControlStateNormal];
        }else{
            [_visableButton setImage:showOffImage forState:UIControlStateNormal];
        }
    }
    self.drawingLayer.visible = _visible;
}

- (void)setLocked:(BOOL)locked{
    if(_locked != locked){
        _locked = locked;
        if(_locked){
            [_lockButton setImage:lockImage forState:UIControlStateNormal];
        }else{
            [_lockButton setImage:unlockImage forState:UIControlStateNormal];
        }
    }
    self.drawingLayer.locked = _locked;
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
    if( !_visibleButton){
        UIImage * visableImage = [UIImage imageNamed:@"palette_layer_show_on"];
        _visibleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, visableImage.size.width, visableImage.size.height)];
        [_visibleButton setImage:visableImage forState:UIControlStateNormal];
        [self addSubview:_visibleButton];
    }
}

@end
