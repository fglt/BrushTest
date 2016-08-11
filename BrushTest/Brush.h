//
//  Brush.h
//  BrushTest
//
//  Created by Coding on 8/11/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    BrushTypePath,
    BrushTypeCircle,
    BrushTypeEllipse,
    BrushTypeGradient,
    BrushTypeChineseBrush
} BrushType;


@interface Brush : NSObject<NSCopying>
@property (nonatomic) CGFloat radius;
@property (nonatomic, copy) UIColor* color;
@property (nonatomic) BrushType brushType;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
