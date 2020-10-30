//
//  HCKDeviceInfoModel.m
//  HCKEddStone
//
//  Created by aa on 2017/12/28.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKDeviceInfoModel.h"

@interface HCKDeviceInfoModel()

@property (nonatomic, copy)readDataFromEddStoneSuccessBlock sucBlock;

@property (nonatomic, copy)readDataFromEddStoneFailedBlock failBlock;

@end

@implementation HCKDeviceInfoModel

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

/**
 获取系统信息

 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)startLoadSystemInformation:(readDataFromEddStoneSuccessBlock)successBlock
                       failedBlock:(readDataFromEddStoneFailedBlock)failedBlock{
    self.sucBlock = nil;
    self.sucBlock = successBlock;
    self.failBlock = nil;
    self.failBlock = failedBlock;
    [self getBattery];
}

- (void)getBattery{
    if ([MKCentralManager sharedInstance].connectState != MKEddystoneConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    WS(weakSelf);
    [MKEddystoneInterface readEddystoneBatteryWithSucBlock:^(id returnData) {
        weakSelf.battery = returnData[@"result"][@"battery"];
        [weakSelf getMacAddress];
    } failedBlock:^(NSError *error) {
        [weakSelf getMacAddress];
    }];
}

- (void)getMacAddress{
    if ([MKCentralManager sharedInstance].connectState != MKEddystoneConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.macAddress)) {
        [self getProduce];
        return;
    }
    WS(weakSelf);
    [MKEddystoneInterface readEddystoneMacAddressWithSucBlock:^(id returnData) {
        weakSelf.macAddress = returnData[@"result"][@"macAddress"];
        [weakSelf getProduce];
    } failedBlock:^(NSError *error) {
        [weakSelf getProduce];
    }];
}

- (void)getProduce{
    if ([MKCentralManager sharedInstance].connectState != MKEddystoneConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.produce)) {
        [self getSoftware];
        return;
    }
    WS(weakSelf);
    [MKEddystoneInterface readEddystoneModeIDWithSucBlock:^(id returnData) {
        weakSelf.produce = returnData[@"result"][@"modeID"];
        [weakSelf getSoftware];
    } failedBlock:^(NSError *error) {
        [weakSelf getSoftware];
    }];
}

- (void)getSoftware{
    if ([MKCentralManager sharedInstance].connectState != MKEddystoneConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.software)) {
        [self getFirmware];
        return;
    }
    WS(weakSelf);
    [MKEddystoneInterface readEddystoneSoftwareWithSucBlock:^(id returnData) {
        weakSelf.software = returnData[@"result"][@"software"];
        [weakSelf getFirmware];
    } failedBlock:^(NSError *error) {
        [weakSelf getFirmware];
    }];
}

- (void)getFirmware{
    if ([MKCentralManager sharedInstance].connectState != MKEddystoneConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.firmware)) {
        [self getHardware];
        return;
    }
    WS(weakSelf);
    [MKEddystoneInterface readEddystoneFirmwareWithSucBlock:^(id returnData) {
        weakSelf.firmware = returnData[@"result"][@"firmware"];
        [weakSelf getHardware];
    } failedBlock:^(NSError *error) {
        [weakSelf getHardware];
    }];
}

- (void)getHardware{
    if ([MKCentralManager sharedInstance].connectState != MKEddystoneConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.hardware)) {
        [self getManuDate];
        return;
    }
    WS(weakSelf);
    [MKEddystoneInterface readEddystoneHardwareWithSucBlock:^(id returnData) {
        weakSelf.hardware = returnData[@"result"][@"hardware"];
        [weakSelf getManuDate];
    } failedBlock:^(NSError *error) {
        [weakSelf getManuDate];
    }];
}

- (void)getManuDate{
    if ([MKCentralManager sharedInstance].connectState != MKEddystoneConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.manuDate)) {
        [self getManu];
        return;
    }
    WS(weakSelf);
    [MKEddystoneInterface readEddystoneProductionDateWithSucBlock:^(id returnData) {
        weakSelf.manuDate = returnData[@"result"][@"productionDate"];
        [weakSelf getManu];
    } failedBlock:^(NSError *error) {
        [weakSelf getManu];
    }];
}

- (void)getManu{
    if ([MKCentralManager sharedInstance].connectState != MKEddystoneConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.manu)) {
        if (self.sucBlock) {
            self.sucBlock(nil);
        }
        return;
    }
    WS(weakSelf);
    [MKEddystoneInterface readEddystoneVendorWithSucBlock:^(id returnData) {
        weakSelf.manu = returnData[@"result"][@"vendor"];
        if (weakSelf.sucBlock) {
            weakSelf.sucBlock(nil);
        }
    } failedBlock:^(NSError *error) {
        if (weakSelf.sucBlock) {
            weakSelf.sucBlock(nil);
        }
    }];
}

- (NSError *)errorWithMsg:(NSString *)msg{
    NSError *error = [[NSError alloc] initWithDomain:@"loadSystemInformation"
                                                code:-999
                                            userInfo:@{@"errorInfo":SafeStr(msg)}];
    return error;
}

@end
