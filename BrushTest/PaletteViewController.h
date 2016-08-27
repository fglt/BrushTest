//
//  PaletteViewController.h
//  BrushTest
//
//  Created by Coding on 8/18/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ColorModeRGB = 0,
    ColorModeHSV
} ColorMode;

@protocol PaletteViewControllerDelegate <NSObject>

- (void)colorChanged:(UIColor*) color;
- (UIColor *)currentColor;

@end

@interface PaletteViewController : UIViewController


//@property (nonatomic, strong) UIColor *color;
@property (nonatomic, weak) id<PaletteViewControllerDelegate> delegate;
@property (nonatomic) ColorMode colorMode;
- (void)setLastColor:(UIColor *)color;
@end
