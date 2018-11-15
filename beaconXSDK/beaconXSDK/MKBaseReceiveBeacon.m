//
//  MKBaseReceiveBeacon.m
//  EddystoneSDK
//
//  Created by aa on 2018/8/8.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKBaseReceiveBeacon.h"
#import "MKEddystoneAdopter.h"
#import "MKSDKDefines.h"
#import "MKEddystoneService.h"

@implementation MKBaseReceiveBeacon

+ (MKBaseReceiveBeacon *)fecthBeaconWithAdvData:(NSDictionary *)advertisementData{
    if (!MKValidDict(advertisementData)) {
        return nil;
    }
    NSDictionary *advDic = [advertisementData objectForKey:CBAdvertisementDataServiceDataKey];
    MKFrameType frameType = [self fecthFrameTypeWithAdvDic:advDic];
    MKBaseReceiveBeacon *beacon = nil;
    switch (frameType) {
        case MKEddystoneUIDFrameType:
            beacon = [[MKReceiveUIDBeacon alloc] initWithAdvertiseData:advDic[[CBUUID UUIDWithString:MKEddystoneServiceID]]];
            beacon.advertiseData = advDic[[CBUUID UUIDWithString:MKEddystoneServiceID]];
            break;
        case MKEddystoneURLFrameType:
            beacon = [[MKReceiveURLBeacon alloc] initWithAdvertiseData:advDic[[CBUUID UUIDWithString:MKEddystoneServiceID]]];
            beacon.advertiseData = advDic[[CBUUID UUIDWithString:MKEddystoneServiceID]];
            break;
        case MKEddystoneTLMFrameType:
            beacon = [[MKReceiveTLMBeacon alloc] initWithAdvertiseData:advDic[[CBUUID UUIDWithString:MKEddystoneServiceID]]];
            beacon.advertiseData = advDic[[CBUUID UUIDWithString:MKEddystoneServiceID]];
            break;
        case MKEddystoneInfoFrameType:
            beacon = [[MKReceivePeripheralInfoBeacon alloc] initWithAdvertiseData:advDic[[CBUUID UUIDWithString:MKPeripheralServiceID]]];
            beacon.advertiseData = advDic[[CBUUID UUIDWithString:MKPeripheralServiceID]];
            break;
        case MKEddystoneiBeaconFrameType:
            beacon = [[MKReceiveiBeacon alloc] initWithAdvertiseData:advDic[[CBUUID UUIDWithString:MKiBeaconServiceID]]];
            beacon.advertiseData = advDic[[CBUUID UUIDWithString:MKiBeaconServiceID]];
            break;
        default:
            return nil;
    }
    beacon.frameType = frameType;
    return beacon;
}

//这个是获取当前活跃通道的广播数据时候用到，如果当前通道是iBeacon，则需要用iBeacon的方式解析，不在这个范围之内
+ (MKFrameType)fecthEddystoneFrameTypeWithSlotData:(NSData *)slotData{
    unsigned long advertiseDataSize = slotData.length;
    if (advertiseDataSize == 0) {
        return MKEddystoneUnknownFrameType;
    }
    const unsigned char *cData = [slotData bytes];
    switch (*cData) {
        case 0x00:
            return MKEddystoneUIDFrameType;
            
        case 0x10:
            return MKEddystoneURLFrameType;
            
        case 0x20:
            return MKEddystoneTLMFrameType;
            
        case 0x60:
            return MKEddystoneInfoFrameType;
            
        case 0x70:
            return MKEddystoneNODATAFrameType;
    }
    return MKEddystoneUnknownFrameType;
}

