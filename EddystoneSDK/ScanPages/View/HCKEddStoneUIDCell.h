//
//  HCKEddStoneUIDCell.h
//  HCKEddStone
//
//  Created by aa on 2017/11/29.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKScanBaseCell.h"

@interface HCKEddStoneUIDCell : HCKScanBaseCell

+ (HCKEddStoneUIDCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)MKReceiveUIDBeacon *beacon;

@end
