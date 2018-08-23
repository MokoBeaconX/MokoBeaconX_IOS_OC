//
//  MKEddystoneInterface.h
//  EddystoneSDK
//
//  Created by aa on 2018/8/9.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Target SLOT numbers(enum)，slot0~slot4
 */
typedef NS_ENUM(NSInteger, eddystoneActiveSlotNo) {
    eddystoneActiveSlot1,//SLOT 0
    eddystoneActiveSlot2,//SLOT 1
    eddystoneActiveSlot3,//SLOT 2
    eddystoneActiveSlot4,//SLOT 3
    eddystoneActiveSlot5,//SLOT 4
};
typedef NS_ENUM(NSInteger, slotRadioTxPower) {
    slotRadioTxPower4dBm,       //RadioTxPower:4dBm
    slotRadioTxPower3dBm,       //3dBm
    slotRadioTxPower0dBm,       //0dBm
    slotRadioTxPowerNeg4dBm,    //-4dBm
    slotRadioTxPowerNeg8dBm,    //-8dBm
    slotRadioTxPowerNeg12dBm,   //-12dBm
    slotRadioTxPowerNeg16dBm,   //-16dBm
    slotRadioTxPowerNeg20dBm,   //-20dBm
    slotRadioTxPowerNeg40dBm,   //-40dBm
};
typedef NS_ENUM(NSInteger, urlHeaderType) {
    urlHeaderType1,             //http://www.
    urlHeaderType2,             //https://www.
    urlHeaderType3,             //http://
    urlHeaderType4,             //https://
};

@interface MKEddystoneInterface : NSObject

#pragma mark - *****************note:所有的数据操作必须基于当前eddystone处于unlock状态(unlock特征和lock state特征例外)*****************

/**
 Reading currently active SLOT.0~slot0,1~slot1,2~slot2,3~slot3,4~slot4.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneActiveSlotWithSucBlock:(void (^)(id returnData))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;
/**
 MokoBeaconX provides up to 5 SLOTs for users to configure advertisement frame. Before configering the SLOT’s parameter， you should switch the SLOT to target SLOT fristly; otherwise the configuration is only for the currently active SLOT.

 @param slotNo Target SLOT number to switch to
 @param sucBlock sucBlock
 @param failedBlock failedBlock
 */
