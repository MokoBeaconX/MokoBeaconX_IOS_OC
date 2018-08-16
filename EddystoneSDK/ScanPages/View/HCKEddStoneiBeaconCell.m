//
//  HCKEddStoneiBeaconCell.m
//  HCKEddStone
//
//  Created by aa on 2017/12/27.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKEddStoneiBeaconCell.h"

static NSString *const HCKEddStoneiBeaconCellIdenty = @"HCKEddStoneiBeaconCellIdenty";

static CGFloat const offset_X = 10.f;
static CGFloat const offset_Y = 10.f;
static CGFloat const leftIconWidth = 13.f;
static CGFloat const leftIconHeight = 13.f;

#define msgFont HCKFont(12.f)

@interface HCKEddStoneiBeaconCell()

/**
 小蓝点
 */
@property (nonatomic, strong)UIImageView *leftIcon;

/**
 类型,UID
 */
@property (nonatomic, strong)UILabel *typeLabel;

/**
 RSSI@0m
 */
@property (nonatomic, strong)UILabel *rssiLabel;

/**
 发射功率
 */
@property (nonatomic, strong)UILabel *txPowerLabel;

/**
 uuid
 */
@property (nonatomic, strong)UILabel *uuidLabel;

/**
 uuid值
 */
@property (nonatomic, strong)UILabel *uuidIDLabel;

/**
 主值
 */
@property (nonatomic, strong)UILabel *majorLabel;

@property (nonatomic, strong)UILabel *majorIDLabel;

/**
 次值
 */
@property (nonatomic, strong)UILabel *minorLabel;

@property (nonatomic, strong)UILabel *minorIDLabel;

@end

@implementation HCKEddStoneiBeaconCell

+ (HCKEddStoneiBeaconCell *)initCellWithTableView:(UITableView *)tableView{
    HCKEddStoneiBeaconCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKEddStoneiBeaconCellIdenty];
    if (!cell) {
        cell = [[HCKEddStoneiBeaconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKEddStoneiBeaconCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.txPowerLabel];
        [self.contentView addSubview:self.uuidLabel];
        [self.contentView addSubview:self.uuidIDLabel];
        [self.contentView addSubview:self.majorLabel];
        [self.contentView addSubview:self.majorIDLabel];
        [self.contentView addSubview:self.minorLabel];
        [self.contentView addSubview:self.minorIDLabel];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(leftIconWidth);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(leftIconHeight);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(HCKFont(15).lineHeight);
    }];
    [self.rssiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.typeLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.txPowerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.typeLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.uuidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.uuidIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_left);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.uuidLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.majorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.uuidLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.majorIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_left);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.majorLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.minorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.majorLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.minorIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_left);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.minorLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
}

#pragma mark - Private method

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

#pragma mark - Public method
- (void)setBeacon:(MKReceiveiBeacon *)beacon{
    _beacon = nil;
    _beacon = beacon;
    if (!_beacon) {
        return;
    }
    if (ValidStr(_beacon.uuid)) {
        [self.uuidIDLabel setText:_beacon.uuid];
    }
    if (ValidStr(_beacon.major)) {
        [self.majorIDLabel setText:_beacon.major];
    }
    if (ValidStr(_beacon.minor)) {
        [self.minorIDLabel setText:_beacon.minor];
    }
    if (ValidStr(_beacon.txPower)) {
        [self.txPowerLabel setText:[NSString stringWithFormat:@"%@%@",_beacon.txPower,@"dBm"]];
    }
}

#pragma mark - setter & getter
- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADIMAGE(@"littleBluePoint", @"png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [self createLabelWithFont:HCKFont(15.f)];
        _typeLabel.text = @"iBeacon";
    }
    return _typeLabel;
}

- (UILabel *)rssiLabel{
    if (!_rssiLabel) {
        _rssiLabel = [self createLabelWithFont:msgFont];
        _rssiLabel.text = @"RSSI@1m:";
    }
    return _rssiLabel;
}

- (UILabel *)txPowerLabel{
    if (!_txPowerLabel) {
        _txPowerLabel = [self createLabelWithFont:msgFont];
        _txPowerLabel.text = @"0dBm";
    }
    return _txPowerLabel;
}

- (UILabel *)uuidLabel{
    if (!_uuidLabel) {
        _uuidLabel = [self createLabelWithFont:msgFont];
        _uuidLabel.textColor = RGBCOLOR(184, 184, 184);
        _uuidLabel.text = @"UUID";
    }
    return _uuidLabel;
}

- (UILabel *)uuidIDLabel{
    if (!_uuidIDLabel) {
        _uuidIDLabel = [self createLabelWithFont:msgFont];
    }
    return _uuidIDLabel;
}

- (UILabel *)majorLabel{
    if (!_majorLabel) {
        _majorLabel = [self createLabelWithFont:msgFont];
        _majorLabel.textColor = RGBCOLOR(184, 184, 184);
        _majorLabel.text = @"Major";
    }
    return _majorLabel;
}

- (UILabel *)majorIDLabel{
    if (!_majorIDLabel) {
        _majorIDLabel = [self createLabelWithFont:msgFont];
    }
    return _majorIDLabel;
}

- (UILabel *)minorLabel{
    if (!_minorLabel) {
        _minorLabel = [self createLabelWithFont:msgFont];
        _minorLabel.textColor = RGBCOLOR(184, 184, 184);
        _minorLabel.text = @"Minor";
    }
    return _minorLabel;
}

- (UILabel *)minorIDLabel{
    if (!_minorIDLabel) {
        _minorIDLabel = [self createLabelWithFont:msgFont];
    }
    return _minorIDLabel;
}

@end
