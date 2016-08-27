//
//  UIView+FGTDrawing.m
//  BrushTest
//
//  Created by Coding on 8/26/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "UIView+FGTDrawing.h"

@implementation UIView (FGTDrawing)

- (BOOL)activity{
    return self.userInteractionEnabled;
}

- (void)setActivity:(BOOL)activity{
    self.userInteractionEnabled = activity;
    self.alpha = activity ? 1 : 0.4;
}
@end
