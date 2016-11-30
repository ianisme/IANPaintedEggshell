//
//  IANAFHTTPSessionManager.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/30.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "IANAFHTTPSessionManager.h"

@implementation IANAFHTTPSessionManager

+ (instancetype)manager {
    IANAFHTTPSessionManager *mgr = [super manager];

    NSMutableSet *newSet = [NSMutableSet set];
 
    newSet.set = mgr.responseSerializer.acceptableContentTypes;
    [newSet addObject:@"text/html"];
    
    mgr.responseSerializer.acceptableContentTypes = newSet;
    
    return mgr;
}

@end
