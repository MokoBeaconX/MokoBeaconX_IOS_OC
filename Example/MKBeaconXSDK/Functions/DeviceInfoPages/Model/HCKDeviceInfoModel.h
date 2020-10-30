//
//  HCKDeviceInfoModel.h
//  HCKEddStone
//
//  Created by aa on 2017/12/28.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKDeviceInfoModel : HCKBaseDataModel

/**
 电池电量
 */
@property (nonatomic, copy)NSString *battery;

/**
 mac地址
 */
@property (nonatomic, copy)NSString *macAddress;

/**
 产品型号
 */
@property (nonatomic, copy)NSString *produce;

/**
 软件版本
 */
@property (nonatomic, copy)NSString *software;

/**
 固件版本
 */
@property (nonatomic, copy)NSString *firmware;

/**
 硬件版本
 */
@property (nonatomic, copy)NSString *hardware;

/**
 生产日期
 */
@property (nonatomic, copy)NSString *manuDate;

/**
 厂商信息
 */
@property (nonatomic, copy)NSString *manu;

/**
 获取系统信息
 
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)startLoadSystemInformation:(readDataFromEddStoneSuccessBlock)successBlock
                       failedBlock:(readDataFromEddStoneFailedBlock)failedBlock;

@end
