//
//  UIView+ManyTapAction.h
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/28.
//  Copyright © 2016年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ManyTapAction)();

@interface UIView (ManyTapAction)

- (void)addManyTapAction:(NSUInteger)TapsRequired action:(ManyTapAction)action;

@end
