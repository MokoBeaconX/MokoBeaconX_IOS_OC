//
//  HCKScanInfoCell.h
//  HCKEddStone
//
//  Created by aa on 2017/12/29.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseCell.h"
#import "HCKScanBeaconModel.h"

typedef void(^connectPeripheralBlock)(NSInteger section);

@interface HCKScanInfoCell : HCKBaseCell

+ (HCKScanInfoCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)HCKScanBeaconModel *beacon;

@property (nonatomic, copy)connectPeripheralBlock connectPeripheralBlock;

@end
