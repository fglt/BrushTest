//
//  LayerEditView.m
//  BrushTest
//
//  Created by Coding on 8/26/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "LayerEditView.h"

@implementation LayerEditView

- (void)layoutSubviews{
    [super layoutSubviews];
    _blendMode.layer.borderWidth = 1;
    _blendMode.layer.borderColor = [UIColor grayColor].CGColor;

}
@end
