//
//  HCKDataManager.m
//  HCKEddStone
//
//  Created by aa on 2017/12/25.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKDataManager.h"

NSString *const MKCentralManagerStateChangedNotification = @"MKCentralManagerStateChangedNotification";
NSString *const MKPeripheralConnectStateChangedNotification = @"MKPeripheralConnectStateChangedNotification";
NSString *const MKPeripheralLockStateChangedNotification = @"MKPeripheralLockStateChangedNotification";

@interface HCKDataManager()<MKEddystoneCentralManagerDelegate>

/**
 slot的详情数据
 */
@property (nonatomic, strong)NSMutableDictionary *slotDetailDic;

/**
 设置给eddStone的详情数据
 */
@property (nonatomic, strong)NSDictionary *setSlotDetailDic;

@property (nonatomic, strong)HCKSlotDataTypeModel *dataModel;

/**
 读取slot详细数据成功回调
 */
@property (nonatomic, copy)readDataFromEddStoneSuccessBlock readSlotDetailSucBlock;

/**
 读取slot详细数据失败回调
 */
@property (nonatomic, copy)readDataFromEddStoneFailedBlock readSlotDetailFailBlock;

/**
 设置slot详情数据成功回调
 */
@property (nonatomic, copy)setDataToEddStoneSuccessBlock setSlotDetailSucBlock;

/**
 设置slot详情数据失败回调
 */
@property (nonatomic, copy)setDataToEddStoneFailedBlock setSlotDetailFailBlock;

@end

@implementation HCKDataManager

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HCKCentralDeallocNotification object:nil];
}

- (instancetype)init{
    if (self = [super init]) {
        [self setStateDelegate];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setStateDelegate)
                                                     name:HCKCentralDeallocNotification
                                                   object:nil];
    }
    return self;
}

+ (HCKDataManager *)share{
    static HCKDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [HCKDataManager new];
        }
    });
    return manager;
}

#pragma mark - MKEddystoneCentralManagerDelegate
- (void)centralStateChanged:(MKEddystoneCentralManagerState)managerState manager:(MKCentralManager *)manager{
    [[NSNotificationCenter defaultCenter] postNotificationName:MKCentralManagerStateChangedNotification object:nil];
}

- (void)peripheralConnectStateChanged:(MKEddystoneConnectStatus)connectState manager:(MKCentralManager *)manager{
    [[NSNotificationCenter defaultCenter] postNotificationName:MKPeripheralConnectStateChangedNotification object:nil];
}

- (void)eddystoneLockStateChanged:(MKEddystoneLockState)lockState manager:(MKCentralManager *)manager{
    [[NSNotificationCenter defaultCenter] postNotificationName:MKPeripheralLockStateChangedNotification object:nil];
}

#pragma mark - notice event method
- (void)setStateDelegate{
    [MKCentralManager sharedInstance].stateDelegate = self;
}

#pragma mark - Private method

/**
 读取广播间隔
 */
- (void)readAdvertisingIntervalData{
    self.slotDetailDic = nil;
    WS(weakSelf);
    [MKEddystoneInterface readEddystoneAdvertisingIntervalWithSucBlock:^(id returnData) {
        NSString *advertisingInterval = returnData[@"result"][@"advertisingInterval"];
        if (ValidStr(advertisingInterval)) {
            //广播周期
            [weakSelf.slotDetailDic setObject:advertisingInterval forKey:@"advInterval"];
        }
        [weakSelf readRadioTxPower];
    } failedBlock:^(NSError *error) {
        [weakSelf readRadioTxPower];
    }];
}

/**
 读取发射功率
 */
- (void)readRadioTxPower{
    WS(weakSelf);
    [MKEddystoneInterface readEddystoneRadioTxPowerWithSucBlock:^(id returnData) {
        NSString *radio = returnData[@"result"][@"radioTxPower"];
        [weakSelf.slotDetailDic setObject:radio forKey:@"radioTxPower"];
        [weakSelf readADVData];
    } failedBlock:^(NSError *error) {
        [weakSelf readADVData];
    }];
}

///**
// 读取广播功率
// */
//- (void)readAdvTxPower{
//    WS(weakSelf);
//    [HCKBluetoothPeripheralManager readEddStoneAdvTxPowerWithSuccessBlock:^(id returnData) {
//        NSString *advPower = returnData[@"result"][@"advTxPower"];
//        [weakSelf.slotDetailDic setObject:advPower forKey:@"advTxPower"];
//        [weakSelf readADVData];
//    } failedBlock:^(NSError *error) {
//        [weakSelf readADVData];
//    }];
//}

/**
 读取广播信息
 */
