//
//  PaintedEggshellManager.h
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/29.
//  Copyright © 2016年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate+PaintedEggshell.h"
#import "IANAppMacros.h"

@interface PaintedEggshellManager : NSObject

@property (nonatomic, strong) NSMutableArray *networkLogArray;

+ (PaintedEggshellManager *)shareInstance;

- (void)addPaintedEggshellLocalNotification;

@end
