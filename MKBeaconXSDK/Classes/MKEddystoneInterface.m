//
//  MKEddystoneInterface.m
//  EddystoneSDK
//
//  Created by aa on 2018/8/9.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKEddystoneInterface.h"
#import "MKEddystoneOperationIDDefines.h"
#import "MKCentralManager.h"
#import "CBPeripheral+eddystoneAdd.h"
#import "MKEddystoneAdopter.h"
#import "MKSDKDefines.h"
#import "MKEddystoneOperation.h"

#define centralManager [MKCentralManager sharedInstance]

@implementation MKEddystoneInterface
+ (void)readEddystoneActiveSlotWithSucBlock:(void (^)(id returnData))sucBlock failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addReadTaskWithTaskID:MKEddystoneReadActiveSlotOperation
                           characteristic:centralManager.peripheral.activeSlot
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)setEddystoneActiveSlot:(eddystoneActiveSlotNo)slotNo
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *slotNumber = [self fecthSlotNumber:slotNo];
    [centralManager addTaskWithTaskID:MKEddystoneSetActiveSlotOperation
                          commandData:slotNumber
                       characteristic:centralManager.peripheral.activeSlot
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readEddystoneAdvertisingIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addReadTaskWithTaskID:MKEddystoneReadAdvertisingIntervalOperation
                           characteristic:centralManager.peripheral.advertisingInterval
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)setEddystoneAdvertingInterval:(NSInteger)advertingInterval
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock{
    if (advertingInterval < 100 || advertingInterval > 5000) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [NSString stringWithFormat:@"%1lx",(unsigned long)advertingInterval];
    if (commandString.length == 2) {
        commandString = [@"00" stringByAppendingString:commandString];
    }else if (commandString.length == 3){
        commandString = [@"0" stringByAppendingString:commandString];
    }
    [centralManager addTaskWithTaskID:MKEddystoneSetAdvertisingIntervalOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.advertisingInterval
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readEddystoneRadioTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addReadTaskWithTaskID:MKEddystoneReadRadioTxPowerOperation
                           characteristic:centralManager.peripheral.radioTxPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)setEddystoneRadioTxPower:(slotRadioTxPower )power
                        sucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *commandString = [self fecthTxPower:power];
    [centralManager addTaskWithTaskID:MKEddystoneSetRadioTxPowerOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.radioTxPower
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readEddystoneAdvTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addReadTaskWithTaskID:MKEddystoneReadAdvTxPowerOperation
                           characteristic:centralManager.peripheral.advertisedTxPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)setEddystoneAdvTxPower:(NSInteger)advTxPower
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock{
    if (advTxPower < -127 || advTxPower > 0) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    advTxPower = labs(advTxPower);
    NSString *commandString = [NSString stringWithFormat:@"%1lx",(unsigned long)advTxPower];
    if (commandString.length == 1) {
        commandString = [@"0" stringByAppendingString:commandString];
    }
    [centralManager addTaskWithTaskID:MKEddystoneSetAdvTxPowerOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.advertisedTxPower
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setEddystoneNewPassword:(NSString *)newPassword
               originalPassword:(NSString *)originalPassword
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock{
    if (![MKEddystoneAdopter isPassword:newPassword] || ![MKEddystoneAdopter isPassword:originalPassword]) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    //写入0x00加上16字节新的密码（用户要对新的密码进行加密，然后发送，加密的密钥是旧的密码，也就是当前密码），发送之后，设备变为LOCKED状态。
    Byte byte[8] = {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
    NSData *supplement = [NSData dataWithBytes:byte length:8];
    NSString *oldTempString = @"";
    for (NSInteger i = 0; i < originalPassword.length; i ++) {
        int asciiCode = [originalPassword characterAtIndex:i];
        oldTempString = [oldTempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSData *oldPasswordData = [MKEddystoneAdopter stringToData:oldTempString];
    NSString *newTempString = @"";
    for (NSInteger i = 0; i < newPassword.length; i ++) {
        int asciiCode = [newPassword characterAtIndex:i];
        newTempString = [newTempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSData *newPasswordData = [MKEddystoneAdopter stringToData:newTempString];
    NSMutableData *aesKeyData = [[NSMutableData alloc] init];
    [aesKeyData appendData:oldPasswordData];
    [aesKeyData appendData:supplement];
    NSMutableData *contentData = [[NSMutableData alloc] init];
    [contentData appendData:newPasswordData];
    [contentData appendData:supplement];
    NSData *encryptData = [MKEddystoneAdopter AES128EncryptWithSourceData:contentData keyData:aesKeyData];
    if (!MKValidData(encryptData) || encryptData.length != 16) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSMutableData *commandData = [[NSMutableData alloc] init];
    Byte headerB[1] = {0x00};
    [commandData appendData:[NSData dataWithBytes:headerB length:1]];
    [commandData appendData:encryptData];
    [centralManager addTaskWithTaskID:MKEddystoneSetLockStateOperation
                          commandData:[MKEddystoneAdopter hexStringFromData:commandData]
                       characteristic:centralManager.peripheral.lockState
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readEddystoneAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addReadTaskWithTaskID:MKEddystoneReadAdvSlotDataOperation
                           characteristic:centralManager.peripheral.advSlotData
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readEddystoneiBeaconAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock{
    dispatch_async(dispatch_queue_create("MKEddystoneReadiBeaconAdvDataQueue", 0), ^{
        NSString *uuid = [self iBeaconUUID];
        if (!MKValidStr(uuid)) {
            [MKEddystoneAdopter operationRequestDataErrorBlock:failedBlock];
            return;
        }
        NSDictionary *advData = [self iBeaconAdvData];
        if (!MKValidDict(advData)) {
            [MKEddystoneAdopter operationRequestDataErrorBlock:failedBlock];
            return;
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:advData];
        [dic setObject:uuid forKey:@"uuid"];
        NSDictionary *resultDic = @{
                                    @"msg":@"success",
                                    @"code":@"1",
                                    @"result":dic,
                                    };
        if (sucBlock) {
            moko_main_safe(^{
                sucBlock(resultDic);
            });
        }
    });
}

+ (void)setURLEddystoneAdvData:(urlHeaderType )urlHeader
                    urlContent:(NSString *)urlContent
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock{
    if (![MKEddystoneAdopter checkUrlContent:urlContent]) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *header = @"";
    NSString *tempHeader = @"";
    if (urlHeader == urlHeaderType1) {
        header = @"00";
        tempHeader = @"http://www.";
    }else if (urlHeader == urlHeaderType2){
        header = @"01";
        tempHeader = @"https://www.";
    }else if (urlHeader == urlHeaderType3){
        header = @"02";
        tempHeader = @"http://";
    }else if (urlHeader == urlHeaderType4){
        header = @"03";
        tempHeader = @"https://";
    }
    NSString *urlString = [MKEddystoneAdopter fecthUrlStringWithHeader:tempHeader urlContent:urlContent];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"10",header,urlString];
    [centralManager addTaskWithTaskID:MKEddystoneSetAdvSlotDataOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.advSlotData
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setUIDEddystoneAdvDataWithNameSpace:(NSString *)nameSpace
                                 instanceID:(NSString *)instanceID
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock{
    if (![MKEddystoneAdopter isNameSpace:nameSpace] || ![MKEddystoneAdopter isInstanceID:instanceID]) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"00",nameSpace,instanceID];
    [centralManager addTaskWithTaskID:MKEddystoneSetAdvSlotDataOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.advSlotData
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setTLMEddystoneAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addTaskWithTaskID:MKEddystoneSetAdvSlotDataOperation
                          commandData:@"20"
                       characteristic:centralManager.peripheral.advSlotData
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setNoDataEddystoneAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addTaskWithTaskID:MKEddystoneSetAdvSlotDataOperation
                          commandData:@"00"
                       characteristic:centralManager.peripheral.advSlotData
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setiBeaconEddystoneAdvDataWithMajor:(NSInteger)major
                                      minor:(NSInteger)minor
                                       uuid:(NSString *)uuid
                               measurePower:(NSInteger)measurePower
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock{
    if (major < 0 || major > 65535 || minor < 0 || minor > 65535
        || measurePower < 0 || measurePower > 255 || ![MKEddystoneAdopter isUUIDString:uuid]) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    dispatch_async(dispatch_queue_create("setiBeaconAdvDataQueue", 0), ^{
        BOOL success = [self setiBeaconMajor:major minor:minor measurePower:measurePower];
        if (!success) {
            [MKEddystoneAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        BOOL uuidSuccess = [self setiBeaconUUID:uuid];
        if (!uuidSuccess) {
            [MKEddystoneAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        NSDictionary *resultDic = @{
                                    @"msg":@"success",
                                    @"code":@"1",
                                    @"result":@{},
                                    };
        if (sucBlock) {
            moko_main_safe(^{
                sucBlock(resultDic);
            });
        }
    });
}

+ (void)eddystoneFactoryDataResetWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addTaskWithTaskID:MKEddystoneSetFactoryResetOperation
                          commandData:@"0b"
                       characteristic:centralManager.peripheral.factoryReset
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readEddystoneVendorWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addReadTaskWithTaskID:MKEddystoneReadVendorOperation
                           characteristic:centralManager.peripheral.vendor
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readEddystoneMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *commandString = @"ea570000";
    [centralManager addTaskWithTaskID:MKEddystoneReadMacAddressOperation
                          commandData:commandString
                       characteristic:[MKCentralManager sharedInstance].peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readEddystoneSlotDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *commandString = @"ea610000";
    [centralManager addTaskWithTaskID:MKEddystoneReadSlotTypeOperation
                          commandData:commandString
                       characteristic:[MKCentralManager sharedInstance].peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readEddystoneiBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *commandString = @"ea640000";
    [centralManager addTaskWithTaskID:MKEddystoneReadiBeaconUUIDOperation
                          commandData:commandString
                       characteristic:[MKCentralManager sharedInstance].peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readEddystoneDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *commandString = @"ea590000";
    [centralManager addTaskWithTaskID:MKEddystoneReadDeviceNameOperation
                          commandData:commandString
                       characteristic:[MKCentralManager sharedInstance].peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readEddystoneiBeaconDataWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *commandString = @"ea660000";
    [centralManager addTaskWithTaskID:MKEddystoneReadiBeaconDataOperation
                          commandData:commandString
                       characteristic:[MKCentralManager sharedInstance].peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readEddystoneConnectEnableStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *commandString = @"ea900000";
    [centralManager addTaskWithTaskID:MKEddystoneReadConnectEnableOperation
                          commandData:commandString
                       characteristic:[MKCentralManager sharedInstance].peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

#pragma mark - set data
+ (void)setEddystoneDeviceName:(NSString *)deviceName
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock{
    if (!deviceName || ![deviceName isKindOfClass:[NSString class]] || deviceName.length == 0 || deviceName.length > 8) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *len = [NSString stringWithFormat:@"%1lx",(unsigned long)(tempString.length / 2)];
    if (len.length == 1) {
        len = [@"0" stringByAppendingString:len];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea5800",len,tempString];
    [[MKCentralManager sharedInstance] addTaskWithTaskID:MKEddystoneSetDeviceNameOperation
                                             commandData:commandString
                                          characteristic:[MKCentralManager sharedInstance].peripheral.iBeaconWrite
                                            successBlock:sucBlock
                                            failureBlock:failedBlock];
}

+ (void)setEddystoneConnectStatus:(BOOL)connectEnable
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *status = (connectEnable ? @"01" : @"00");
    NSString *commandString = [@"ea890001" stringByAppendingString:status];
    [[MKCentralManager sharedInstance] addTaskWithTaskID:MKEddystoneSetConnectEnableOperation
                                             commandData:commandString
                                          characteristic:[MKCentralManager sharedInstance].peripheral.iBeaconWrite
                                            successBlock:sucBlock
                                            failureBlock:failedBlock];
}

+ (void)setEddystonePowerOffWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock{
    NSString *commandString = @"ea600000";
    [[MKCentralManager sharedInstance] addTaskWithTaskID:MKEddystoneSetPowerOffOperation
                                             commandData:commandString
                                          characteristic:[MKCentralManager sharedInstance].peripheral.iBeaconWrite
                                            successBlock:sucBlock
                                            failureBlock:failedBlock];
}

+ (void)readEddystoneModeIDWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addReadTaskWithTaskID:MKEddystoneReadModeIDOperation
                           characteristic:centralManager.peripheral.modeID
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readEddystoneProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addReadTaskWithTaskID:MKEddystoneReadProductionDateOperation
                           characteristic:centralManager.peripheral.productionDate
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readEddystoneHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addReadTaskWithTaskID:MKEddystoneReadHardwareOperation
                           characteristic:centralManager.peripheral.hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readEddystoneFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addReadTaskWithTaskID:MKEddystoneReadFirmwareOperation
                           characteristic:centralManager.peripheral.firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readEddystoneSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addReadTaskWithTaskID:MKEddystoneReadSoftwareOperation
                           characteristic:centralManager.peripheral.software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readEddystoneBatteryWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock{
    [centralManager addReadTaskWithTaskID:MKEddystoneReadBatteryOperation
                           characteristic:centralManager.peripheral.battery
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark - private method
+ (NSString *)fecthSlotNumber:(eddystoneActiveSlotNo)slotNo{
    switch (slotNo) {
        case eddystoneActiveSlot1:
            return @"00";
        case eddystoneActiveSlot2:
            return @"01";
        case eddystoneActiveSlot3:
            return @"02";
        case eddystoneActiveSlot4:
            return @"03";
        case eddystoneActiveSlot5:
            return @"04";
    }
}

+ (NSString *)fecthTxPower:(slotRadioTxPower)radioPower{
    switch (radioPower) {
        case slotRadioTxPower4dBm:
            return @"04";
            
        case slotRadioTxPower3dBm:
            return @"03";
            
        case slotRadioTxPower0dBm:
            return @"00";
            
        case slotRadioTxPowerNeg4dBm:
            return @"fc";
            
        case slotRadioTxPowerNeg8dBm:
            return @"f8";
            
        case slotRadioTxPowerNeg12dBm:
            return @"f4";
            
        case slotRadioTxPowerNeg16dBm:
            return @"f0";
            
        case slotRadioTxPowerNeg20dBm:
            return @"ec";
            
        case slotRadioTxPowerNeg40dBm:
            return @"d8";
    }
}

+ (NSString *)iBeaconUUID{
    __block NSString *uuid = @"";
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    MKEddystoneOperation *operation = [[MKEddystoneOperation alloc] initOperationWithID:MKEddystoneReadiBeaconUUIDOperation resetNum:NO commandBlock:^{
        NSString *commandString = @"ea640000";
        [centralManager.peripheral writeValue:[MKEddystoneAdopter stringToData:commandString]
                            forCharacteristic:centralManager.peripheral.iBeaconWrite
                                         type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError *error, MKEddystoneOperationID operationID, id returnData) {
        if (!error) {
            NSArray *dataList = (NSArray *)returnData[MKEddystoneDataInformation];
            NSDictionary *resultDic = dataList[0];
            uuid = resultDic[@"uuid"];
        }
        dispatch_semaphore_signal(semaphore);
    }];
    if (!operation) {
        return uuid;
    }
    [centralManager addOperation:operation];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return uuid;
}

+ (NSDictionary *)iBeaconAdvData{
    __block NSDictionary *advData = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    MKEddystoneOperation *operation = [[MKEddystoneOperation alloc] initOperationWithID:MKEddystoneReadiBeaconDataOperation resetNum:NO commandBlock:^{
        NSString *commandString = @"ea660000";
        [centralManager.peripheral writeValue:[MKEddystoneAdopter stringToData:commandString]
                            forCharacteristic:centralManager.peripheral.iBeaconWrite
                                         type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError *error, MKEddystoneOperationID operationID, id returnData) {
        if (!error) {
            NSArray *dataList = (NSArray *)returnData[MKEddystoneDataInformation];
            advData = dataList[0];
        }
        dispatch_semaphore_signal(semaphore);
    }];
    if (!operation) {
        return advData;
    }
    [centralManager addOperation:operation];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return advData;
}

+ (BOOL)setiBeaconMajor:(NSInteger )major
                  minor:(NSInteger )minor
           measurePower:(NSInteger )measurePower{
    NSString *majorHex = [NSString stringWithFormat:@"%1lx",(unsigned long)major];
    if (majorHex.length == 1) {
        majorHex = [@"000" stringByAppendingString:majorHex];
    }else if (majorHex.length == 2){
        majorHex = [@"00" stringByAppendingString:majorHex];
    }else if (majorHex.length == 3){
        majorHex = [@"0" stringByAppendingString:majorHex];
    }
    NSString *minorHex = [NSString stringWithFormat:@"%1lx",(unsigned long)minor];
    if (minorHex.length == 1) {
        minorHex = [@"000" stringByAppendingString:minorHex];
    }else if (minorHex.length == 2){
        minorHex = [@"00" stringByAppendingString:minorHex];
    }else if (minorHex.length == 3){
        minorHex = [@"0" stringByAppendingString:minorHex];
    }
    NSString *powerHex = [NSString stringWithFormat:@"%1lx",(unsigned long)measurePower];
    if (powerHex.length == 1) {
        powerHex = [@"0" stringByAppendingString:powerHex];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea670005",majorHex,minorHex,powerHex];
    __block BOOL success = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    MKEddystoneOperation *operation = [[MKEddystoneOperation alloc] initOperationWithID:MKEddystoneSetiBeaconDataOperation resetNum:NO commandBlock:^{
        [centralManager.peripheral writeValue:[MKEddystoneAdopter stringToData:commandString]
                            forCharacteristic:centralManager.peripheral.iBeaconWrite
                                         type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError *error, MKEddystoneOperationID operationID, id returnData) {
        if (!error) {
            success = YES;
        }
        dispatch_semaphore_signal(semaphore);
    }];
    if (!operation) {
        return success;
    }
    [centralManager addOperation:operation];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

+ (BOOL)setiBeaconUUID:(NSString *)uuid{
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *commandString = [@"ea650010" stringByAppendingString:uuid];
    __block BOOL success = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    MKEddystoneOperation *operation = [[MKEddystoneOperation alloc] initOperationWithID:MKEddystoneSetiBeaconUUIDOperation resetNum:NO commandBlock:^{
        [centralManager.peripheral writeValue:[MKEddystoneAdopter stringToData:commandString]
                            forCharacteristic:centralManager.peripheral.iBeaconWrite
                                         type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError *error, MKEddystoneOperationID operationID, id returnData) {
        if (!error) {
            success = YES;
        }
        dispatch_semaphore_signal(semaphore);
    }];
    if (!operation) {
        return success;
    }
    [centralManager addOperation:operation];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

@end
