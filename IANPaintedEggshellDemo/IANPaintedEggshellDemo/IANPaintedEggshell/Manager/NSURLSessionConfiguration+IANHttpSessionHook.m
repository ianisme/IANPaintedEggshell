//
//  NSURLSessionConfiguration+IANHttpSessionHook.m
//  IANInterceptHttp
//
//  Created by ian on 2017/1/9.
//  Copyright © 2017年 ian. All rights reserved.
//

#import "NSURLSessionConfiguration+IANHttpSessionHook.h"
#import "IANCustomDataProtocol.h"

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

@implementation NSURLSessionConfiguration (IANHttpSessionHook)

+ (NSURLSessionConfiguration *)zw_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self zw_defaultSessionConfiguration];
    NSArray *protocolClasses = @[[IANCustomDataProtocol class]];
    configuration.protocolClasses = protocolClasses;
    
    return configuration;
}

+ (void)load{
    Method systemMethod = class_getClassMethod([NSURLSessionConfiguration class], @selector(defaultSessionConfiguration));
    Method zwMethod = class_getClassMethod([self class], @selector(zw_defaultSessionConfiguration));
    method_exchangeImplementations(systemMethod, zwMethod);
    
    [NSURLProtocol registerClass:[IANCustomDataProtocol class]];
}

@end
