//
//  UIView+ManyTapAction.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/28.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "UIView+ManyTapAction.h"
#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

@interface UIView()

@property (nonatomic, copy) ManyTapAction manyTapAction;

@end

@implementation UIView (ManyTapAction)


#pragma mark - interface method

- (void)addManyTapAction:(NSUInteger)TapsRequired action:(ManyTapAction)manyTapAction
{
    self.manyTapAction = manyTapAction;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    recognizer.numberOfTapsRequired = TapsRequired;
    recognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:recognizer];
}


#pragma mark - tap action

- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    if (self.manyTapAction) {
        self.manyTapAction();
    }
}


#pragma mark - runtime method

- (void)setManyTapAction:(ManyTapAction)manyTapAction
{
    objc_setAssociatedObject(self, @selector(manyTapAction), manyTapAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ManyTapAction)manyTapAction
{
    return objc_getAssociatedObject(self, @selector(manyTapAction));
}

@end
