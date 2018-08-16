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
    MKEddystoneConnectStatusUnknow,                                           //未知状态
    MKEddystoneConnectStatusConnecting,                                       //正在连接
    MKEddystoneConnectStatusConnected,                                        //连接成功
    MKEddystoneConnectStatusConnectedFailed,                                  //连接失败
    MKEddystoneConnectStatusDisconnect,                                       //连接断开
};

typedef NS_ENUM(NSInteger, MKEddystoneCentralManagerState) {
    MKEddystoneCentralManagerStateUnable,                           //不可用
    MKEddystoneCentralManagerStateEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, MKEddystoneLockState) {
    MKEddystoneLockStateUnknow,      //未知状态
    MKEddystoneLockStateLock,        //锁定状态
    MKEddystoneLockStateOpen,        //解锁状态
    MKEddystoneLockStateUnlockAutoMaticRelockDisabled, //解锁，验证了正确的密码并且禁止了Eddystone设备自动锁定功能
};

/**
 中心设备连接外设失败的Block
 
 @param error 错误信息
 */
typedef void(^MKConnectFailedBlock)(NSError *error);

/**
 连接设备成功Block
 
 @param peripheral 已连接的外设
 */
typedef void(^MKConnectSuccessBlock)(CBPeripheral *peripheral);

/**
 连接设备当前进度的回调
 
 @param progress 当前进度
 */
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

/**
 中心蓝牙状态改变
 
 @param managerState 中心蓝牙状态
 @param manager 中心
 */
- (void)centralStateChanged:(MKEddystoneCentralManagerState)managerState manager:(MKCentralManager *)manager;

/**
 中心与外设连接状态改变
 
 @param connectState 外设连接状态
 @param manager 中心
 */
- (void)peripheralConnectStateChanged:(MKEddystoneConnectStatus)connectState manager:(MKCentralManager *)manager;

/**
 外设lockState改变

 @param lockState lockState
 @param manager manager
 */
- (void)eddystoneLockStateChanged:(MKEddystoneLockState)lockState manager:(MKCentralManager *)manager;

@end

@interface MKCentralManager : NSObject

@property (nonatomic, strong, readonly)CBCentralManager *centralManager;

@property (nonatomic, strong, readonly)CBPeripheral *peripheral;

@property (nonatomic, assign, readonly)MKEddystoneConnectStatus connectState;

@property (nonatomic, assign, readonly)MKEddystoneCentralManagerState managerState;

@property (nonatomic, assign, readonly)MKEddystoneLockState lockState;

@property (nonatomic, weak)id <MKEddystoneScanDelegate>scanDelegate;

@property (nonatomic, weak)id <MKEddystoneCentralManagerDelegate>stateDelegate;

+ (MKCentralManager *)sharedInstance;

- (void)startScanPeripheral;
- (void)stopScanPeripheral;

/**
 连接指定设备

 @param peripheral peripheral
 @param password password
 @param progressBlock 连接进度
 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
            progressBlock:(MKConnectProgressBlock)progressBlock
                 sucBlock:(MKConnectSuccessBlock)sucBlock
              failedBlock:(MKConnectFailedBlock)failedBlock;

/**
 断开连接
 */
- (void)disconnect;
/**
 添加一个设置任务(app-->peripheral)到队列
 
 @param operationID 任务ID
 @param commandData 通信数据
 @param characteristic 通信所使用的特征
 @param successBlock 通信成功回调
 @param failureBlock 通信失败回调
 */
- (void)addTaskWithTaskID:(MKEddystoneOperationID)operationID
              commandData:(NSString *)commandData
           characteristic:(CBCharacteristic *)characteristic
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock;
/**
 添加一个读取任务(app-->peripheral)到队列
 
 @param operationID 任务ID
 @param characteristic 通信所使用的特征
 @param successBlock 通信成功回调
 @param failureBlock 通信失败回调
 */
- (void)addReadTaskWithTaskID:(MKEddystoneOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock;

/**
 自定义的operation添加到任务队列

 @param operation 任务
 */
- (void)addOperation:(MKEddystoneOperation *)operation;

@end
