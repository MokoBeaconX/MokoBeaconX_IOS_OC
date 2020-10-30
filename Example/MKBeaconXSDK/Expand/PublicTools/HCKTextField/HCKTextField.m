//
//  HCKTextField.m
//  HCKEddStone
//
//  Created by aa on 2017/12/9.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKTextField.h"

@interface HCKTextField(){
    validationRules _rules;
//    当前输入的UUID字符串长度
    NSInteger _inputLen;
}

@end

@implementation HCKTextField

#pragma mark - life circle
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithValidationRules:(validationRules)rules{
    self = [self init];
    if (self) {
        _rules = rules;
        self.keyboardType = [self getKeyboardType];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        //注意，这里的通知监听方法中的最后一个参数object，一定要传入当前HCKTextField对象，才会监听对应的HCKTextField，否则会监听所有HCKTextField
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidBeginEditingNotifiction:)
                                                     name:UITextFieldTextDidBeginEditingNotification
                                                   object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:self];
    }
    return self;
}

#pragma mark - Private method

#pragma mark - Notification Methods
- (void)textFieldDidBeginEditingNotifiction:(NSNotification *)f{
    
}

- (void)textFieldChanged:(NSNotification *) noti
{
    NSString *tempString = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!ValidStr(tempString)) {
        self.text = @"";
        return;
    }
    if (self.maxLength > 0 && tempString.length > self.maxLength) {
        self.text = [tempString substringToIndex:self.maxLength];
        return;
    }
    NSString *inputString = [tempString substringFromIndex:(self.text.length - 1)];
    BOOL legal = [self validation:inputString];
    self.text = (legal ? tempString : [tempString substringToIndex:self.text.length - 1]);
    
    if (_rules != uuidMode) {
        return;
    }
    self.text = [self.text uppercaseString];
    //8-4-4-4-12,uuid校验
    if (self.text.length > _inputLen) {
        if (self.text.length == 9
            || self.text.length == 14
            || self.text.length == 19
            || self.text.length == 24) {//输入
            NSMutableString * str = [[NSMutableString alloc ] initWithString:self.text];
            [str insertString:@"-" atIndex:(self.text.length-1)];
            self.text = str;
        }
        if (self.text.length >= 36) {//输入完成
            self.text = [self.text substringToIndex:36];
        }
        _inputLen = self.text.length;
        
    }else if (self.text.length < _inputLen){//删除
        if (self.text.length == 9
            || self.text.length == 14
            || self.text.length == 19
            || self.text.length == 24) {
            self.text = [self.text substringToIndex:(self.text.length-1)];
        }
        _inputLen = self.text.length;
    }
}

- (BOOL)validation:(NSString *)inputString{
    if (!ValidStr(inputString)) {
        return NO;
    }
    switch (_rules) {
        case normalInput:
            return YES;
            
        case realNumberOnly:
            return [inputString isRealNumbers];
            
        case letterOnly:
            return [inputString isLetter];
            
        case reakNumberOrLetter:
            return [inputString isLetterOrRealNumbers];
            
        case hexCharOnly:
            return [inputString checkInputIsHexString];
            
        case uuidMode:
            return [inputString checkInputIsHexString];
            
        default:
            return NO;
            break;
    }
}

- (UIKeyboardType)getKeyboardType{
    if (_rules == realNumberOnly) {
        return UIKeyboardTypeNumberPad;
    }
    
    return UIKeyboardTypeASCIICapable;
}

@end
