typedef NS_ENUM(NSInteger, MKEddystoneOperationID) {
    MKEddystoneOperationDefaultID,
    MKEddystoneReadVendorOperation,                     //读取厂商信息
    MKEddystoneReadModeIDOperation,                     //读取产品型号信息
    MKEddystoneReadProductionDateOperation,             //读取生产日期
    MKEddystoneReadHardwareOperation,                   //读取硬件信息
    MKEddystoneReadFirmwareOperation,                   //读取固件信息
    MKEddystoneReadSoftwareOperation,                   //读取软件版本
    MKEddystoneReadCapabilitiesOperation,               //获取capabilities数据
    MKEddystoneReadActiveSlotOperation,                 //获取activeSlot数据
    MKEddystoneReadAdvertisingIntervalOperation,        //获取广播间隔
    MKEddystoneReadRadioTxPowerOperation,               //获取发射功率
    MKEddystoneReadAdvTxPowerOperation,                 //获取广播功率
    MKEddystoneReadLockStateOperation,                  //获取eddystone的lock状态
    MKEddystoneReadUnlockOperation,
    MKEddystoneReadPublicECDHKeyOperation,
    MKEddystoneReadEidIdentityKeyOperation,
    MKEddystoneReadAdvSlotDataOperation,
    MKEddystoneSetActiveSlotOperation,                 //设置activeSlot数据
    MKEddystoneSetAdvertisingIntervalOperation,        //设置广播间隔
    MKEddystoneSetRadioTxPowerOperation,               //设置发射功率
    MKEddystoneSetAdvTxPowerOperation,                 //设置广播功率
    MKEddystoneSetLockStateOperation,                  //设置eddystone的lock状态
    MKEddystoneSetUnlockOperation,
    MKEddystoneSetPublicECDHKeyOperation,
    MKEddystoneSetEidIdentityKeyOperation,
    MKEddystoneSetAdvSlotDataOperation,
    MKEddystoneSetFactoryResetOperation,
    MKEddystoneReadMacAddressOperation,                   //获取eddystone的mac地址
    MKEddystoneReadSlotTypeOperation,                     //获取eddystone的通道类型
    MKEddystoneReadiBeaconDataOperation,                  //获取eddystone的iBeacon主值次值和发射功率
    MKEddystoneReadiBeaconUUIDOperation,                  //获取eddystone的iBeacon UUID
    MKEddystoneReadDeviceNameOperation,                   //获取eddystone的设备名字
    MKEddystoneReadConnectEnableOperation,                //获取eddystone的可连接状态
    MKEddystoneSetMajorOperation,                         //设置iBeacon的主值iBeaconMajor
    MKEddystoneSetMinorOperation,                         //设置iBeacon的次值
    MKEddystoneSetiBeaconDataOperation,                   //设置eddystone的iBeacon主值次值和发射功率
    MKEddystoneSetiBeaconUUIDOperation,                //设置eddystone的iBeacon UUID
    MKEddystoneSetDeviceNameOperation,                 //设置eddystone的设备名字
    MKEddystoneSetConnectEnableOperation,              //设置eddystone的可连接状态
    MKEddystoneSetPowerOffOperation,                    //关机命令
    MKEddystoneReadBatteryOperation,                      //读取battery
};
