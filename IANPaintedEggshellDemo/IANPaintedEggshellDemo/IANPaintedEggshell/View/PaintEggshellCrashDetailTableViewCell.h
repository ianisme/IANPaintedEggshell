//
//  PaintEggshellCrashDetailTableViewCell.h
//  IANPaintedEggshellDemo
//
//  Created by ian on 2017/3/10.
//  Copyright © 2017年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintEggshellCrashDetailTableViewCell : UITableViewCell

- (void)configCellWithString:(NSString *)string;

+ (CGFloat)heightWithString:(NSString *)string;

@end
