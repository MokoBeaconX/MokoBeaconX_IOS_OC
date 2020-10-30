//
//  HCKAdvContentURLCell.h
//  HCKEddStone
//
//  Created by aa on 2017/12/11.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKAdvContentBaseCell.h"

@interface HCKAdvContentURLCell : HCKAdvContentBaseCell

+ (HCKAdvContentURLCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)NSDictionary *dataDic;

@end
