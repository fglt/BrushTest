//
//  CanvasDao.h
//  BrushTest
//
//  Created by Coding on 8/28/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "Canvas.h"

@interface CanvasDao : NSObject
@property(nonatomic, strong) NSMutableArray *listData;
@property (nonatomic,strong) NSDictionary *canvasDictionary;
@property (nonatomic,strong) NSString *canvasNameFilePath;
@property (nonatomic,strong) NSString *dir;
@property (nonatomic,strong) NSString *tempCanvasFilePath;

+ (CanvasDao*)sharedManager;

- (Canvas *)tempCanvs;
- (int)create:(Canvas*)model;


- (int)remove:(Canvas*)model;


- (int)modify:(Canvas*)model;

- (NSMutableArray*)findAll;


- (Canvas*)findByName:(Canvas*)model;

- (void)saveToFile:(Canvas *)model;
@end
