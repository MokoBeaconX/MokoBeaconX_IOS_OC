
#pragma mark - 服务及特征定义

#pragma mark - 扫描服务
/**
 * Eddystones Bluetooth Service ID.
 */
static NSString *const MKEddystoneServiceID = @"FEAA";

/**
 * Peripheral Information Bluetooth Service ID.
 */
static NSString *const MKPeripheralServiceID = @"FF10";

/**
 * iBeacon Bluetooth Service ID.
 */
static NSString *const MKiBeaconServiceID = @"FF20";

#pragma mark - ************************eddyStone配置服务***********************************
static NSString *const eddyStoneConfigServiceUUID = @"A3C87500-8ED3-4BDF-8A39-A01BEBEDE295";

/**************************eddyStone配置服务下面的特征***************************************/

static NSString *const capabilitiesUUID = @"a3c87501-8ed3-4bdf-8a39-a01bebede295";
static NSString *const activeSlotUUID = @"a3c87502-8ed3-4bdf-8a39-a01bebede295";
static NSString *const advertisingIntervalUUID = @"a3c87503-8ed3-4bdf-8a39-a01bebede295";
static NSString *const radioTxPowerUUID = @"a3c87504-8ed3-4bdf-8a39-a01bebede295";
static NSString *const advertisedTxPowerUUID = @"a3c87505-8ed3-4bdf-8a39-a01bebede295";
static NSString *const lockStateUUID = @"a3c87506-8ed3-4bdf-8a39-a01bebede295";
static NSString *const unlockUUID = @"a3c87507-8ed3-4bdf-8a39-a01bebede295";
static NSString *const publicECDHKeyUUID = @"a3c87508-8ed3-4bdf-8a39-a01bebede295";
static NSString *const eidIdentityKeyUUID = @"a3c87509-8ed3-4bdf-8a39-a01bebede295";
static NSString *const advSlotDataUUID = @"a3c8750a-8ed3-4bdf-8a39-a01bebede295";
static NSString *const factoryResetUUID = @"a3c8750b-8ed3-4bdf-8a39-a01bebede295";
static NSString *const remainConnectableUUID = @"a3c8750c-8ed3-4bdf-8a39-a01bebede295";

#pragma mark - ************************厂商信息服务****************************************
static NSString *const deviceInfoServiceUUID = @"180A";

/**************************厂商信息服务下面的特征********************************************/

static NSString *const systemIDUUID = @"2A23";
static NSString *const modeIDUUID = @"2A24";
static NSString *const productionDateUUID = @"2A25";
static NSString *const firmwareUUID = @"2A26";
static NSString *const hardwareUUID = @"2A27";
static NSString *const softwareUUID = @"2A28";
static NSString *const vendorUUID = @"2A29";
static NSString *const IEEEInfoUUID = @"2A2A";

#pragma mark - ************************iBeacon通用配置服务*********************************
static NSString *const iBeaconConfigServiceUUID = @"E62A0001-1362-4F28-9327-F5B74E970801";

/*************************iBeacon通用配置服务下面的特征**************************************/

static NSString *const iBeaconWriteUUID = @"E62A0002-1362-4F28-9327-F5B74E970801";
static NSString *const iBeaconNotifyUUID = @"E62A0003-1362-4F28-9327-F5B74E970801";

#pragma mark - ************************dfu升级服务*****************************************
static NSString *const dfuServiceUUID = @"00001530-1212-EFDE-1523-785FEABCD123";

/*************************dfu升级服务下面的特征*********************************************/

static NSString *dfuCBCharacteristicUUID = @"8EC90003-F315-4F60-9FB8-838830DAEA50";

#pragma mark - ***************************电池服务******************************************
static NSString *const batteryServiceUUID = @"180F";

/************************电池服务下面的特征***********************************************/
static NSString *const batteryCBCharacteristicUUID = @"2A19";


