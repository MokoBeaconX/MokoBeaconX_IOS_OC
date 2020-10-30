//
//  HCKAdvContentBaseCell.h
//  HCKEddStone
//
//  Created by aa on 2017/12/11.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSlotBaseCell.h"

@interface HCKAdvContentBaseCell : HCKSlotBaseCell

/**
 子类控件距离顶部最小距离
 */
@property (nonatomic, assign)CGFloat minTopOffset;

/**
 子控件距离左右最小距离
 */
@property (nonatomic, assign)CGFloat minOffset_X;

@end
