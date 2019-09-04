//
//  MKCentralManager.h
//  EddystoneSDK
//
//  Created by aa on 2018/8/8.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MKEddystoneOperationIDDefines.h"

typedef NS_ENUM(NSInteger, MKEddystoneConnectStatus) {
    MKEddystoneConnectStatusUnknow,
    MKEddystoneConnectStatusConnecting,
    MKEddystoneConnectStatusConnected,
    MKEddystoneConnectStatusConnectedFailed,
    MKEddystoneConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, MKEddystoneCentralManagerState) {
    MKEddystoneCentralManagerStateUnable,
    MKEddystoneCentralManagerStateEnable,
};

typedef NS_ENUM(NSInteger, MKEddystoneLockState) {
    MKEddystoneLockStateUnknow,
    MKEddystoneLockStateLock,
    MKEddystoneLockStateOpen,
    MKEddystoneLockStateUnlockAutoMaticRelockDisabled,
};

typedef void(^MKConnectFailedBlock)(NSError *error);
typedef void(^MKConnectSuccessBlock)(CBPeripheral *peripheral);
typedef void(^MKConnectProgressBlock)(float progress);

@class MKCentralManager;
@class MKBaseReceiveBeacon;
@class MKEddystoneOperation;
@protocol MKEddystoneScanDelegate <NSObject>

- (void)didReceiveBeacon:(MKBaseReceiveBeacon *)beacon manager:(MKCentralManager *)manager;

@optional
- (void)centralManagerStartScan:(MKCentralManager *)manager;
- (void)centralManagerStopScan:(MKCentralManager *)manager;

@end

@protocol MKEddystoneCentralManagerDelegate <NSObject>

- (void)centralStateChanged:(MKEddystoneCentralManagerState)managerState manager:(MKCentralManager *)manager;

- (void)peripheralConnectStateChanged:(MKEddystoneConnectStatus)connectState manager:(MKCentralManager *)manager;

- (void)eddystoneLockStateChanged:(MKEddystoneLockState)lockState manager:(MKCentralManager *)manager;

@end

@interface MKCentralManager : NSObject

/**
 central
 */
@property (nonatomic, strong, readonly)CBCentralManager *centralManager;
/**
 Current connected device
 */
@property (nonatomic, strong, readonly)CBPeripheral *peripheral;
/**
 Current device’s connect state
 */
@property (nonatomic, assign, readonly)MKEddystoneConnectStatus connectState;
/**
 Current central's state
 */
@property (nonatomic, assign, readonly)MKEddystoneCentralManagerState managerState;
/**
 Current device’s LockState
 */
@property (nonatomic, assign, readonly)MKEddystoneLockState lockState;
/**
 scan delegate
 */
@property (nonatomic, weak)id <MKEddystoneScanDelegate>scanDelegate;
/**
 state delegate of central and peripheral
 */
@property (nonatomic, weak)id <MKEddystoneCentralManagerDelegate>stateDelegate;
+ (MKCentralManager *)sharedInstance;
+ (void)instanceDealloc;
/**
 start scan method
 */
- (void)startScanPeripheral;
/**
 stop scan method
 */
- (void)stopScanPeripheral;
/**
 Interface of connection

 @param peripheral peripheral
 @param password password
 @param progressBlock progress callback
 @param sucBlock Connection succeed callback
 @param failedBlock Connection failed callback
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
            progressBlock:(MKConnectProgressBlock)progressBlock
                 sucBlock:(MKConnectSuccessBlock)sucBlock
              failedBlock:(MKConnectFailedBlock)failedBlock;
/**
 disconnect
 */
- (void)disconnect;
/**
 Add a design task (app - > peripheral) to the queue
 
 @param operationID operationID
 @param commandData Communication data
 @param characteristic characteristic
 @param successBlock Communication succeed callback
 @param failureBlock Communication failed callback
 */
- (void)addTaskWithTaskID:(MKEddystoneOperationID)operationID
              commandData:(NSString *)commandData
           characteristic:(CBCharacteristic *)characteristic
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock;
/**
 Add a reading task (app - > peripheral) to the queue
 
 @param operationID operationID
 @param characteristic characteristic
 @param successBlock Communication succeed callback
 @param failureBlock Communication failed callback
 */
- (void)addReadTaskWithTaskID:(MKEddystoneOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock;
/**
 Custom operation is added to the task queue

 @param operation operation
 */
- (void)addOperation:(MKEddystoneOperation *)operation;

@end