+ (MKFrameType)fecthFrameTypeWithAdvDic:(NSDictionary *)advDic{
    //三种广播数据不能并存
    NSData *iBeaconData = advDic[[CBUUID UUIDWithString:MKiBeaconServiceID]];
    if (MKValidData(iBeaconData)) {
        return MKEddystoneiBeaconFrameType;
    }
    NSData *normalData = advDic[[CBUUID UUIDWithString:MKPeripheralServiceID]];
    if (MKValidData(normalData)) {
        return MKEddystoneInfoFrameType;
    }
    //Eddystone标准帧，这里面的通道可以配置为HCKEddystoneInfoFrameType和HCKEddystoneNODATAFrameType
    NSData *stoneData = advDic[[CBUUID UUIDWithString:MKEddystoneServiceID]];
    unsigned long advertiseDataSize = stoneData.length;
    if (advertiseDataSize == 0) {
        return MKEddystoneUnknownFrameType;
    }
    const unsigned char *cData = [stoneData bytes];
    switch (*cData) {
        case 0x00:
            return MKEddystoneUIDFrameType;
            
        case 0x10:
            return MKEddystoneURLFrameType;
            
        case 0x20:
            return MKEddystoneTLMFrameType;
    }
    return MKEddystoneUnknownFrameType;
}

@end

#pragma mark - TLM广播帧
@implementation MKReceiveTLMBeacon

