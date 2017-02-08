//
//  IANAssistiveTouch.h
//  JSPatchDemo
//
//  Created by ian on 16/12/15.
//  Copyright © 2016年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IANAssistiveTouchBlock)();

@interface IANAssistiveTouch : UIView
{
    UIButton *_button;
}

@property (nonatomic, copy) IANAssistiveTouchBlock IANAssistiveTouchBlockAction;

- (id)initWithFrame:(CGRect)frame;

@end