+ (void)setEddystoneActiveSlot:(eddystoneActiveSlotNo)slotNo
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading Advertising Interval.Before reading the target SLOT’s Advertising Interval, you should switch the SLOT to target SLOT(Please refer to ，setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the Advertising Interval read is only for the currently active SLOT.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneAdvertisingIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting Advertising Interval.Advertising Interval is different for each SLOT. Before setting the target SLOT’s Advertising Interval, you should switch the SLOT to target SLOT(Please refer to ，setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the Advertising Interval set is only for the currently active SLOT.

 @param advertingInterval Advertising Interval，Unit: ms，range from 100ms to 5000ms
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setEddystoneAdvertingInterval:(NSInteger)advertingInterval
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading Radio Tx Power.Radio Tx Power is different for each SLOT. Before reading the target SLOT’s Radio Tx Power, you should switch the SLOT to target SLOT(Please refer to ，setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the Radio Tx Power read is only for the currently active SLOT.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneRadioTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting Radio Tx Power.Radio Tx Power is different for each SLOT. Before setting the target SLOT’s Radio Tx Power, you should switch the SLOT to target SLOT(Please refer to ，setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the Radio Tx Power set is only for the currently active SLOT.

 @param power power
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setEddystoneRadioTxPower:(slotRadioTxPower )power
                        sucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading Advertised Tx Power(RSSI@0m, only for eddystone frame).Advertised Tx Power is different for each SLOT. Before reading the target SLOT’s Advertised Tx Power, you should switch the SLOT to target SLOT(Please refer to ，setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the Advertised Tx Power read is only for the currently active SLOT.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneAdvTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting Advertised Tx Power(RSSI@0m, only for eddystone frame).Advertised Tx Power is different for each SLOT. Before setting the target SLOT’s Advertised Tx Power, you should switch the SLOT to target SLOT(Please refer to ，setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the Advertised Tx Power set is only for the currently active SLOT.
 
 @param advTxPower Advertised Tx Power, range from -127dBm to 0dBm
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setEddystoneAdvTxPower:(NSInteger)advTxPower
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Modifying connection password.Only if the device’s LockState is in UNLOCKED state, the password can be modified.

 @param newPassword New password, 8 characters, can only be letters or numbers
 @param originalPassword Old password, 8 characters, can only be letters or numbers
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setEddystoneNewPassword:(NSString *)newPassword
               originalPassword:(NSString *)originalPassword
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading the advertisement data set in the active SLOT.The advertisement data is different for each SLOT. Before reading the advertisement data, you should switch the SLOT to target SLOT(Please refer to setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the advertisement data read is only for the currently active SLOT.
 To read the advertisement data set in the active SLOT, host must get the current SLOT type(Please refer to readEddStoneSlotDataTypeWithSuccessBlock:failedBlock: to get all 5 SLOTS advertisement types).
 When the currently active SLOT type is UID, URL, TLM or NO DATE, host can read the advertisement data effectively. If the currently active SLOT type is iBeacon, it needs readEddystoneiBeaconAdvDataWithSucBlock:failedBlock: to read.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
/**
 reading the advertisement data for beacon

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneiBeaconAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Configuring currently active SLOT as URL.To configure the target SLOT type as URL, you should switch the SLOT to target SLOT(Please refer to setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the currently active SLOT will configured as URL.

 @param urlHeader URL Scheme Prefix.
 @param urlContent Encoded URL. If the URL contains HTTP URL encoding, the length of the left datas should be 16bytes at most. If the URL doesn’t contain HTTP URL encoding, the full length of Encoded URL should be 2-17bytes.
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setURLEddystoneAdvData:(urlHeaderType )urlHeader
                    urlContent:(NSString *)urlContent
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;
/**
 configuring currently active SLOT as UID.To configure the target SLOT type as UID, you should switch the SLOT to target SLOT(Please refer to setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the currently active SLOT will configured as UID.
 
 @param nameSpace NameSpace, 20 characters
 @param instanceID Instance，12 characters
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setUIDEddystoneAdvDataWithNameSpace:(NSString *)nameSpace
                                 instanceID:(NSString *)instanceID
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Configuring currently active SLOT as TLM.To configure the target SLOT type as TLM, you should switch the SLOT to target SLOT(Please refer to setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the currently active SLOT will configured as TLM.
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setTLMEddystoneAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Configuring currently active SLOT as NO DATA.To configure the target SLOT type as NO DATA, you should switch the SLOT to target SLOT(Please refer to setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the currently active SLOT will configured as NO DATA.
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setNoDataEddystoneAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Configuring currently active SLOT as iBeacon.To configure the target SLOT type as iBeacon, you should switch the SLOT to target SLOT(Please refer to setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the currently active SLOT will configured as iBeacon.
 
 @param major major,0~65535
 @param minor minor,0~65535
 @param uuid uuid
 @param measurePower Measured power(RSSI@0m)，0~255
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setiBeaconEddystoneAdvDataWithMajor:(NSInteger)major
                                      minor:(NSInteger)minor
                                       uuid:(NSString *)uuid
                               measurePower:(NSInteger)measurePower
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Resetting to factory state (RESET).NOTE:When resetting the device, the connection password will not be restored which shall remain set to its current value.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)eddystoneFactoryDataResetWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - read data
/**
 Reading device’s MAC address
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading current frame types of the 5 SLOTs,
 eg:@"001020506070":@"00":UID,@"10":URL,@"20":TLM,@"50":iBeacon,@"60":INFO,@"70":NO DATA
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneSlotDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading Device Name
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading current connection status
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneConnectEnableStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - custom data
/**
 Setting Device Name
 
 @param deviceName deviceName，the maximum length is 8 characters
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setEddystoneDeviceName:(NSString *)deviceName
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting device’s connection status.
 NOTE: Be careful to set device’s connection statue .Once the device is set to not connectable, it may not be connected, and other parameters cannot be configured.
 
 @param connectEnable YES：Connectable，NO：Not Connectable
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setEddystoneConnectStatus:(BOOL)connectEnable
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - 180A system data
/**
 Reading the vendor information

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneVendorWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading the device's modeID

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneModeIDWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading the production date of device

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s hardware version

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s firmware version

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s software version

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
#pragma mark - battery
/**
 Reading device’s battery power percentage

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readEddystoneBatteryWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

@end
