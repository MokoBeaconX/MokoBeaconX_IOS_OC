//
//  HCKScanBeaconModel.m
//  HCKEddStone
//
//  Created by aa on 2017/12/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKScanBeaconModel.h"

@implementation HCKScanBeaconModel

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
