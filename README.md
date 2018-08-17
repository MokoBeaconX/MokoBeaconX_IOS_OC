# MokoBeaconX_iOS
 
## support pod, pod 'beaconXSDK', '~> 0.0.1'

## Import header file

### import "MKEddystoneSDK.h"
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

#### 2.Connect to the device
 
##### 2.1  Central Bluetooth status change and Peripheral connection status change
```
[MKCentralManager sharedInstance].stateDelegate = self;

@protocol MKEddystoneCentralManagerDelegate <NSObject>

/**
 Central Bluetooth status change
 
 @param managerState   //Central Bluetooth statue
 @param manager  //Central
 */
- (void)centralStateChanged:(MKEddystoneCentralManagerState)managerState manager:(MKCentralManager *)manager;

/**
 Central and Peripheral connection status change
 
 @param connectState //Peripheral connection status
 @param manager //Central
 */
- (void)peripheralConnectStateChanged:(MKEddystoneConnectStatus)connectState manager:(MKCentralManager *)manager;

/**
 Peripheral LockState changes

 @param lockState lockState
 @param manager manager
 */
- (void)eddystoneLockStateChanged:(MKEddystoneLockState)lockState manager:(MKCentralManager *)manager;

@end
```

##### 2.2 Connect to the specified device

```
[[MKCentralManager sharedInstance] connectPeripheral:peripheral password:password progressBlock:^(float progress) {
        //connect progress
    } sucBlock:^(CBPeripheral *peripheral) {
        //connect success block
    } failedBlock:^(NSError *error) {
        //connect failed block
    }];
```

#### 3. Call data interface
 
**MKEddystoneInterface** contains all data interface sections, and all interfaces are callback in "block" form. Please pay attention, when setting and reading data, you need to switch the current SLOT to the target SLOT, otherwise the current active SLOT is operated. When the current SLOT type is **iBeacon**，use **readEddystoneiBeaconAdvDataWithSucBlock:failedBlock:** method to read the SLOT date. When the current SLOT type is **Non-iBeacon(URL/TLM/UID)**, use **readEddystoneAdvDataWithSucBlock:failedBlock:** method to read the SLOT date.



