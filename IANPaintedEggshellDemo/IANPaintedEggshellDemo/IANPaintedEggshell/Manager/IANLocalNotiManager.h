//
//  IANLocalNotiManager.h
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/28.
//  Copyright © 2016年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IANLocalNotiManager : NSObject

+ (IANLocalNotiManager *)shareInstance;

- (void)setLocalNotiManager:(NSDictionary *)localNoti andTaskId:(NSString *)taskId andLocalTime:(NSTimeInterval)time;

- (void)cancelLocalNotiManager:(NSString *)taskId;

- (void)cancelAllLocalNotiManager;

@end
