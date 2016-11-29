//
//  AppDelegate+PaintedEggshell.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/29.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "AppDelegate+PaintedEggshell.h"
#import "IANAppMacros.h"
#import "PaintedEggshellManager.h"

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

@implementation AppDelegate (PaintedEggshell)

+ (void)load
{
    Method oldMethod = class_getInstanceMethod([self class], @selector(application:didReceiveLocalNotification:));
    Method newMethod = class_getInstanceMethod([self class], @selector(ianPaintedEggshellApplication:didReceiveLocalNotification:));
    method_exchangeImplementations(oldMethod, newMethod);
}

- (void)ianPaintedEggshellApplication:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if ([[notification.userInfo objectForKey:@"id"] isEqualToString:PAINTED_EGGSHELL_LOCALNOTI]) {
         [[PaintedEggshellManager shareInstance] addPaintedEggshellLocalNotification];
    } else {
        [self ianPaintedEggshellApplication:application didReceiveLocalNotification:notification];
    }
}

@end
