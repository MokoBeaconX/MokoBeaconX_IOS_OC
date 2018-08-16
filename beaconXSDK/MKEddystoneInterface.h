//
//  MKEddystoneInterface.h
//  EddystoneSDK
//
//  Created by aa on 2018/8/9.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 通道号，slot1~slot5
 */
typedef NS_ENUM(NSInteger, eddystoneActiveSlotNo) {
    eddystoneActiveSlot1,
    eddystoneActiveSlot2,
    eddystoneActiveSlot3,
    eddystoneActiveSlot4,
    eddystoneActiveSlot5,
};
typedef NS_ENUM(NSInteger, slotRadioTxPower) {
    slotRadioTxPower4dBm,       //发射功率为4dBm
    slotRadioTxPower3dBm,       //发射功率为3dBm
    slotRadioTxPower0dBm,       //发射功率为0dBm
    slotRadioTxPowerNeg4dBm,    //发射功率为-4dBm
    slotRadioTxPowerNeg8dBm,    //发射功率为-8dBm
    slotRadioTxPowerNeg12dBm,   //发射功率为-12dBm
    slotRadioTxPowerNeg16dBm,   //发射功率为-16dBm
    slotRadioTxPowerNeg20dBm,   //发射功率为-20dBm
    slotRadioTxPowerNeg40dBm,   //发射功率为-40dBm
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
 读取eddystone活跃的通道,当前eddystone共有5个通道(通道号从0~4，分别对应slot1~slot5)，默认活跃的是通道0(slot1).

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneActiveSlotWithSucBlock:(void (^)(id returnData))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置eddystone当前活跃的通道

 @param slotNo 要设置活跃状态的通道号
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setEddystoneActiveSlot:(eddystoneActiveSlotNo)slotNo
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取eddystone的广播间隔。广播间隔对于每个通道来说都不一样，要读取某个通道的广播间隔，首先需要切换到目标通道，setEddystoneActiveSlot:
 successBlock:failedBlock:方法可以切换到目标通道。如果不切换通道直接调用本方法，则读取的是当前活跃通道的广播间隔。

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneAdvertisingIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置eddystone的广播间隔。广播间隔对于每个通道来说都不一样，要设置某个通道的广播间隔，首先需要切换到目标通道，setEddystoneActiveSlot:
 successBlock:failedBlock:方法可以切换到目标通道。如果不切换通道直接调用本方法，则设置的是当前活跃通道的广播间隔。

 @param advertingInterval 广播间隔，单位是ms，范围100ms~4000ms
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setEddystoneAdvertingInterval:(NSInteger)advertingInterval
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取当前活跃通道的发射功率，发射功率对于每个通道来说都不一样，要读取某个通道的发射功率，首先需要切换到目标通道，setEddystoneActiveSlot:
 successBlock:failedBlock:方法可以切换到目标通道。如果不切换通道直接调用本方法，则读取的是当前活跃通道的发射功率。

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneRadioTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置当前活跃通道的发射功率，发射功率对于每个通道来说都不一样，要设置某个通道的发射功率，首先需要切换到目标通道，setEddystoneActiveSlot:
 successBlock:failedBlock:方法可以切换到目标通道。如果不切换通道直接调用本方法，则设置的是当前活跃通道的发射功率。

 @param power power
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setEddystoneRadioTxPower:(slotRadioTxPower )power
                        sucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取当前活跃通道的广播功率，广播功率对于每个通道来说都不一样，要读取某个通道的广播功率，首先需要切换到目标通道，setEddystoneActiveSlot:
 successBlock:failedBlock:方法可以切换到目标通道。如果不切换通道直接调用本方法，则读取的是当前活跃通道的广播功率。

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneAdvTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置当前活跃通道的广播功率，广播功率对于每个通道来说都不一样，要设置某个通道的广播功率，首先需要切换到目标通道，setEddystoneActiveSlot:
 successBlock:failedBlock:方法可以切换到目标通道。如果不切换通道直接调用本方法，则设置的是当前活跃通道的广播功率。

 @param advTxPower 通道广播功率,-127dBm ~ 0dBm
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setEddystoneAdvTxPower:(NSInteger)advTxPower
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;
/**
 修改解锁密码

 @param newPassword 新的解锁密码
 @param originalPassword 原来的解锁密码
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setEddystoneNewPassword:(NSString *)newPassword
               originalPassword:(NSString *)originalPassword
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取当前活跃通道的广播信息。广播信息对于每个通道来说都不一样，要读取某个通道的广播信息，首先需要切换到目标通道，setEddystoneActiveSlot:
 successBlock:failedBlock:方法可以切换到目标通道。如果不切换通道直接调用本方法，则读取的是当前活跃通道的广播信息。要读取广播信息首先需要知道当前活跃通道的广播类型，readEddystoneActiveSlotWithSucBlock:failedBlock:可以获取当前活跃通道号，readEddystoneSlotDataTypeWithSucBlock:failedBlock:方法可以获取当前5个通道分别是什么类型。如果当前通道为iBeacon，则需要用readEddystoneiBeaconAdvDataWithSucBlock:failedBlock:来获取当前通道的广播信息。

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
/**
 用自定义协议读取当前活跃通道为iBeacon时候的信息

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneiBeaconAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;
/**
 将当前活跃通道配置为url类型。要设置某个通道数据类型为url，首先需要切换到目标通道，setEddystoneActiveSlot:
 successBlock:failedBlock:方法可以切换到目标通道。如果不切换通道直接调用本方法，则会把当前活跃的通道配置为url类型

 @param urlHeader 协议头，@"http://www.",@"https://www.",@"http://",@"https://"四种
 @param urlContent 域名部分。如果是一个合法的域名，则后缀必须为eddyStone官方支持的其中一种，中间部分最大长度为16个字节,如果不是符合官方要求的后缀名，判断长度是否大于17并且小于2，如果是大于17或者小于2则认为错误，否则直接认为符合要求。如果是不合法的域名，则整体长度应为2~17个字节
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setURLEddystoneAdvData:(urlHeaderType )urlHeader
                    urlContent:(NSString *)urlContent
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;
/**
 将当前活跃通道配置为UID类型。要设置某个通道数据类型为UID，首先需要切换到目标通道，setEddystoneActiveSlot:
 successBlock:failedBlock:方法可以切换到目标通道。如果不切换通道直接调用本方法，则会把当前活跃的通道配置为UID类型

 @param nameSpace nameSpace,长度为20
 @param instanceID instanceID，长度为12
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setUIDEddystoneAdvDataWithNameSpace:(NSString *)nameSpace
                                 instanceID:(NSString *)instanceID
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;
/**
 将当前活跃通道配置为TLM类型。要设置某个通道数据类型为TLM，首先需要切换到目标通道，setEddystoneActiveSlot:
 successBlock:failedBlock:方法可以切换到目标通道。如果不切换通道直接调用本方法，则会把当前活跃的通道配置为TLM类型

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setTLMEddystoneAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;
/**
 将当前活跃通道配置为NO DATA类型。要设置某个通道数据类型为NO DATA，首先需要切换到目标通道，setEddystoneActiveSlot:
 successBlock:failedBlock:方法可以切换到目标通道。如果不切换通道直接调用本方法，则会把当前活跃的通道配置为NO DATA类型

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setNoDataEddystoneAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;
/**
 将当前活跃通道配置为iBeacon类型。要设置某个通道数据类型为iBeacon，首先需要切换到目标通道，setEddystoneActiveSlot:
 successBlock:failedBlock:方法可以切换到目标通道。如果不切换通道直接调用本方法，则会把当前活跃的通道配置为iBeacon类型

 @param major iBeacon的主值,0~65535
 @param minor iBeacon的次值,0~65535
 @param uuid iBeacon的UUID
 @param measurePower iBeacon的校验距离，0~255
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setiBeaconEddystoneAdvDataWithMajor:(NSInteger)major
                                      minor:(NSInteger)minor
                                       uuid:(NSString *)uuid
                               measurePower:(NSInteger)measurePower
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;
/**
 恢复出厂设置。注意:恢复出厂设置的时候，连接密码不会被恢复

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)eddystoneFactoryDataResetWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - read data
/**
 读取eddystone的mac地址
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取当前eddystone的5个通道类型,如数据@"0010205060ff":
 将数据切割成长度为2的字符串，@"00":UID,@"10":URL,@"20":TLM,@"50":iBeacon,@"60":INFO,@"70":NO DATA
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneSlotDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;
/**
 获取设备名称
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;
/**
 获取eddystone的可连接状态
 
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneConnectEnableStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - custom data
/**
 设置eddystone的设备名字
 
 @param deviceName 要设置的设备名字，最大长度是8个字符，只能是字母、数字、下划线
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setEddystoneDeviceName:(NSString *)deviceName
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置eddystone的可连接状态
 
 @param connectEnable YES:可连接，NO:不可连接
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)setEddystoneConnectStatus:(BOOL)connectEnable
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - 180A system data
/**
 读取厂商信息

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneVendorWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取产品型号信息

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneModeIDWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取生产日期

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取eddyStone硬件信息

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取eddyStone固件信息

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取eddyStone软件版本

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
#pragma mark - 电池服务
/**
 读取eddyStone的电池电量

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readEddystoneBatteryWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

@end
