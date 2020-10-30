//
//  HCKScanBaseCell.h
//  HCKEddStone
//
//  Created by aa on 2017/12/4.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCKScanBaseCell : UITableViewCell

@property (nonatomic, strong)NSIndexPath *indexPath;

+ (CGFloat)getCellHeight;

@end
