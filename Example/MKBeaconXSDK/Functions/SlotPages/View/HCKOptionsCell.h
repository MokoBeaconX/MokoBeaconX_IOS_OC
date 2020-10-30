//
//  HCKOptionsCell.h
//  HCKEddStone
//
//  Created by aa on 2017/12/23.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseCell.h"
#import "HCKSlotDataTypeModel.h"

@interface HCKOptionsCell : HCKBaseCell

+ (HCKOptionsCell *)initCellWithTabelView:(UITableView *)tableView;

@property (nonatomic, strong)HCKSlotDataTypeModel *dataModel;

@property (nonatomic, copy)void (^configSlotDataBlock)(HCKSlotDataTypeModel *dataModel);

@end
