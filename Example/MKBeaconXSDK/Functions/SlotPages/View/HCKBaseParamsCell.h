//
//  HCKBaseParamsCell.h
//  HCKEddStone
//
//  Created by aa on 2017/12/11.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSlotBaseCell.h"

static NSString *const HCKSlotBaseCellTLMType = @"HCKSlotBaseCellTLMType";
static NSString *const HCKSlotBaseCellUIDType = @"HCKSlotBaseCellUIDType";
static NSString *const HCKSlotBaseCellURLType = @"HCKSlotBaseCellURLType";
static NSString *const HCKSlotBaseCelliBeaconType = @"HCKSlotBaseCelliBeaconType";

@interface HCKBaseParamsCell : HCKSlotBaseCell

+ (HCKBaseParamsCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)NSDictionary *dataDic;

@property (nonatomic, copy)NSString *baseCellType;

@end
