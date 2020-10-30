//
//  HCKAdvContentiBeaconCell.h
//  HCKEddStone
//
//  Created by aa on 2017/12/9.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKAdvContentBaseCell.h"

@interface HCKAdvContentiBeaconCell : HCKAdvContentBaseCell

+ (HCKAdvContentiBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)NSDictionary *dataDic;

@end
