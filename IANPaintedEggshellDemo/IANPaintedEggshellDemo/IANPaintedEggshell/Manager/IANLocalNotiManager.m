//
//  IANLocalNotiManager.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/28.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "IANLocalNotiManager.h"

@implementation IANLocalNotiManager

+ (IANLocalNotiManager *)shareInstance
{
    static IANLocalNotiManager *_sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)setLocalNotiManager:(NSDictionary *)localNoti andTaskId:(NSString *)taskId andLocalTime:(NSDate *)time
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification == nil) {
        return;
    }
    
    localNotification.fireDate = time;
    
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.repeatInterval = 0;
    
    //    localNotification.alertBody = @"成功保存一个日志文件";
    //
    //    localNotification.alertAction = @"";
    //
    //    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    // localNotification.applicationIconBadgeNumber ++;
    
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:taskId,@"id", time,@"time", localNoti, @"info" ,nil];
    localNotification.userInfo = infoDic;
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)cancelLocalNotiManager:(NSString *)taskId
{
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (!notificaitons || notificaitons.count <= 0) {
        return;
    }
    for (UILocalNotification *notify in notificaitons) {
        if ([[notify.userInfo objectForKey:@"id"] isEqualToString:taskId]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
            break;
        }
    }
}

- (void)cancelAllLocalNotiManager
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


@end
