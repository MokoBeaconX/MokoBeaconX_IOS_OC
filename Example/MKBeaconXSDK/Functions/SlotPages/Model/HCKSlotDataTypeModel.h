//
//  HCKSlotDataTypeModel.h
//  HCKEddStone
//
//  Created by aa on 2017/12/23.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKSlotDataTypeModel : HCKBaseDataModel

/**
 通道数据类型
 */
@property (nonatomic, assign)slotFrameType slotType;

/**
 是否可点击
 */
@property (nonatomic, assign)BOOL clickEnable;

/**
 第几个通道
 */
@property (nonatomic, assign)eddystoneActiveSlotNo slotIndex;

@end
