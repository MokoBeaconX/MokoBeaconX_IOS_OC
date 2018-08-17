# mokoBeaconX_iOS
工程引入头文件
#import "MKEddystoneSDK.h"
#### 1.Scan
```
//delegate
[MKCentralManager sharedInstance].scanDelegate = self;

//scan
[[MKCentralManager sharedInstance] startScanPeripheral];

/*

@protocol MKEddystoneScanDelegate <NSObject>

- (void)didReceiveBeacon:(MKBaseReceiveBeacon *)beacon manager:(MKCentralManager *)manager;

@optional
- (void)centralManagerStartScan:(MKCentralManager *)manager;
- (void)centralManagerStopScan:(MKCentralManager *)manager;

@end
*/

```

#### 2.连接设备

##### 2.1 中心蓝牙状态改变和外设连接状态改变
```
[MKCentralManager sharedInstance].stateDelegate = self;

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
```

##### 2.2连接指定设备

```
[[MKCentralManager sharedInstance] connectPeripheral:peripheral password:password progressBlock:^(float progress) {
        //connect progress
    } sucBlock:^(CBPeripheral *peripheral) {
        //connect success block
    } failedBlock:^(NSError *error) {
        //connect failed block
    }];
```

#### 3.数据接口调用
MKEddystoneInterface包含了所有的数据接口部分，所有接口采用block形式回调。注意，在设置和读取数据的时候，需要将当前通道切换到目标通道，否则操作的为当前默认的活跃通道。当前通道为iBeacon的时候，读取通道广播信息用readEddystoneiBeaconAdvDataWithSucBlock:failedBlock:方法，非iBeacon读取通道广播信息用readEddystoneAdvDataWithSucBlock:failedBlock:方法.



