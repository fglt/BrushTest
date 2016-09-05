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
        
        fileExits = [manager fileExistsAtPath:sharedManager.tempCanvasFilePath];
        if(fileExits){
            sharedManager.canvasDictionary = [NSDictionary dictionaryWithContentsOfFile:sharedManager.tempCanvasFilePath];
        }
    });
    return sharedManager;
}

-(Canvas *) tempCanvs
{
    Canvas *canvas;
    
    if(_canvasDictionary){
        canvas = [Canvas canvasWithDictionary:_canvasDictionary];
    }
    return canvas;
}

-(int) create:(Canvas*)model
{
    _canvasDictionary = model.dictionary;
    [_canvasDictionary writeToFile:_tempCanvasFilePath atomically:YES];
    return 0;
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
    _canvasDictionary = model.dictionary;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       [_canvasDictionary writeToFile:_tempCanvasFilePath atomically:YES];
                   });
    
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

- (void)saveToFile:(Canvas *)model
{
    _canvasDictionary = model.dictionary;
    NSString *path = [_dir stringByAppendingPathComponent:[model.canvasName stringByAppendingPathExtension:@"plist"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       [_canvasDictionary writeToFile:path atomically:YES];
                       [_canvasDictionary writeToFile:_tempCanvasFilePath atomically:YES];
                       [_listData addObject:model.canvasName];
                       [_listData writeToFile:_canvasNameFilePath atomically:YES];
                   });
}

@end
