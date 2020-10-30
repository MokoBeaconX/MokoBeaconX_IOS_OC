//
//  HCKScanBaseCell.m
//  HCKEddStone
//
//  Created by aa on 2017/12/4.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKScanBaseCell.h"

@interface HCKScanBaseCell()

/**
 顶部细线
 */
@property (nonatomic, strong)UIView *topLine;

@end

@implementation HCKScanBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_WHITE_MACROS;
        [self.contentView addSubview:self.topLine];
    }
    return self;
}

#pragma mark -
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _topLine;
}

+ (CGFloat)getCellHeight{
    return 44.0f;
}

@end
