//
//  ColorPicker.m
//  BrushTest
//
//  Created by Coding on 8/17/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "ColorPicker.h"
#import "CircleColcorPicker.h"
#import "SquareColorPicker.h"

@interface ColorPicker()
@property (nonatomic, strong) CircleColcorPicker* circlePicker;
@property (nonatomic, strong) SquareColorPicker* squarePicker;
@end

IB_DESIGNABLE
@implementation ColorPicker

- (void) layoutSubviews
{
    
    if(_circlePicker == nil){
        _circlePicker = [[CircleColcorPicker  alloc] initWithFrame:self.bounds];
        [self addSubview:_circlePicker];
    }
    if (_squarePicker == nil) {
        _squarePicker = [[ SquareColorPicker alloc] initWithFrame:CGRectInset(self.bounds, 100,100)];
        [self addSubview: _squarePicker];
    }
}

@end
