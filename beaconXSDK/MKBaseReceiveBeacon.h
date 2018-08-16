//
//  MKBaseReceiveBeacon.h
//  EddystoneSDK
//
//  Created by aa on 2018/8/8.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/**
 * Eddystones have three frame types.
 * See the Eddystone specification for complete details.
 */
typedef NS_ENUM(NSUInteger, MKFrameType) {
    MKEddystoneUIDFrameType = 0,                   //UID
    MKEddystoneURLFrameType = 1,                   //URL
    MKEddystoneTLMFrameType = 2,                   //TLM
    MKEddystoneiBeaconFrameType = 3,               //iBeacon信息
    MKEddystoneInfoFrameType = 4,                  //设备信息
    MKEddystoneNODATAFrameType = 5,                //NO DATA
    MKEddystoneUnknownFrameType = 6                //未知
};

@interface MKBaseReceiveBeacon : NSObject

/**
 帧类型
 */
@property (nonatomic, assign)MKFrameType frameType;

/**
 信号值强度
 */
@property (nonatomic, strong)NSNumber *rssi;

/**
 外设标识符
 */
@property (nonatomic, copy)NSString *identifier;

/**
 当前数据来源
 */
@property (nonatomic, strong)CBPeripheral *peripheral;

/**
 原始的广播数据
 */
@property (nonatomic, strong)NSData *advertiseData;

+ (MKBaseReceiveBeacon *)fecthBeaconWithAdvData:(NSDictionary *)advertisementData;

+ (MKFrameType)fecthEddystoneFrameTypeWithSlotData:(NSData *)advData;

@end

#pragma mark - TLM广播帧
@interface MKReceiveTLMBeacon : MKBaseReceiveBeacon

@property (nonatomic) NSNumber *version;
@property (nonatomic) NSNumber *mvPerbit;
@property (nonatomic) NSNumber *temperature;
@property (nonatomic) NSNumber *advertiseCount;
@property (nonatomic) NSNumber *deciSecondsSinceBoot;

- (MKReceiveTLMBeacon *)initWithAdvertiseData:(NSData *)advertiseData;

@end

#pragma mark - UID广播帧
@interface MKReceiveUIDBeacon : MKBaseReceiveBeacon

@property (nonatomic) NSNumber *txPower;
@property (nonatomic) NSString *namespaceId;
@property (nonatomic) NSString *instanceId;

- (MKReceiveUIDBeacon *)initWithAdvertiseData:(NSData *)advertiseData;

@end

#pragma mark - URL广播帧
@interface MKReceiveURLBeacon : MKBaseReceiveBeacon

@property (nonatomic) NSNumber *txPower;
@property (nonatomic) NSString *shortUrl;

- (MKReceiveURLBeacon *)initWithAdvertiseData:(NSData *)advertiseData;

@end

#pragma mark - iBeacon广播信息帧
@interface MKReceiveiBeacon : MKBaseReceiveBeacon

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

@property (nonatomic, copy)NSString *txPower;

- (MKReceiveiBeacon *)initWithAdvertiseData:(NSData *)advertiseData;

@end

#pragma mark - 自定义广播帧
@interface MKReceivePeripheralInfoBeacon : MKBaseReceiveBeacon

/**
 广播间隔，单位s
 */
@property (nonatomic, copy)NSString *broadcastInterval;

/**
 发射功率
 */
@property (nonatomic, copy)NSString *radioPower;

/**
 mac地址
 */
@property (nonatomic, copy)NSString *macAddress;

/**
 软件版本
 */
@property (nonatomic, copy)NSString *firmwareVersion;

/**
 电池电量百分比
 */
@property (nonatomic, copy)NSString *battery;

/**
 设备名称
 */
@property (nonatomic, copy)NSString *peripheralName;

- (MKReceivePeripheralInfoBeacon *)initWithAdvertiseData:(NSData *)advertiseData;

@end
