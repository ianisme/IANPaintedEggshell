//
//  PaintedEggshellManager.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/29.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "PaintedEggshellManager.h"
#import "IANAppMacros.h"
#import "IANAssistiveTouch.h"
#import "PaintedEggshellController.h"
#import "IANCustomDataProtocol.h"

@implementation PaintedEggshellManager

+ (PaintedEggshellManager *)shareInstance
{
    static PaintedEggshellManager *_sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


- (void)savePaintedEggshellNetworkLogPlist
{
    if (self.networkLogArray.count == 0) {
        self.networkLogArray = [@[] mutableCopy];
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *codePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/PaintedNetworkLog/",codePath[0]];
    
    if(![fileManager fileExistsAtPath:path]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSLog(@"first run");
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@%zd.plist",path,(long)[[NSDate date] timeIntervalSince1970]];
    NSLog(@"%@",filePath);
    [NSKeyedArchiver archiveRootObject:self.networkLogArray toFile:filePath];
    [self.networkLogArray removeAllObjects];
}

- (void)configInitData
{
    [NSURLProtocol registerClass:[IANCustomDataProtocol class]];
    
    NSString *paintedEggshellIndex = [[NSUserDefaults standardUserDefaults] stringForKey:PAINTED_EGGSHELL_INDEX];
    NSString *paintedEggshellLogIsOpen = [[NSUserDefaults standardUserDefaults] stringForKey:PAINTED_EGGSHELL_LOG_ISOPEN];
    NSString *paintedEggshellCrashLogIsOpen = [[NSUserDefaults standardUserDefaults] stringForKey:PAINTED_EGGSHELL_CRASH_LOG_ISOPEN];
    PaintedEggshellController *controller = [[PaintedEggshellController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.selectedIndex = paintedEggshellIndex.integerValue;
    controller.isOpenNetworkLog = paintedEggshellLogIsOpen.integerValue;
    controller.isOpenCrashLog = paintedEggshellCrashLogIsOpen.integerValue;
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), queue, ^{
        IANAssistiveTouch *win = [[IANAssistiveTouch alloc] initWithFrame:CGRectMake(0, 80, 44, 44)];
        win.IANAssistiveTouchBlockAction = ^{

            if (!self.isDisplayPaintedEggVC) {

                if ([paintedEggshellLogIsOpen isEqualToString:@"1"]) {
                    [[PaintedEggshellManager shareInstance] savePaintedEggshellNetworkLogPlist];
                }
                
                NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
                NSInteger intervalInt = round(interval);
                self.tempTimeStamp = intervalInt;
                
                self.isDisplayPaintedEggVC = YES;
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navController animated:YES completion:nil];
            } else {
                self.isDisplayPaintedEggVC = NO;
                [navController dismissViewControllerAnimated:YES completion:nil];
            }
            
        };
    });

}


@end
