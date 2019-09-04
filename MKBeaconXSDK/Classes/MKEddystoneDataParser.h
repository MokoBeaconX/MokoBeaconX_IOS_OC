//
//  MKEddystoneDataParser.h
//  EddystoneSDK
//
//  Created by aa on 2018/8/9.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

extern NSString *const MKEddystoneDataNum;

@interface MKEddystoneDataParser : NSObject

+ (NSDictionary *)parseReadDataFromCharacteristic:(CBCharacteristic *)characteristic;

+ (NSDictionary *)parseWriteDataFromCharacteristic:(CBCharacteristic *)characteristic;

@end
