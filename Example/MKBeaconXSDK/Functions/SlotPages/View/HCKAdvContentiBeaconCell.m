//
//  HCKAdvContentiBeaconCell.m
//  HCKEddStone
//
//  Created by aa on 2017/12/9.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKAdvContentiBeaconCell.h"

static NSString *const HCKAdvContentiBeaconCellIdenty = @"HCKAdvContentiBeaconCellIdenty";
static CGFloat labelWidth = 40.f;
static CGFloat labelHeight = 30.f;

@interface HCKAdvContentiBeaconCell()

@property (nonatomic, strong)UILabel *majorLabel;
@property (nonatomic, strong)UILabel *minorLabel;
@property (nonatomic, strong)UILabel *uuidLabel;
@property (nonatomic, strong)HCKTextField *majorTextField;
@property (nonatomic, strong)HCKTextField *minorTextField;
@property (nonatomic, strong)HCKTextField *uuidTextField;

@end

@implementation HCKAdvContentiBeaconCell

+ (HCKAdvContentiBeaconCell *)initCellWithTableView:(UITableView *)tableView{
    HCKAdvContentiBeaconCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKAdvContentiBeaconCellIdenty];
    if (!cell) {
        cell = [[HCKAdvContentiBeaconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKAdvContentiBeaconCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.majorLabel];
        [self.contentView addSubview:self.minorLabel];
        [self.contentView addSubview:self.uuidLabel];
        [self.contentView addSubview:self.majorTextField];
        [self.contentView addSubview:self.minorTextField];
        [self.contentView addSubview:self.uuidTextField];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.majorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minOffset_X);
        make.width.mas_equalTo(labelWidth);
        make.top.mas_equalTo(self.minTopOffset);
        make.height.mas_equalTo(labelHeight);
    }];
    [self.majorTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.majorLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-self.minOffset_X);
        make.centerY.mas_equalTo(self.majorLabel.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    [self.minorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minOffset_X);
        make.width.mas_equalTo(labelWidth);
        make.top.mas_equalTo(self.majorLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(labelHeight);
    }];
    [self.minorTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minorLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-self.minOffset_X);
        make.centerY.mas_equalTo(self.minorLabel.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    [self.uuidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minOffset_X);
        make.width.mas_equalTo(labelWidth);
        make.top.mas_equalTo(self.minorLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(labelHeight);
    }];
    [self.uuidTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.uuidLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-self.minOffset_X);
        make.centerY.mas_equalTo(self.uuidLabel.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
}

/**
 获取当前cell上面的信息。先查状态位@"code",当@"code":@"1"的时候说明数据都有，可以进行设置，
 当@"code":@"2"的时候，表明某些必填项没有设置，报错
 
 @return dic
 */
- (NSDictionary *)getContentData{
    NSString *major = [self.majorTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *minor = [self.minorTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *uuid = [self.uuidTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!ValidStr(major) || !ValidStr(minor) || !ValidStr(uuid)) {
        return [self errorDic:@"To set the parameters can not be empty"];
    }
    
    return @{
             @"code":@"1",
             @"result":@{
                     @"type":@"iBeacon",
                     @"major":major,
                     @"minor":minor,
                     @"uuid":uuid,
                     },
             };;
}

#pragma mark - Private method

/**
 生成错误的dic
 
 @param errorMsg 错误内容
 @return dic
 */
- (NSDictionary *)errorDic:(NSString *)errorMsg{
    return @{
             @"code":@"2",
             @"msg":SafeStr(errorMsg),
             };
}

- (UILabel *)createLabelWithTextColor:(UIColor *)color{
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textColor = color;
    textLabel.textAlignment = NSTextAlignmentRight;
    textLabel.font = HCKFont(15.f);
    return textLabel;
}

- (HCKTextField *)createNewTextFieldWithRules:(validationRules)rules{
    HCKTextField *textField = [[HCKTextField alloc] initWithValidationRules:rules];
    textField.textColor = DEFAULT_TEXT_COLOR;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.font = HCKFont(15.f);
    
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
    textField.layer.cornerRadius = 3.f;
    
    return textField;
}

#pragma mark - Public method
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = nil;
    _dataDic = dataDic;
    if (!ValidDict(_dataDic)) {
        return;
    }
    if (ValidStr(dataDic[@"major"])) {
        [self.majorTextField setText:dataDic[@"major"]];
    }
    if (ValidStr(dataDic[@"minor"])) {
        [self.minorTextField setText:dataDic[@"minor"]];
    }
    if (ValidStr(dataDic[@"uuid"])) {
        [self.uuidTextField setText:dataDic[@"uuid"]];
    }
}

#pragma mark - setter & getter

- (UILabel *)majorLabel{
    if (!_majorLabel) {
        _majorLabel = [self createLabelWithTextColor:RGBCOLOR(111, 111, 111)];
        _majorLabel.text = @"Major";
    }
    return _majorLabel;
}

- (UILabel *)minorLabel{
    if (!_minorLabel) {
        _minorLabel = [self createLabelWithTextColor:RGBCOLOR(111, 111, 111)];
        _minorLabel.text = @"Minor";
    }
    return _minorLabel;
}

- (UILabel *)uuidLabel{
    if (!_uuidLabel) {
        _uuidLabel = [self createLabelWithTextColor:RGBCOLOR(111, 111, 111)];
        _uuidLabel.text = @"UUID";
    }
    return _uuidLabel;
}

- (HCKTextField *)majorTextField{
    if (!_majorTextField) {
        _majorTextField = [self createNewTextFieldWithRules:realNumberOnly];
        _majorTextField.attributedPlaceholder = [HCKAttributedStringManager getAttributedString:@[@"0~65535"] fonts:@[HCKFont(15.f)] colors:@[RGBCOLOR(222, 222, 222)]];
        _majorTextField.maxLength = 5;
    }
    return _majorTextField;
}

- (HCKTextField *)minorTextField{
    if (!_minorTextField) {
        _minorTextField = [self createNewTextFieldWithRules:realNumberOnly];
        _minorTextField.attributedPlaceholder = [HCKAttributedStringManager getAttributedString:@[@"0~65535"] fonts:@[HCKFont(15.f)] colors:@[RGBCOLOR(222, 222, 222)]];
        _minorTextField.maxLength = 5;
    }
    return _minorTextField;
}

- (HCKTextField *)uuidTextField{
    if (!_uuidTextField) {
        _uuidTextField = [self createNewTextFieldWithRules:uuidMode];
        _uuidTextField.attributedPlaceholder = [HCKAttributedStringManager getAttributedString:@[@"11111111-1111-1111-1111-111111111111"] fonts:@[HCKFont(15.f)] colors:@[RGBCOLOR(222, 222, 222)]];
    }
    return _uuidTextField;
}

@end