- (MKReceiveTLMBeacon *)initWithAdvertiseData:(NSData *)advertiseData
{
    if (self = [super init]) {
        NSAssert1(!(advertiseData.length < 14), @"Invalid advertiseData:%@", advertiseData);
        
        const unsigned char *cData = [advertiseData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advertiseData.length);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < advertiseData.length; i++) {
            data[i] = *cData++;
        }
        /* [TDOO] Set TML Beacon Properties */
        self.version = [NSNumber numberWithInt:*(data+1)];
        self.mvPerbit = [NSNumber numberWithInt:((*(data+2) << 8) + *(data+3))];
        unsigned char temperatureInt = *(data+4);
        if (temperatureInt & 0x80) {
            self.temperature = [NSNumber numberWithFloat:(float)(- 0x100 + temperatureInt) + *(data+5) / 256.0];
        }
        else {
            self.temperature = [NSNumber numberWithFloat:(float)temperatureInt + *(data+5) / 256.0];
        }
        float advertiseCount = (*(data+6) * 16777216) + (*(data+7) * 65536) + (*(data+8) * 256) + *(data+9);
        self.advertiseCount = [NSNumber numberWithLong:advertiseCount];
        float deciSecondsSinceBoot = (((int)(*(data+10) * 16777216) + (int)(*(data+11) * 65536) + (int)(*(data+12) * 256) + *(data+13)) / 10.0);
        self.deciSecondsSinceBoot = [NSNumber numberWithFloat:deciSecondsSinceBoot];
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

#pragma mark - UID广播帧
@implementation MKReceiveUIDBeacon

- (MKReceiveUIDBeacon *)initWithAdvertiseData:(NSData *)advertiseData
{
    if (self = [super init]) {
        // On the spec, its 20 bytes. But some beacons doesn't advertise the last 2 RFU bytes.
        if (advertiseData.length <= 18) {
            return nil;
        }
        const unsigned char *cData = [advertiseData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advertiseData.length);
        NSAssert(data, @"failed to malloc");
        for (int i = 0; i < advertiseData.length; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.txPower = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.txPower = [NSNumber numberWithInt:txPowerChar];
        }
        self.namespaceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",*(data+2), *(data+3), *(data+4), *(data+5), *(data+6), *(data+7), *(data+8), *(data+9), *(data+10), *(data+11)];
        self.instanceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",*(data+12), *(data+13), *(data+14), *(data+15), *(data+16), *(data+17)];
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

#pragma mark - URL广播帧
@implementation MKReceiveURLBeacon

- (MKReceiveURLBeacon *)initWithAdvertiseData:(NSData *)advertiseData{
    if (self = [super init]) {
        NSAssert1(!(advertiseData.length < 3), @"Invalid advertiseData:%@", advertiseData);
        const unsigned char *cData = [advertiseData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advertiseData.length);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < advertiseData.length; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.txPower = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.txPower = [NSNumber numberWithInt:txPowerChar];
        }
        NSString *urlScheme = [MKEddystoneAdopter getUrlscheme:*(data+2)];
        
        NSString *url = urlScheme;
        for (int i = 0; i < advertiseData.length - 3; i++) {
            url = [url stringByAppendingString:[MKEddystoneAdopter getEncodedString:*(data + i + 3)]];
        }
        self.shortUrl = url;
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

#pragma mark - iBeacon广播信息帧
@implementation MKReceiveiBeacon

- (MKReceiveiBeacon *)initWithAdvertiseData:(NSData *)advertiseData{
    if (self = [super init]) {
        NSAssert1(!(advertiseData.length < 7), @"Invalid advertiseData:%@", advertiseData);
        NSString *temp = advertiseData.description;
        temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
        temp = [temp stringByReplacingOccurrencesOfString:@"<" withString:@""];
        temp = [temp stringByReplacingOccurrencesOfString:@">" withString:@""];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[temp substringWithRange:NSMakeRange(0, 8)],
                                 [temp substringWithRange:NSMakeRange(8, 4)],
                                 [temp substringWithRange:NSMakeRange(12, 4)],
                                 [temp substringWithRange:NSMakeRange(16,4)],
                                 [temp substringWithRange:NSMakeRange(20, 12)], nil];
        [array insertObject:@"-" atIndex:1];
        [array insertObject:@"-" atIndex:3];
        [array insertObject:@"-" atIndex:5];
        [array insertObject:@"-" atIndex:7];
        NSString *uuid = @"";
        for (NSString *string in array) {
            uuid = [uuid stringByAppendingString:string];
        }
        self.uuid = [uuid uppercaseString];
        self.major = [NSString stringWithFormat:@"%ld",(long)strtoul([[temp substringWithRange:NSMakeRange(32, 4)] UTF8String],0,16)];
        self.minor = [NSString stringWithFormat:@"%ld",(long)strtoul([[temp substringWithRange:NSMakeRange(36, 4)] UTF8String],0,16)];
        NSInteger rssiValue = strtoul([[temp substringWithRange:NSMakeRange(40, 2)] UTF8String],0,16);
        if (rssiValue == 0) {
            self.txPower = @"0";
        }else{
            self.txPower = [@"-" stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)rssiValue]];
        }
        NSLog(@"当前广播数据:%@",advertiseData);
    }
    return self;
}

@end

#pragma mark - 自定义广播帧
@implementation MKReceivePeripheralInfoBeacon

- (MKReceivePeripheralInfoBeacon *)initWithAdvertiseData:(NSData *)advertiseData{
    
    if (self = [super init]) {
        NSAssert1(!(advertiseData.length < 12), @"Invalid advertiseData:%@", advertiseData);
        NSString *temp = advertiseData.description;
        temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
        temp = [temp stringByReplacingOccurrencesOfString:@"<" withString:@""];
        temp = [temp stringByReplacingOccurrencesOfString:@">" withString:@""];
        NSInteger interval = strtoul([[temp substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
        self.broadcastInterval = [NSString stringWithFormat:@"%.1f",interval * 0.1];
        self.radioPower = [NSString stringWithFormat:@"%ld",(long)strtoul([[temp substringWithRange:NSMakeRange(2, 2)] UTF8String],0,16)];
        NSString *tempMac = [[temp substringWithRange:NSMakeRange(4, 12)] uppercaseString];
        self.macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[tempMac substringWithRange:NSMakeRange(0, 2)],[tempMac substringWithRange:NSMakeRange(2, 2)],[tempMac substringWithRange:NSMakeRange(4, 2)],[tempMac substringWithRange:NSMakeRange(6, 2)],[tempMac substringWithRange:NSMakeRange(8, 2)],[tempMac substringWithRange:NSMakeRange(10, 2)]];
        self.firmwareVersion = [temp substringWithRange:NSMakeRange(16, 2)];
        self.connectEnable = ([[temp substringWithRange:NSMakeRange(18, 2)] isEqualToString:@"01"]);
        self.battery = [NSString stringWithFormat:@"%ld",(long)strtoul([[temp substringWithRange:NSMakeRange(20, 2)] UTF8String],0,16)];
        NSData *nameData = [advertiseData subdataWithRange:NSMakeRange(11, advertiseData.length - 11)];
        NSString *nameString = [[NSString alloc] initWithData:nameData encoding:NSUTF8StringEncoding];
        self.peripheralName = nameString;
    }
    return self;
}

@end
