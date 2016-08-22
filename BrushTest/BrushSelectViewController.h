//
//  BrushSelectViewController.h
//  BrushTest
//
//  Created by Coding on 8/18/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brush.h"

@protocol BrushSelectViewControllerDelegate <NSObject>

- (void)brushTypeSelected:(BrushType) brushType;
- (BrushType)currentBrushType;
@end

@interface BrushSelectViewController : UIViewController
@property (nonatomic) BrushType type;
@property (nonatomic, weak) id<BrushSelectViewControllerDelegate> brushSelectViewControllerDelegate;
@end
