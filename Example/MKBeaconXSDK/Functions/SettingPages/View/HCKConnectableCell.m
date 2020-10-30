//
//  HCKConnectableCell.m
//  HCKEddStone
//
//  Created by aa on 2018/1/23.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKConnectableCell.h"

static NSString *const HCKConnectableCellIdenty = @"HCKConnectableCellIdenty";

@interface HCKConnectableCell()

@property (nonatomic, strong)UISwitch *switchView;

@end

@implementation HCKConnectableCell

+ (HCKConnectableCell *)initCellWithTableView:(UITableView *)tableView{
    HCKConnectableCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKConnectableCellIdenty];
    if (!cell) {
        cell = [[HCKConnectableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKConnectableCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.switchView];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - Private method
- (void)switchViewValueChanged{
    if (self.connectStatusChangedBlock) {
        self.connectStatusChangedBlock(self.switchView.isOn);
    }
}

#pragma mark - Public method
- (void)setIsOn:(BOOL)isOn{
    [self.switchView setOn:isOn];
}

#pragma mark - setter & getter
- (UISwitch *)switchView{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.backgroundColor = COLOR_WHITE_MACROS;
        [_switchView addTarget:self
                        action:@selector(switchViewValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

@end
