//
//  HCKSlotBaseCell.m
//  HCKEddStone
//
//  Created by aa on 2017/12/9.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSlotBaseCell.h"

@interface HCKSlotBaseCell()

@property (nonatomic, strong)UIImageView *backView;

@end

@implementation HCKSlotBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:RGBCOLOR(242, 242, 242)];
        [self.contentView addSubview:self.backView];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

/**
 获取当前cell上面的信息。先查状态位@"code",当@"code":@"1"的时候说明数据都有，可以进行设置，
 当@"code":@"2"的时候，表明某些必填项没有设置，报错
 
 @return dic
 */
- (NSDictionary *)getContentData{
    return @{};
}

#pragma mark - setter & getter

- (UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc] init];
        _backView.image = LOADIMAGE(@"scanHeaderViewBackIcon", @"png");
        _backView.userInteractionEnabled = YES;
    }
    return _backView;
}

@end
