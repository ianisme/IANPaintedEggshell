//
//  PaintedEggshellManager.h
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/29.
//  Copyright © 2016年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IANAppMacros.h"

@interface PaintedEggshellManager : NSObject

@property (nonatomic, strong) NSMutableArray *networkLogArray;

@property (nonatomic, assign) NSUInteger tempTimeStamp;

@property (nonatomic, assign) BOOL isDisplayPaintedEggVC;

+ (PaintedEggshellManager *)shareInstance;

- (void)configInitData;

- (void)savePaintedEggshellNetworkLogPlist;



@end
