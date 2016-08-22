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
@end

@implementation BrushSelectViewController

- (IBAction)clickBrush:(UIButton *)sender {
    switch (sender.tag) {
        case 11:
            self.type = BrushTypeCircle;
            break;
        case 12:
            self.type = BrushTypeOval;
            break;
        case 13:
            self.type = BrushTypeGradient;
            break;
        case 14:
            self.type = BrushTypeChineseBrush;
            break;
        default:
            self.type = BrushTypeCircle;
            break;
    }
    [_brushSelectViewControllerDelegate brushTypeSelected:_type];
}

@end
