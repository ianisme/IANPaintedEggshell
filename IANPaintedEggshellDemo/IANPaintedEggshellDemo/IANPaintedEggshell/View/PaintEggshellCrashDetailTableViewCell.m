//
//  PaintEggshellCrashDetailTableViewCell.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 2017/3/10.
//  Copyright © 2017年 ian. All rights reserved.
//

#import "PaintEggshellCrashDetailTableViewCell.h"
#import "IANUtil.h"
#import <Masonry.h>

static CGFloat const kLeftPadding = 15.0f;
static CGFloat const kTopPadding = 7.0f;

@implementation PaintEggshellCrashDetailTableViewCell
{
    UILabel *_contentLabel;
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
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:12.0f];
    contentLabel.preferredMaxLayoutWidth = preferredWidth;
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    _contentLabel = contentLabel;
}

- (void)creatConstraint
{
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(kLeftPadding);
        make.top.equalTo(self.contentView).with.offset(kTopPadding);
        make.right.equalTo(self.contentView).with.offset(-kLeftPadding);
    }];
    
    
    [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)configCellWithString:(NSString *)string
{
    _contentLabel.text = string;
}

+ (CGFloat)heightWithString:(NSString *)string
{
    PaintEggshellCrashDetailTableViewCell *cell = [[PaintEggshellCrashDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell configCellWithString:string];
    
    [cell layoutIfNeeded];
    
    CGRect frame = cell->_contentLabel.frame;
    return frame.origin.y + frame.size.height + kTopPadding;
}

@end
