//
//  PaintedEggNetworkService.h
//  IANPaintedEggshellDemo
//
//  Created by ian on 2017/3/9.
//  Copyright © 2017年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PaintedEggNetworkService : NSObject

+ (instancetype)shareInstance;

- (void)appPost:(NSString *)url parametersString:(NSString *)paramstersStr handler:(void(^)(BOOL successful, id response))handler;

- (void)appGet:(NSString *)url handler:(void(^)(BOOL successful, id response))handler;

@end
