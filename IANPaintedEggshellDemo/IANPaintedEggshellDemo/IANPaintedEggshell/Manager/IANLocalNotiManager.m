//
//  IANLocalNotiManager.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/28.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "IANLocalNotiManager.h"
#import <UserNotifications/UserNotifications.h>

#define IOS8_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

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

- (void)setLocalNotiManager:(NSDictionary *)localNoti andTaskId:(NSString *)taskId andLocalTime:(NSTimeInterval)time
{
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:taskId,@"id", localNoti, @"info" ,nil];
    
    if (IOS10) {
        
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
        //iOS 10 使用以下方法注册，才能得到授权
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                              }];
        
        //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
        }];

        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.title = @"Introduction to Notifications";
        content.subtitle = @"Session 707";
        content.body = @"Woah! These new notifications look amazing! Don’t you agree?";
        content.badge = @1;
        content.userInfo = infoDic;
        
        // 在 alertTime 后推送本地推送
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:10 repeats:NO];
        
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:taskId                                                                              content:content trigger:trigger];
        
        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {

        }];
               
    } else {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        if (localNotification == nil) {
            return;
        }
        
        NSDate *currentDate = [NSDate date];
        NSDate *date = [currentDate dateByAddingTimeInterval:time];
        
        localNotification.fireDate = date;
        
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotification.repeatInterval = 0;
        
        //    localNotification.alertBody = @"成功保存一个日志文件";
        //
        //    localNotification.alertAction = @"";
        //
        //    localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        // localNotification.applicationIconBadgeNumber ++;
        
        localNotification.userInfo = infoDic;
        
        
        if (IOS8_10) {
            UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                     categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
        }
       [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

- (void)cancelLocalNotiManager:(NSString *)taskId
{
    if (IOS10) {
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[taskId]];
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[taskId]];
    } else {
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
}

- (void)cancelAllLocalNotiManager
{
    if (IOS10) {
        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}


@end
