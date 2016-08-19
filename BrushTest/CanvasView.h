//
//  BrushView.h
//  BrushTest
//
//  Created by Coding on 8/5/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  Brush;
@interface CanvasView : UIImageView
@property (nonatomic, strong) Brush* currentBrush;

- (void)clear;
- (void)undo;
- (void)redo;
@end
