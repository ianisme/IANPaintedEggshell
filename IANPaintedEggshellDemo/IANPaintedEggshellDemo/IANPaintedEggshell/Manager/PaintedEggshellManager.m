//
//  PaintedEggshellManager.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/29.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "PaintedEggshellManager.h"
#import "IANAppMacros.h"
#import "IANLocalNotiManager.h"

@implementation PaintedEggshellManager

+ (PaintedEggshellManager *)shareInstance
{
    static PaintedEggshellManager *_sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)addPaintedEggshellLocalNotification
{
    NSString *paintedEggshellLogIsOpen = [[NSUserDefaults standardUserDefaults] stringForKey:PAINTED_EGGSHELL_LOG_ISOPEN];
    if ([paintedEggshellLogIsOpen isEqualToString:@"1"]) {
        
        [self savePaintedEggshellNetworkLogPlist];
        
        [[IANLocalNotiManager shareInstance] cancelLocalNotiManager:PAINTED_EGGSHELL_LOCALNOTI];
        // 设置保存日志文件的时间为10秒一次
        NSDate *currentDate = [NSDate date];
        NSDate *date = [currentDate dateByAddingTimeInterval:PAINTED_EGGSHELL_LOG_TIME];
        [[IANLocalNotiManager shareInstance] setLocalNotiManager:@{} andTaskId:PAINTED_EGGSHELL_LOCALNOTI andLocalTime:date];
    } else {
        [[IANLocalNotiManager shareInstance] cancelLocalNotiManager:PAINTED_EGGSHELL_LOCALNOTI];
    }
}

- (void)savePaintedEggshellNetworkLogPlist
{
//    if ([WebServiceConfigMG sharedInstance].networkLogArray.count == 0) {
//        [WebServiceConfigMG sharedInstance].networkLogArray = [@[] mutableCopy];
//        return;
//    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *codePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/NetworkLog/",codePath[0]];
    
    if(![fileManager fileExistsAtPath:path]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSLog(@"first run");
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@%zd.plist",path,(long)[[NSDate date] timeIntervalSince1970]];
    NSLog(@"%@",filePath);
//    [NSKeyedArchiver archiveRootObject:[WebServiceConfigMG sharedInstance].networkLogArray toFile:filePath];
//    [[WebServiceConfigMG sharedInstance].networkLogArray removeAllObjects];
}

@end
