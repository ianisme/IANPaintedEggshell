//
//  PaintEggshellLogTableViewCell.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 2017/2/21.
//  Copyright © 2017年 ian. All rights reserved.
//

#import "PaintEggshellLogTableViewCell.h"
#import <Masonry.h>

@interface PaintEggshellLogTableViewCell()

@property (nonatomic, strong) UILabel *myLeftLabel;

@property (nonatomic, strong) UILabel *myRightLabel;

@end

@implementation PaintEggshellLogTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
        [self creatConstraint];
    }
    return self;
}

- (void)creatView
{
    _myLeftLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_myLeftLabel];
    _myLeftLabel.font = [UIFont systemFontOfSize:14.0f];

    _myRightLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_myRightLabel];
    _myRightLabel.font = [UIFont systemFontOfSize:14.0f];
    _myRightLabel.textAlignment = NSTextAlignmentRight;
}

- (void)creatConstraint
{
    [_myRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(0);
        make.width.mas_equalTo(100.0f);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_myLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(_myRightLabel.mas_left).with.offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)configCellWithModel:(IANNetworkLogPlistModel *)model
{
    _myRightLabel.text = model.rightLabelTitle;
    _myLeftLabel.text = model.leftLabelTitle;
}

@end
