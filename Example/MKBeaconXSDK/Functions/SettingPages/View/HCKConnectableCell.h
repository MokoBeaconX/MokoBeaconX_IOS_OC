//
//  HCKConnectableCell.h
//  HCKEddStone
//
//  Created by aa on 2018/1/23.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "HCKIconInfoCell.h"

@interface HCKConnectableCell : HCKIconInfoCell

+ (HCKConnectableCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, copy)void (^connectStatusChangedBlock)(BOOL connectable);

@end
