//
//  HCKSlotConfigCellModel.h
//  HCKEddStone
//
//  Created by aa on 2017/12/11.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKSlotConfigCellModel : HCKBaseDataModel

@property (nonatomic, assign)HCKSlotConfigCellType cellType;

@property (nonatomic, strong)NSDictionary *dataDic;

@end
