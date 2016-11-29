//
//  PaintedEggshellLabel.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/28.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "PaintedEggshellLabel.h"

@implementation PaintedEggshellLabel

- (BOOL)canBecomeFirstResponder
{
    
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    return (action == @selector(copy:));
}

- (void)copy:(id)sender
{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}


- (void)attachTapHandler
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:touch];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self attachTapHandler];
    }
    return self;
}

- (void)handleTap:(UIGestureRecognizer*) recognizer
{
    [self becomeFirstResponder];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}


@end
