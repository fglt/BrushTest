//
//  DrawingLayerModal.h
//  BrushTest
//
//  Created by Coding on 8/28/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingLayerModel : NSObject
@property (nonatomic) CGBlendMode blendMode;
@property (nonatomic) BOOL visible;
@property (nonatomic) BOOL locked;
@property (nonatomic) CGFloat alpha;
@end
