//
//  PaintedEggshellManager.h
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/29.
//  Copyright © 2016年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaintedEggshellManager : NSObject

+ (PaintedEggshellManager *)shareInstance;

- (void)addPaintedEggshellLocalNotification;

@end
