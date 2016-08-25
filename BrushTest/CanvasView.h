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

@protocol CanvasViewDelegate <NSObject>

- (void)touchBegan:(CGPoint)point;
- (void)touchMoved:(CGPoint)point;
- (void)touchEnded:(CGPoint)point;

@end
@interface CanvasView : UIView
@property (nonatomic, weak) id<CanvasViewDelegate> delegate;

- (void)displayContent;
@end