- (void)readADVData{
    WS(weakSelf);
    if (self.dataModel.slotType == slotFrameTypeiBeacon) {
        //读取iBeacon用自定义协议
        //自定义协议读取相关内容
        [MKEddystoneInterface readEddystoneiBeaconAdvDataWithSucBlock:^(id returnData) {
            NSDictionary *resultDic = returnData[@"result"];
            NSString *txPower = resultDic[@"txPower"];
            if (ValidStr(txPower)) {
                [weakSelf.slotDetailDic setObject:txPower forKey:@"advTxPower"];
            }
            NSDictionary *json = @{
                                   @"baseParam":(ValidDict(weakSelf.slotDetailDic) ? weakSelf.slotDetailDic : @{}),
                                   @"advData":(ValidDict(resultDic) ? resultDic : @{}),
                                   };
            if (weakSelf.readSlotDetailSucBlock) {
                weakSelf.readSlotDetailSucBlock(json);
            }
        } failedBlock:^(NSError *error) {
            NSDictionary *json = @{
                                   @"baseParam":(ValidDict(weakSelf.slotDetailDic) ? weakSelf.slotDetailDic : @{}),
                                   @"advData":@{},
                                   };
            if (weakSelf.readSlotDetailSucBlock) {
                weakSelf.readSlotDetailSucBlock(json);
            }
        }];
        return;
    }
    [MKEddystoneInterface readEddystoneAdvDataWithSucBlock:^(id returnData) {
        NSDictionary *resultDic = returnData[@"result"];
        NSString *txPower = resultDic[@"txPower"];
        if (ValidStr(txPower)) {
            [weakSelf.slotDetailDic setObject:txPower forKey:@"advTxPower"];
        }
        NSDictionary *json = @{
                               @"baseParam":(ValidDict(weakSelf.slotDetailDic) ? weakSelf.slotDetailDic : @{}),
                               @"advData":(ValidDict(resultDic) ? resultDic : @{}),
                               };
        if (weakSelf.readSlotDetailSucBlock) {
            weakSelf.readSlotDetailSucBlock(json);
        }
    } failedBlock:^(NSError *error) {
        NSDictionary *json = @{
                               @"baseParam":(ValidDict(weakSelf.slotDetailDic) ? weakSelf.slotDetailDic : @{}),
                               @"advData":@{},
                               };
        if (weakSelf.readSlotDetailSucBlock) {
            weakSelf.readSlotDetailSucBlock(json);
        }
    }];
}

- (void)setDetailDataWithFrameType:(slotFrameType)frameType{
    if (!ValidDict(self.setSlotDetailDic) && frameType != slotFrameTypeNull) {
        if (self.setSlotDetailFailBlock) {
            NSError *error = [[NSError alloc] initWithDomain:@"mokoEddStone"
                                                        code:-999
                                                    userInfo:@{@"errorInfo":@"To set up the data can not be empty"}];
            self.setSlotDetailFailBlock(error);
        }
        return;
    }
    switch (frameType) {
        case slotFrameTypeTLM:
            [self setTLMDatas];
            break;
            
        case slotFrameTypeUID:
            [self setUIDDetailDatas];
            break;
            
        case slotFrameTypeURL:
            [self setURLDetailDatas];
            break;
            
        case slotFrameTypeInfo:
            break;
            
        case slotFrameTypeiBeacon:
            [self setiBeaconDetailDatas];
            break;
            
        case slotFrameTypeNull:
            [self setNoDatas];
            break;
        default:
            break;
    }
}

- (void)setTLMDatas{
    WS(weakSelf);
    [MKEddystoneInterface setTLMEddystoneAdvDataWithSucBlock:^(id returnData) {
        [weakSelf setInterval];
    } failedBlock:self.setSlotDetailFailBlock];
}

- (void)setURLDetailDatas{
    NSString *content = self.setSlotDetailDic[@"URL"][@"urlContent"];
    if (ValidStr(self.setSlotDetailDic[@"URL"][@"urlExpansion"])) {
        content = [content stringByAppendingString:self.setSlotDetailDic[@"URL"][@"urlExpansion"]];
    }
    WS(weakSelf);
    urlHeaderType urlType;
    /*
     urlHeaderType1,             //http://www.
     urlHeaderType2,             //https://www.
     urlHeaderType3,             //http://
     urlHeaderType4,             //https://
     */
    if ([self.setSlotDetailDic[@"URL"][@"urlHeader"] isEqualToString:@"http://www."]) {
        urlType = urlHeaderType1;
    }else if ([self.setSlotDetailDic[@"URL"][@"urlHeader"] isEqualToString:@"https://www."]){
        urlType = urlHeaderType2;
    }else if ([self.setSlotDetailDic[@"URL"][@"urlHeader"] isEqualToString:@"http://"]){
        urlType = urlHeaderType3;
    }else if ([self.setSlotDetailDic[@"URL"][@"urlHeader"] isEqualToString:@"https://"]){
        urlType = urlHeaderType4;
    }else{
        [self setInterval];
        return;
    }
    [MKEddystoneInterface setURLEddystoneAdvData:urlType urlContent:content sucBlock:^(id returnData) {
        [weakSelf setInterval];
    } failedBlock:self.setSlotDetailFailBlock];
}

