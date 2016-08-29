//
//  CanvasDao.m
//  BrushTest
//
//  Created by Coding on 8/28/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "CanvasDao.h"
#import "constants.h"
#import "UIColor+BFPaperColors.h"
#import "DrawingLayerModel.h"
#import "DrawingLayer.h"

@implementation CanvasDao

static CanvasDao *sharedManager;
+ (CanvasDao*)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[CanvasDao alloc] init];
        sharedManager.dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSFileManager *manager = [ NSFileManager defaultManager];
        
        sharedManager.tempCanvasFilePath = [sharedManager.dir stringByAppendingPathComponent:@"tempCanvas.plist"];
        sharedManager.canvasNameFilePath = [sharedManager.dir stringByAppendingPathComponent:CanvasNameFileName];
        BOOL  fileExits = [manager fileExistsAtPath:sharedManager.canvasNameFilePath];
        if(fileExits){
            sharedManager.listData = [NSMutableArray arrayWithContentsOfFile:sharedManager.canvasNameFilePath];
        }
        
        if(sharedManager.listData  == nil)
            sharedManager.listData = [NSMutableArray array];
    });
    return sharedManager;
}

-(int) create:(Canvas*)model
{
    sharedManager.canvasDictionary = model.dictionary;
    return [sharedManager.listData writeToFile:_tempCanvasFilePath atomically:YES];
}

-(int) remove:(Canvas*)model
{
    [_listData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqualToString:model.canvasName]){
            [_listData removeObjectAtIndex:idx];
            NSError *err;
            NSString *path = [_dir  stringByAppendingPathComponent:[obj stringByAppendingPathExtension:@"plist"]];

            [[ NSFileManager defaultManager] removeItemAtPath:path error:&err];
            *stop = TRUE;
        }
    }];
    
    return 0;
}

-(int) modify:(Canvas*)model
{
    [_listData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqualToString:model.canvasName]){
            NSString *path = [_dir  stringByAppendingPathComponent:[obj stringByAppendingPathExtension:@"plist"]];
            [_canvasDictionary writeToFile:path atomically:YES];
            *stop = TRUE;
        }
    }];
    
    return 0;
}

//查询所有数据方法
-(NSMutableArray*) findAll
{
    NSMutableArray *array = [NSMutableArray array];
    [_listData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path = [_dir  stringByAppendingPathComponent:[obj stringByAppendingPathExtension:@"plist"]];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        [array addObject:dict];
        
    }];
    return array;
}

//按照主键查询数据方法
-(Canvas*) findByName:(Canvas*)model
{
    __block NSDictionary *dict;
    [_listData enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqualToString:model.canvasName]){
            NSString *path = [_dir  stringByAppendingPathComponent:[obj stringByAppendingPathExtension:@"plist"]];
            dict = [NSDictionary dictionaryWithContentsOfFile:path];
            *stop = TRUE;
        }
    }];
    
    return [Canvas canvasWithDictionary:dict];
}

@end
