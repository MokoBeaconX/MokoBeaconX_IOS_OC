//
//  HCKSlotVCModel.h
//  HCKEddStone
//
//  Created by aa on 2017/12/12.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKSlotVCModel : HCKBaseDataModel

/**
 当前通道类型
 */
@property (nonatomic, assign)slotFrameType type;

/**
 当前通道的数据
 */
@property (nonatomic, strong)id returnData;

@end
