//
//  blendMode.h
//  BrushTest
//
//  Created by Coding on 9/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlendMode : NSObject
@property (nonatomic) CGBlendMode blendMode;
@property (nonatomic,strong) NSString *blendModeName;
- (instancetype) initWithMode:(CGBlendMode)mode description:(NSString *)desc;
@end
