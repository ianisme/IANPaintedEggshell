//
//  PaintedEggUncaughtExceptionHandler.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 2017/3/10.
//  Copyright © 2017年 ian. All rights reserved.
//

#import "PaintedEggUncaughtExceptionHandler.h"

// 崩溃时的回调函数
void UncaughtExceptionHandler(NSException * exception) {
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason]; // // 崩溃的原因  可以有崩溃的原因(数组越界,字典nil,调用未知方法...) 崩溃的控制器以及方法
    NSString * name = [exception name];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];

//    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *codePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/PaintedCrashLog/",codePath[0]];
    
    if(![fileManager fileExistsAtPath:path]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSLog(@"first run");
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@%zd.txt",path,(long)[[NSDate date] timeIntervalSince1970]];
    NSLog(@"%@",filePath);

    [url writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

@implementation PaintedEggUncaughtExceptionHandler

+ (void)setDefaultHandler {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

@end
