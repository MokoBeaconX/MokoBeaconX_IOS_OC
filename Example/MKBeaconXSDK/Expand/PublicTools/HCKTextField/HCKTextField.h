//
//  HCKTextField.h
//  HCKEddStone
//
//  Created by aa on 2017/12/9.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, validationRules) {
    normalInput,                    //默认输入，没有任何的输入校验规则
    realNumberOnly,                 //只能输入数字
    letterOnly,                     //只能输入字母
    reakNumberOrLetter,             //可以输入字母或者数字
    hexCharOnly,                    //十六进制字符
    uuidMode,                       //当前输入框为UUID数据，自动加下划线，8-4-4-4-12
};

@interface HCKTextField : UITextField

- (instancetype)initWithValidationRules:(validationRules)rules;
//最大输入长度,如果是默认0，则不限制输入长度
@property (nonatomic, assign)NSInteger maxLength;

@end
