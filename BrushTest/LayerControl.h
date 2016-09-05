//
//  LayerView.h
//  BrushTest
//
//  Created by Coding on 8/21/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingLayer.h"

@protocol LayerControlDelegate <NSObject>

- (void)visableChanged;

@end
@interface LayerControl : UIControl
@property (nonatomic, weak) id<LayerControlDelegate> LayerControlDelegate;
@property (nonatomic, weak) DrawingLayer *drawingLayer;
@property (nonatomic, strong) UIButton *visableButton;
@property (nonatomic, strong) UIButton *lockButton;
@property (nonatomic, strong) UILabel *mixMode;
@property (nonatomic) BOOL visible;
@property (nonatomic) BOOL locked;
- (void)updateContents;
@end

@interface CanvasBackgroundControl : UIControl
@property (nonatomic, strong) UIButton *visibleButton;
@property (nonatomic, strong) UIView *colorView;
@end
