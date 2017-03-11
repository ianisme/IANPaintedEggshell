//
//  PaintEggshellLogRequestListTableViewCell.h
//  IANPaintedEggshellDemo
//  网络日志rquest页面的cell
//  Created by ian on 2017/3/8.
//  Copyright © 2017年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IANNetworkLogModel.h"

@interface PaintEggshellLogRequestListTableViewCell : UITableViewCell

- (void)configCellWithModel:(IANNetworkLogModel *)model;

+ (CGFloat)heightWithModel:(IANNetworkLogModel *)model;

@end
