//
//  HCKEddStoneiBeaconCell.h
//  HCKEddStone
//
//  Created by aa on 2017/12/27.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKScanBaseCell.h"

@interface HCKEddStoneiBeaconCell : HCKScanBaseCell

+ (HCKEddStoneiBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)MKReceiveiBeacon *beacon;

+ (CGFloat)getCellHeightWithUUID:(NSString *)uuid;

@end
