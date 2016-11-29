//
//  IANNetworkLogModel.h
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/28.
//  Copyright © 2016年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IANNetworkLogModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *contentString;

@property (nonatomic, copy) NSString *classString;

@property (nonatomic, copy) NSString *timeString;

@end
