//
//  blendModeTableViewController.h
//  BrushTest
//
//  Created by Coding on 9/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlendMode.h"

@protocol BlendModeTableViewControllerDelegate <NSObject>

- (CGBlendMode)curBlendMode;
- (void)blendModeChanged:(BlendMode *)blendMode;

@end

@interface BlendModeTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, weak) id<BlendModeTableViewControllerDelegate> controllerDelegate;

@end
