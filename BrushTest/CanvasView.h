//
//  BrushView.h
//  BrushTest
//
//  Created by Coding on 8/5/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Canvas;
@class DrawingLayer;
@interface CanvasView : UIView
@property (nonatomic, strong) Canvas *canvas;

- (void)displayContent;
- (void)addLayer:(DrawingLayer *)layer;
- (void)addLayer;
- (void)setForelayer:(DrawingLayer *)layer;
@end
