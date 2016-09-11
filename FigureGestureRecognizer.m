//
//  CircleGestureRecognizer.m
//  BrushTest
//
//  Created by Coding on 9/10/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "FigureGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation FigureGestureRecognizer
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(_beginFigureGestureRecognizer && touches.count==1){
         _firstPoint = [[touches anyObject] locationInView:self.view];
        self.state = UIGestureRecognizerStateBegan;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.state == UIGestureRecognizerStateBegan){

        self.state = UIGestureRecognizerStateChanged;
    }
    
    if(self.state == UIGestureRecognizerStateChanged){
         _secondPoint = [[touches anyObject] locationInView:self.view];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.state == UIGestureRecognizerStateChanged){
        _secondPoint = [[touches anyObject] locationInView:self.view];
        self.state = UIGestureRecognizerStateEnded;
    }
}

- (void)reset
{
    self.state = UIGestureRecognizerStatePossible;
}
@end
