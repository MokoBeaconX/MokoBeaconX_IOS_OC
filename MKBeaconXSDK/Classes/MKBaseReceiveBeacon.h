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
    MKEddystoneiBeaconFrameType = 3,               //iBeacon
    MKEddystoneInfoFrameType = 4,                  //Device Information
    MKEddystoneNODATAFrameType = 5,                //NO DATA
    MKEddystoneUnknownFrameType = 6                //Unknown
};

@interface MKBaseReceiveBeacon : NSObject
/**
 Frame type
 */
@property (nonatomic, assign)MKFrameType frameType;
/**
 rssi
 */
@property (nonatomic, strong)NSNumber *rssi;
/**
 Scanned device identifier
 */
@property (nonatomic, copy)NSString *identifier;
/**
 Scanned devices
 */
@property (nonatomic, strong)CBPeripheral *peripheral;
/**
 Advertisement data of device
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
//RSSI@0m
@property (nonatomic) NSNumber *txPower;
@property (nonatomic) NSString *namespaceId;
@property (nonatomic) NSString *instanceId;

- (MKReceiveUIDBeacon *)initWithAdvertiseData:(NSData *)advertiseData;

@end

#pragma mark - URL广播帧
@interface MKReceiveURLBeacon : MKBaseReceiveBeacon
//RSSI@0m
@property (nonatomic) NSNumber *txPower;
//URL Content
@property (nonatomic) NSString *shortUrl;

- (MKReceiveURLBeacon *)initWithAdvertiseData:(NSData *)advertiseData;

@end

#pragma mark - iBeacon广播信息帧
@interface MKReceiveiBeacon : MKBaseReceiveBeacon

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;
//RSSI@0m
@property (nonatomic, copy)NSString *txPower;

- (MKReceiveiBeacon *)initWithAdvertiseData:(NSData *)advertiseData;

@end

#pragma mark - 自定义广播帧
@interface MKReceivePeripheralInfoBeacon : MKBaseReceiveBeacon

/**
 Advertising Interval， Unit：S
 */
@property (nonatomic, copy)NSString *broadcastInterval;
/**
 Tx Power
 */
@property (nonatomic, copy)NSString *radioPower;
/**
 mac
 */
@property (nonatomic, copy)NSString *macAddress;
/**
 firmware version
 */
@property (nonatomic, copy)NSString *firmwareVersion;
/**
 connectEnable
 */
@property (nonatomic, assign)BOOL connectEnable;
/**
 battery
 */
@property (nonatomic, copy)NSString *battery;
/**
 Device Name
 */
@property (nonatomic, copy)NSString *peripheralName;

- (MKReceivePeripheralInfoBeacon *)initWithAdvertiseData:(NSData *)advertiseData;

@end
