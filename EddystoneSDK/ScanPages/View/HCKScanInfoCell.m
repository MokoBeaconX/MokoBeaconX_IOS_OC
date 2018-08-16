//
//  HCKScanInfoCell.m
//  HCKEddStone
//
//  Created by aa on 2017/12/29.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKScanInfoCell.h"

static NSString *const HCKScanInfoCellIdenty = @"HCKScanInfoCellIdenty";

static NSString *const nullInfoString = @"N/A";

static CGFloat const offset_X = 15.f;
static CGFloat const rssiIconWidth = 22.f;
static CGFloat const rssiIconHeight = 11.f;
static CGFloat const connectButtonWidth = 80.f;
static CGFloat const connectButtonHeight = 30.f;
static CGFloat const batteryIconWidth = 22.f;
static CGFloat const batteryIconHeight = 12.f;

@interface HCKScanInfoCell()

/**
 信号icon
 */
@property (nonatomic, strong)UIImageView *rssiIcon;

/**
 信号强度
 */
@property (nonatomic, strong)UILabel *rssiLabel;

/**
 设备名称
 */
@property (nonatomic, strong)UILabel *nameLabel;

/**
 连接按钮
 */
@property (nonatomic, strong)UIButton *connectButton;

/**
 电池图标
 */
@property (nonatomic, strong)UIImageView *batteryIcon;

/**
 mac地址
 */
@property (nonatomic, strong)UILabel *macLabel;

/**
 底部黑色线条，展开2级菜单的时候显示，关闭2级菜单隐藏
 */
@property (nonatomic, strong)UIView *bottomLineView;

@end

@implementation HCKScanInfoCell

+ (HCKScanInfoCell *)initCellWithTableView:(UITableView *)tableView{
    HCKScanInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKScanInfoCellIdenty];
    if (!cell) {
        cell = [[HCKScanInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKScanInfoCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.rssiIcon];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.connectButton];
        [self.contentView addSubview:self.batteryIcon];
        [self.contentView addSubview:self.macLabel];
        [self.contentView addSubview:self.bottomLineView];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:4.f];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.rssiIcon setFrame:CGRectMake(offset_X, 15.f, rssiIconWidth, rssiIconHeight)];
    [self.nameLabel setFrame:CGRectMake(offset_X + rssiIconWidth + 10.f,
                                        15.f,
                                        self.contentView.frame.size.width - 20.f - connectButtonWidth - 2 * offset_X,
                                        HCKFont(16.f).lineHeight)];
    [self.connectButton setFrame:CGRectMake(self.contentView.frame.size.width - offset_X - connectButtonWidth,
                                            8.f,
                                            connectButtonWidth,
                                            connectButtonHeight)];
    [self.rssiLabel setFrame:CGRectMake(offset_X, 20.f + rssiIconHeight, rssiIconWidth, HCKFont(10).lineHeight)];
    [self.batteryIcon setFrame:CGRectMake(offset_X, 35.f + rssiIconHeight + HCKFont(10).lineHeight, batteryIconWidth, batteryIconHeight)];
    [self.macLabel setFrame:CGRectMake(offset_X + batteryIconWidth + 10.f, rssiIconHeight + HCKFont(10).lineHeight + 35.f, self.contentView.frame.size.width - (2 * offset_X + batteryIconWidth + 10.f), batteryIconHeight)];
}



#pragma mark - Private method

- (void)connectButtonPressed{
    if (self.connectPeripheralBlock) {
        self.connectPeripheralBlock(self.beacon.index);
    }
}

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

#pragma mark - Public method
- (void)setBeacon:(HCKScanBeaconModel *)beacon{
    _beacon = nil;
    _beacon = beacon;
    [self.bottomLineView setHidden:YES];
    if (!_beacon || !_beacon.infoBeacon) {
        //如果数据不存在，可能是尚未扫描到该项设备，全部都显示N/A
        [self.rssiLabel setText:stringFromInteger([_beacon.rssi integerValue])];
        [self.nameLabel setText:nullInfoString];
        [self.macLabel setText:@"MAC:N/A"];
        [self.batteryIcon setImage:LOADIMAGE(@"batteryHighest", @"png")];
        return;
    }
    [self.rssiLabel setText:stringFromInteger([_beacon.rssi integerValue])];
    NSString *name = (ValidStr(_beacon.infoBeacon.peripheralName) ? _beacon.infoBeacon.peripheralName : nullInfoString);
    [self.nameLabel setText:name];
    NSString *macAddress = (ValidStr(_beacon.infoBeacon.macAddress) ? _beacon.infoBeacon.macAddress : nullInfoString);
    [self.macLabel setText:[NSString stringWithFormat:@"MAC:%@",macAddress]];
    if ([_beacon.infoBeacon.battery integerValue] >= 0 && [_beacon.infoBeacon.battery integerValue] < 20) {
        //最低
        [self.batteryIcon setImage:LOADIMAGE(@"batteryLowest", @"png")];
    }else if ([_beacon.infoBeacon.battery integerValue] >= 20 && [_beacon.infoBeacon.battery integerValue] < 40){
        //次低
        [self.batteryIcon setImage:LOADIMAGE(@"batteryLower", @"png")];
    }else if ([_beacon.infoBeacon.battery integerValue] >= 40 && [_beacon.infoBeacon.battery integerValue] < 60){
        //中等
        [self.batteryIcon setImage:LOADIMAGE(@"batteryLow", @"png")];
    }else if ([_beacon.infoBeacon.battery integerValue] >= 60 && [_beacon.infoBeacon.battery integerValue] < 80){
        //次高
        [self.batteryIcon setImage:LOADIMAGE(@"batteryHigher", @"png")];
    }else if ([_beacon.infoBeacon.battery integerValue] >= 80 && [_beacon.infoBeacon.battery integerValue] <= 100){
        //最高
        [self.batteryIcon setImage:LOADIMAGE(@"batteryHighest", @"png")];
    }
}


#pragma mark - setter & getter

- (UIImageView *)rssiIcon{
    if (!_rssiIcon) {
        _rssiIcon = [[UIImageView alloc] init];
        _rssiIcon.image = LOADIMAGE(@"signalIcon", @"png");
    }
    return _rssiIcon;
}

- (UILabel *)rssiLabel{
    if (!_rssiLabel) {
        _rssiLabel = [self createLabelWithFont:HCKFont(10)];
        _rssiLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rssiLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [self createLabelWithFont:HCKFont(16.f)];
    }
    return _nameLabel;
}

- (UIButton *)connectButton{
    if (!_connectButton) {
        _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_connectButton setBackgroundColor:NAVIGATION_BAR_COLOR];
        [_connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
        [_connectButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_connectButton.titleLabel setFont:HCKFont(15.f)];
        [_connectButton.layer setMasksToBounds:YES];
        [_connectButton.layer setCornerRadius:10.f];
        [_connectButton addTapAction:self selector:@selector(connectButtonPressed)];
    }
    return _connectButton;
}

- (UIImageView *)batteryIcon{
    if (!_batteryIcon) {
        _batteryIcon = [[UIImageView alloc] init];
        _batteryIcon.image = LOADIMAGE(@"batteryHighest", @"png");
    }
    return _batteryIcon;
}

- (UILabel *)macLabel{
    if (!_macLabel) {
        _macLabel = [self createLabelWithFont:HCKFont(14)];
    }
    return _macLabel;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLOR_BLACK_MARCROS;
    }
    return _bottomLineView;
}

@end
