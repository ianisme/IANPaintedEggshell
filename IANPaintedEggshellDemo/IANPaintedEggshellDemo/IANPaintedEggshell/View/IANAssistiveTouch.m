//
//  IANAssistiveTouch.m
//  JSPatchDemo
//
//  Created by ian on 16/12/15.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "IANAssistiveTouch.h"

@implementation IANAssistiveTouch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //        self.windowLevel = UIWindowLevelAlert + 1;
        //        //这句话很重要
        //        [self makeKeyAndVisible];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor clearColor];
        //        [_button setBackgroundImage:[UIImage imageNamed:@"ianEggLogo"] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:[self getAppIconName]] forState:UIControlStateNormal];
        _button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _button.layer.cornerRadius = 5;
        _button.clipsToBounds = YES;
        //设置边框颜色
        _button.layer.borderColor = [[UIColor redColor] CGColor];
        //设置边框宽度
        _button.layer.borderWidth = 1.0f;
        
        [_button addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        //放一个拖动手势，用来改变控件的位置
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
        [_button addGestureRecognizer:pan];
    }
    return self;
}

//按钮事件
- (void)choose
{
    if (self.IANAssistiveTouchBlockAction) {
        self.IANAssistiveTouchBlockAction();
    }
}
//手势事件 －－ 改变位置
- (void)changePostion:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGRect originalFrame = self.frame;
    if (originalFrame.origin.x >= 0 && originalFrame.origin.x+originalFrame.size.width <= width) {
        originalFrame.origin.x += point.x;
    }
    if (originalFrame.origin.y >= 0 && originalFrame.origin.y+originalFrame.size.height <= height) {
        originalFrame.origin.y += point.y;
    }
    self.frame = originalFrame;
    [pan setTranslation:CGPointZero inView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _button.enabled = NO;
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
    } else {
        
        CGRect frame = self.frame;
        //记录是否越界
        BOOL isOver = NO;
        
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
            isOver = YES;
        } else if (frame.origin.x+frame.size.width > width) {
            frame.origin.x = width - frame.size.width;
            isOver = YES;
        }
        
        if (frame.origin.y < 0) {
            frame.origin.y = 0;
            isOver = YES;
        } else if (frame.origin.y+frame.size.height > height) {
            frame.origin.y = height - frame.size.height;
            isOver = YES;
        }
        if (isOver) {
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = frame;
            }];
        }
        _button.enabled = YES;
    }
}

- (NSString *)getAppIconName
{
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    //获取app中所有icon名字数组
    NSArray *iconsArr = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    //取最后一个icon的名字
    NSString *iconLastName = [iconsArr lastObject];
    
    return iconLastName;
    //打印icon名字
    //    NSLog(@"iconsArr: %@", iconsArr);
    //    NSLog(@"iconLastName: %@", iconLastName);
    /*
     打印日志：
     iconsArr: (
     AppIcon29x29,
     AppIcon40x40,
     AppIcon60x60
     )
     iconLastName: AppIcon60x60
     */
}

@end
