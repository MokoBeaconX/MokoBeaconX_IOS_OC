//
//  HCKScanSearchView.h
//  HCKEddStone
//
//  Created by aa on 2017/12/4.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCKScanSearchView : UIView

@property (nonatomic, copy)void (^scanSearchViewDismisBlock)(BOOL update, NSString *text, CGFloat rssi);

/**
 加载页面

 @param text 输入框文本
 @param rssiValue 滑竿rssi值
 */
- (void)showWithText:(NSString *)text
           rssiValue:(NSString *)rssiValue;

@end