- (void)setUIDDetailDatas{
    NSString *nameSpace = self.setSlotDetailDic[@"UID"][@"nameSpace"];
    NSString *instanceID = self.setSlotDetailDic[@"UID"][@"instanceID"];
    if (!ValidStr(nameSpace) || !ValidStr(instanceID)) {
        if (self.setSlotDetailFailBlock) {
            NSError *error = [[NSError alloc] initWithDomain:@"mokoEddStone"
                                                        code:-999
                                                    userInfo:@{@"errorInfo":@"To set up the data can not be empty"}];
            self.setSlotDetailFailBlock(error);
        }
        return;
    }
    WS(weakSelf);
    [MKEddystoneInterface setUIDEddystoneAdvDataWithNameSpace:nameSpace instanceID:instanceID sucBlock:^(id returnData) {
        [weakSelf setInterval];
    } failedBlock:self.setSlotDetailFailBlock];
}

- (void)setiBeaconDetailDatas{
    NSString *major = self.setSlotDetailDic[@"iBeacon"][@"major"];
    NSString *minor = self.setSlotDetailDic[@"iBeacon"][@"minor"];
    NSString *uuid = self.setSlotDetailDic[@"iBeacon"][@"uuid"];
    NSString *measurePower = self.setSlotDetailDic[@"baseParam"][@"advTxPower"];
    if (!ValidStr(major) || !ValidStr(minor) || !ValidStr(uuid) || !ValidStr(measurePower)) {
        if (self.setSlotDetailFailBlock) {
            NSError *error = [[NSError alloc] initWithDomain:@"mokoEddStone"
                                                        code:-999
                                                    userInfo:@{@"errorInfo":@"To set up the data can not be empty"}];
            self.setSlotDetailFailBlock(error);
        }
        return;
    }
    
    WS(weakSelf);
    [MKEddystoneInterface setiBeaconEddystoneAdvDataWithMajor:[major integerValue] minor:[minor integerValue] uuid:uuid measurePower:([measurePower integerValue] < 0 ? (0 - [measurePower integerValue]) : [measurePower integerValue]) sucBlock:^(id returnData) {
        [weakSelf setInterval];
    } failedBlock:self.setSlotDetailFailBlock];
}

- (void)setNoDatas{
    WS(weakSelf);
    [MKEddystoneInterface setNoDataEddystoneAdvDataWithSucBlock:^(id returnData) {
        if (weakSelf.setSlotDetailSucBlock) {
            weakSelf.setSlotDetailSucBlock();
        }
    } failedBlock:self.setSlotDetailFailBlock];
}

/**
 设置广播间隔
 */
- (void)setInterval{
    NSString *interval = self.setSlotDetailDic[@"baseParam"][@"interval"];
    if (!ValidStr(interval)) {
        [self setAdvTxPower];
        return;
    }
    WS(weakSelf);
    [MKEddystoneInterface setEddystoneAdvertingInterval:[interval integerValue] sucBlock:^(id returnData) {
        [weakSelf setAdvTxPower];
    } failedBlock:^(NSError *error) {
        [weakSelf setAdvTxPower];
    }];
}

- (void)setAdvTxPower{
    NSString *advTxPower = self.setSlotDetailDic[@"baseParam"][@"advTxPower"];
    if (!ValidStr(advTxPower)) {
        [self setRadioTxPower];
        return;
    }
    WS(weakSelf);
    [MKEddystoneInterface setEddystoneAdvTxPower:[advTxPower integerValue] sucBlock:^(id returnData) {
        [weakSelf setRadioTxPower];
    } failedBlock:^(NSError *error) {
        [weakSelf setRadioTxPower];
    }];
}

/**
 设置发射功率
 */
