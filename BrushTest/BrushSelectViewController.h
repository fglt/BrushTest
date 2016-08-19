//
//  BrushSelectViewController.h
//  BrushTest
//
//  Created by Coding on 8/18/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Brush;

@protocol BrushSelectViewControllerDelegate <NSObject>

- (void)brushSelected:(Brush*) brush;
- (UIColor*)brushColor;
- (Brush *)currentBrush;
@end

@interface BrushSelectViewController : UIViewController
@property (nonatomic, strong) Brush* brush;
@property (nonatomic, weak) id<BrushSelectViewControllerDelegate> brushSelectViewControllerDelegate;
@end
