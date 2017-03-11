//
//  PaintedEggshellController.h
//  IANPaintedEggshellDemo
//  彩蛋主页面
//  Created by ian on 16/11/28.
//  Copyright © 2016年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintedEggshellController : UIViewController

@property (nonatomic, assign) NSUInteger selectedIndex;

// 是否打开搜集网络日志的开关
@property (nonatomic, assign) BOOL isOpenNetworkLog;

// 是否打开搜集崩溃日志的开关
@property (nonatomic, assign) BOOL isOpenCrashLog;

@end