- (void)setRadioTxPower{
    NSString *txPower = self.setSlotDetailDic[@"baseParam"][@"txPower"];
    if (!ValidStr(txPower)) {
        if (self.setSlotDetailSucBlock) {
            self.setSlotDetailSucBlock();
        }
        return;
    }
    WS(weakSelf);
    [MKEddystoneInterface setEddystoneRadioTxPower:[self getRadioTxPower:txPower] sucBlock:^(id returnData) {
        if (weakSelf.setSlotDetailSucBlock) {
            weakSelf.setSlotDetailSucBlock();
        }
    } failedBlock:^(NSError *error) {
        if (weakSelf.setSlotDetailSucBlock) {
            weakSelf.setSlotDetailSucBlock();
        }
    }];
}

- (slotRadioTxPower)getRadioTxPower:(NSString *)txPower{
    if ([txPower isEqualToString:@"4dBm"]) {
        return slotRadioTxPower4dBm;
    }else if ([txPower isEqualToString:@"3dBm"]){
        return slotRadioTxPower3dBm;
    }else if ([txPower isEqualToString:@"0dBm"]){
        return slotRadioTxPower0dBm;
    }else if ([txPower isEqualToString:@"-4dBm"]){
        return slotRadioTxPowerNeg4dBm;
    }else if ([txPower isEqualToString:@"-8dBm"]){
        return slotRadioTxPowerNeg8dBm;
    }else if ([txPower isEqualToString:@"-12dBm"]){
        return slotRadioTxPowerNeg12dBm;
    }else if ([txPower isEqualToString:@"-16dBm"]){
        return slotRadioTxPowerNeg16dBm;
    }else if ([txPower isEqualToString:@"-20dBm"]){
        return slotRadioTxPowerNeg20dBm;
    }else if ([txPower isEqualToString:@"-40dBm"]){
        return slotRadioTxPowerNeg40dBm;
    }
    return slotRadioTxPower0dBm;
}

#pragma mark - interface

/**
 获取指定通道的详细数据,先切换到指定通道，再根据指定通道的数据类型加载不同数据。对于标准的EddStone广播帧(UID、TLM、URL)，根据相关的特征去获取当前活跃通道的广播内容，对于iBeacon和设备信息帧，需要用自定义协议来获取相关信息
 
 @param slotModel slotModel
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)readSlotDetailData:(HCKSlotDataTypeModel *)slotModel
              successBlock:(readDataFromEddStoneSuccessBlock)successBlock
               failedBlock:(readDataFromEddStoneFailedBlock)failedBlock{
    WS(weakSelf);
    self.readSlotDetailSucBlock = nil;
    self.readSlotDetailSucBlock = successBlock;
    self.readSlotDetailFailBlock = nil;
    self.readSlotDetailFailBlock = failedBlock;
    self.dataModel = nil;
    self.dataModel = slotModel;
    [MKEddystoneInterface setEddystoneActiveSlot:slotModel.slotIndex sucBlock:^(id returnData) {
        if (slotModel.slotType == slotFrameTypeNull) {
            if (weakSelf.readSlotDetailSucBlock) {
                NSDictionary *json = @{
                                       @"advData":@{
                                               @"frameType":@"70",
                                               }
                                       };
                weakSelf.readSlotDetailSucBlock(json);
            }
            return ;
        }
        [weakSelf readAdvertisingIntervalData];
    } failedBlock:^(NSError *error) {
        if (failedBlock) {
            dispatch_main_async_safe(^{
                failedBlock(error);
            });
        }
    }];
}

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
              failedBlock:(setDataToEddStoneFailedBlock)failedBlock{
    if (!ValidDict(detailData) && slotFrameType != slotFrameTypeNull) {
        //NO DATA的情况下，不需要具体详情数据
        if (failedBlock) {
            NSError *error = [[NSError alloc] initWithDomain:@"mokoEddStone"
                                                        code:-999
                                                    userInfo:@{@"errorInfo":@"To set up the data can not be empty"}];
            failedBlock(error);
        }
        return;
    }
    self.setSlotDetailSucBlock = nil;
    self.setSlotDetailSucBlock = successBlock;
    self.setSlotDetailFailBlock = nil;
    self.setSlotDetailFailBlock = failedBlock;
    WS(weakSelf);
    [MKEddystoneInterface setEddystoneActiveSlot:slotNo sucBlock:^(id returnData) {
        weakSelf.setSlotDetailDic = detailData;
        [weakSelf setDetailDataWithFrameType:slotFrameType];
    } failedBlock:^(NSError *error) {
        if (failedBlock) {
            dispatch_main_async_safe(^{
                failedBlock(error);
            });
        }
    }];
}

#pragma mark - setter & getter
- (NSMutableDictionary *)slotDetailDic{
    if (!_slotDetailDic) {
        _slotDetailDic = [NSMutableDictionary dictionary];
    }
    return _slotDetailDic;
}

@end
