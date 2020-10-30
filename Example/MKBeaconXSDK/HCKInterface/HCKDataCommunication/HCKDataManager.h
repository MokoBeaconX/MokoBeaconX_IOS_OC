//
//  HCKDataManager.h
//  HCKEddStone
//
//  Created by aa on 2017/12/25.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"
#import "HCKSlotDataTypeModel.h"

extern NSString *const MKCentralManagerStateChangedNotification;
extern NSString *const MKPeripheralConnectStateChangedNotification;
extern NSString *const MKPeripheralLockStateChangedNotification;

@interface HCKDataManager : HCKBaseDataModel

+ (HCKDataManager *)share;

@property (nonatomic, copy)NSString *password;

/**
 获取指定通道的详细数据,先切换到指定通道，再根据指定通道的数据类型加载不同数据。对于标准的EddStone广播帧(UID、TLM、URL)，根据相关的特征去获取当前活跃通道的广播内容，对于iBeacon和设备信息帧，需要用自定义协议来获取相关信息
 
 @param slotModel slotModel
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)readSlotDetailData:(HCKSlotDataTypeModel *)slotModel
              successBlock:(readDataFromEddStoneSuccessBlock)successBlock
               failedBlock:(readDataFromEddStoneFailedBlock)failedBlock;

/**
 设置slot详情信息
 
 @param slotNo 通道号
 @param slotFrameType 通道数据类型
 @param detailData 详情数据
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)setSlotDetailData:(eddystoneActiveSlotNo )slotNo
            slotFrameType:(slotFrameType )slotFrameType
               detailData:(NSDictionary *)detailData
             successBlock:(setDataToEddStoneSuccessBlock)successBlock
              failedBlock:(setDataToEddStoneFailedBlock)failedBlock;

@end
