//
//  IANUtil.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 2017/2/21.
//  Copyright © 2017年 ian. All rights reserved.
//

#import "IANUtil.h"

@implementation IANUtil

+ (NSString *)revertTime:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval timeInterval = [time doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}


+ (NSString *)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] intValue];
        NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
                                 
        return fileSizeStr;
    }
    return @"未知大小";
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

@end
