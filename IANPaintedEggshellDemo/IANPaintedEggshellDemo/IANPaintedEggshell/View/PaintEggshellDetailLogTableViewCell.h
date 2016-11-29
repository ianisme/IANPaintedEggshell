//
//  PaintEggshellDetailLogTableViewCell.h
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/28.
//  Copyright © 2016年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IANNetworkLogModel.h"

@interface PaintEggshellDetailLogTableViewCell : UITableViewCell

- (void)configCellWithModel:(IANNetworkLogModel *)model;

+ (CGFloat)heightWithModel:(IANNetworkLogModel *)model;

+ (NSString *)revertTime:(NSString *)time;

@end
