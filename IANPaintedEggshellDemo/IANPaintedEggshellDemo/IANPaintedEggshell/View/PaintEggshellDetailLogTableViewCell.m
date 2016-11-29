//
//  PaintEggshellDetailLogTableViewCell.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/28.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "PaintEggshellDetailLogTableViewCell.h"
#import "PaintedEggshellLabel.h"
#import <Masonry.h>

static CGFloat const kLeftPadding = 15.0f;
static CGFloat const kTopPadding = 7.0f;

@implementation PaintEggshellDetailLogTableViewCell
{
    PaintedEggshellLabel *_contentLabel;
    UILabel *_classLabel;
    UILabel *_timeLabel;
}

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
    CGFloat preferredWidth = [UIScreen mainScreen].bounds.size.width - 30;
    PaintedEggshellLabel *contentLabel = [[PaintedEggshellLabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:12.0f];
    contentLabel.preferredMaxLayoutWidth = preferredWidth;
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    _contentLabel = contentLabel;
    
    UILabel *classLabel = [[UILabel alloc] init];
    classLabel.font = [UIFont systemFontOfSize:12.0f];
    classLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:classLabel];
    _classLabel = classLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12.0f];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    _timeLabel = timeLabel;
}

- (void)creatConstraint
{
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(kLeftPadding);
        make.top.equalTo(self.contentView).with.offset(kTopPadding);
        make.right.equalTo(self.contentView).with.offset(-kLeftPadding);
        make.bottom.equalTo(_classLabel.mas_top).with.offset(-kTopPadding);
    }];
    
    [_classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentLabel);
        make.right.equalTo(_timeLabel.mas_left).with.offset(-kTopPadding);
        make.height.equalTo(@15);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-kLeftPadding);
        make.top.bottom.equalTo(_classLabel);
        make.width.equalTo(@150);
    }];
    
    [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)configCellWithModel:(IANNetworkLogModel *)model
{
    _contentLabel.text = model.contentString;
    _classLabel.text = model.classString;
    _timeLabel.text = [PaintEggshellDetailLogTableViewCell revertTime:model.timeString];
}

+ (CGFloat)heightWithModel:(IANNetworkLogModel *)model
{
    PaintEggshellDetailLogTableViewCell *cell = [[PaintEggshellDetailLogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell configCellWithModel:model];
    
    [cell layoutIfNeeded];
    
    CGRect frame = cell->_timeLabel.frame;
    return frame.origin.y + frame.size.height + kTopPadding;
}

+ (NSString *)revertTime:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval timeInterval = [time doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}


@end
