//
//  HCKAdvContentUIDCell.m
//  HCKEddStone
//
//  Created by aa on 2017/12/11.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKAdvContentUIDCell.h"

static NSString *const HCKAdvContentUIDCellIdenty = @"HCKAdvContentUIDCellIdenty";
static CGFloat labelWidth = 85.f;
static CGFloat labelHeight = 30.f;

@interface HCKAdvContentUIDCell()

@property (nonatomic, strong)UILabel *nameSpaceLabel;
@property (nonatomic, strong)UILabel *instanceIDLabel;
@property (nonatomic, strong)HCKTextField *nameSpaceTextField;
@property (nonatomic, strong)HCKTextField *instanceIDTextField;

@end

@implementation HCKAdvContentUIDCell

+ (HCKAdvContentUIDCell *)initCellWithTableView:(UITableView *)tableView{
    HCKAdvContentUIDCell *cell = [tableView  dequeueReusableCellWithIdentifier:HCKAdvContentUIDCellIdenty];
    if (!cell) {
        cell = [[HCKAdvContentUIDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKAdvContentUIDCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.nameSpaceLabel];
        [self.contentView addSubview:self.instanceIDLabel];
        [self.contentView addSubview:self.nameSpaceTextField];
        [self.contentView addSubview:self.instanceIDTextField];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameSpaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minOffset_X);
        make.width.mas_equalTo(labelWidth);
        make.top.mas_equalTo(self.minTopOffset);
        make.height.mas_equalTo(labelHeight);
    }];
    [self.nameSpaceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameSpaceLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-self.minOffset_X);
        make.centerY.mas_equalTo(self.nameSpaceLabel.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    [self.instanceIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minOffset_X);
        make.width.mas_equalTo(labelWidth);
        make.top.mas_equalTo(self.nameSpaceLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(labelHeight);
    }];
    [self.instanceIDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.instanceIDLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-self.minOffset_X);
        make.centerY.mas_equalTo(self.instanceIDLabel.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
}

/**
 获取当前cell上面的信息。先查状态位@"code",当@"code":@"1"的时候说明数据都有，可以进行设置，
 当@"code":@"2"的时候，表明某些必填项没有设置，报错
 
 @return dic
 */
- (NSDictionary *)getContentData{
    NSString *nameSpace = [self.nameSpaceTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *instanceID = [self.instanceIDTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!ValidStr(nameSpace) || nameSpace.length != 20 || !ValidStr(instanceID) || instanceID.length != 12) {
        return [self errorDic:@"The input parameter is illegal"];
    }
    return @{
             @"code":@"1",
             @"result":@{
                        @"type":@"UID",
                        @"nameSpace":nameSpace,
                        @"instanceID":instanceID,
                     },
             };
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
        [self.instanceIDTextField setText:@""];
        [self.nameSpaceTextField setText:@""];
        return;
    }
    if (ValidStr(_dataDic[@"instanceId"])) {
        //instanceId
        [self.instanceIDTextField setText:_dataDic[@"instanceId"]];
    }else{
        [self.instanceIDTextField setText:@""];
    }
    if (ValidStr(_dataDic[@"namespaceId"])) {
        //namespaceId
        [self.nameSpaceTextField setText:_dataDic[@"namespaceId"]];
    }else{
        [self.nameSpaceTextField setText:@""];
    }
}

#pragma mark - setter & getter

- (UILabel *)nameSpaceLabel{
    if (!_nameSpaceLabel) {
        _nameSpaceLabel = [self createLabelWithTextColor:RGBCOLOR(111, 111, 111)];
        _nameSpaceLabel.text = @"NameSpace";
    }
    return _nameSpaceLabel;
}

- (UILabel *)instanceIDLabel{
    if (!_instanceIDLabel) {
        _instanceIDLabel = [self createLabelWithTextColor:RGBCOLOR(111, 111, 111)];
        _instanceIDLabel.text = @"Instance ID";
    }
    return _instanceIDLabel;
}

- (HCKTextField *)nameSpaceTextField{
    if (!_nameSpaceTextField) {
        _nameSpaceTextField = [self createNewTextFieldWithRules:hexCharOnly];
        _nameSpaceTextField.attributedPlaceholder = [HCKAttributedStringManager getAttributedString:@[@"10 Bytes"] fonts:@[HCKFont(15.f)] colors:@[RGBCOLOR(222, 222, 222)]];
        _nameSpaceTextField.maxLength = 20;
    }
    return _nameSpaceTextField;
}

- (HCKTextField *)instanceIDTextField{
    if (!_instanceIDTextField) {
        _instanceIDTextField = [self createNewTextFieldWithRules:hexCharOnly];
        _instanceIDTextField.attributedPlaceholder = [HCKAttributedStringManager getAttributedString:@[@"6 Bytes"] fonts:@[HCKFont(15.f)] colors:@[RGBCOLOR(222, 222, 222)]];
        _instanceIDTextField.maxLength = 12;
    }
    return _instanceIDTextField;
}

@end
