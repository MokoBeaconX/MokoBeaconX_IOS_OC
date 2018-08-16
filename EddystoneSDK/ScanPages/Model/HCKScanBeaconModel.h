//
//  HCKScanBeaconModel.h
//  HCKEddStone
//
//  Created by aa on 2017/12/2.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKScanBeaconModel : HCKBaseDataModel

/**
 设备信息帧，这个需要单列出来
 */
@property (nonatomic, strong)MKReceivePeripheralInfoBeacon *infoBeacon;

/**
 peripheral 标识符
 */
@property (nonatomic, copy)NSString *identifier;

/**
 信号值强度,会动态变化，TLM、iBeacon、UID、URL、info都会改变这个值
 */
@property (nonatomic, strong)NSNumber *rssi;

/**
 当前model所在的section
 */
@property (nonatomic, assign)NSInteger index;

/**
 UID、URL、iBeacon、TLM数据帧
 */
@property (nonatomic, strong)NSMutableArray *dataArray;

@end
