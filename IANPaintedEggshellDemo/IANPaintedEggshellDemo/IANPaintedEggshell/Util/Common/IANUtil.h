//
//  IANUtil.h
//  IANPaintedEggshellDemo
//
//  Created by ian on 2017/2/21.
//  Copyright © 2017年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IANUtil : NSObject

+ (NSString *)revertTime:(NSString *)time;

+ (NSString *)fileSizeAtPath:(NSString*)filePath;

+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

@end
