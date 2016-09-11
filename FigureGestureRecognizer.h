//
//  CircleGestureRecognizer.h
//  BrushTest
//
//  Created by Coding on 9/10/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FigureGestureRecognizer : UIGestureRecognizer
@property (nonatomic) BOOL beginFigureGestureRecognizer;
@property (nonatomic) CGPoint firstPoint;
@property (nonatomic) CGPoint secondPoint;
@end
