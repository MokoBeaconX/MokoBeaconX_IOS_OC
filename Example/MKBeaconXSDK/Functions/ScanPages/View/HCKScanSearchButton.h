//
//  HCKScanSearchButton.h
//  HCKEddStone
//
//  Created by aa on 2017/12/6.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCKScanSearchButton : UIControl

/**
 当前搜索条件，如果是nil或者@[]，则认为关闭了搜索条件
 */
@property (nonatomic, strong)NSMutableArray *searchConditions;

/**
 用户点击了清除筛选条件按钮回调
 */
@property (nonatomic, copy)void (^clearSearchConditionsBlock)(void);

/**
 用户点击了搜索按钮回调
 */
@property (nonatomic, copy)void (^searchButtonPressedBlock)(void);

@end
