//
//  PaintEggshellLogTableViewCell.h
//  IANPaintedEggshellDemo
//
//  Created by ian on 2017/2/21.
//  Copyright © 2017年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IANNetworkLogPlistModel.h"

@interface PaintEggshellLogTableViewCell : UITableViewCell

- (void)configCellWithModel:(IANNetworkLogPlistModel *)model;

@end
