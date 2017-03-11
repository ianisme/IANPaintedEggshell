//
//  PaintEggshellLogController.h
//  ZiroomerProject
//  日志文件列表页面
//  Created by ian on 16/3/7.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PaintEggshellLogType) {
    PaintEggshellLogNetWorkType = 0,
    PaintEggshellLogCrashType,
};

@interface PaintEggshellLogController : UIViewController

@property (nonatomic, assign) PaintEggshellLogType logType;

@end
