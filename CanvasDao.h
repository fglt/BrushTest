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

//插入Note方法
-(int) create:(Canvas*)model;

//删除Note方法
-(int) remove:(Canvas*)model;

//修改Note方法
-(int) modify:(Canvas*)model;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(Canvas*) findByName:(Canvas*)model;

@end
