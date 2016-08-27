//
//  LayerView.h
//  BrushTest
//
//  Created by Coding on 8/21/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingLayer.h"

@interface LayerControl : UIControl
@property (nonatomic, weak) DrawingLayer *drawingLayer;
@property (nonatomic, strong) UIButton *visableButton;
@property (nonatomic, strong) UIButton *lockButton;
@property (nonatomic, strong) UILabel *mixMode;
@end

@interface CanvasBackgroundControl : UIControl
@property (nonatomic, strong) UIButton *visableButton;
@property (nonatomic, strong) UIView *colorView;
@end
