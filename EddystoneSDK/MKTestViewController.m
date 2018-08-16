//
//  MKTestViewController.m
//  EddystoneSDK
//
//  Created by aa on 2018/8/10.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKTestViewController.h"
#import "HCKBaseTableView.h"

@interface MKTestViewController ()<UITableViewDelegate,UITableViewDataSource,MKEddystoneCentralManagerDelegate>

@property (nonatomic, strong)HCKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKTestViewController

- (void)dealloc{
    NSLog(@"销毁");
    [[MKCentralManager sharedInstance] disconnect];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self loadDatas];
    [MKCentralManager sharedInstance].stateDelegate = self;
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //activeSlot
        [MKEddystoneInterface readEddystoneActiveSlotWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 1){
        //set activeSlot
        [MKEddystoneInterface setEddystoneActiveSlot:eddystoneActiveSlot3 sucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 2){
        //advertisingInterval
        [MKEddystoneInterface readEddystoneAdvertisingIntervalWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 3){
        //set advertisingInterval
        [MKEddystoneInterface setEddystoneAdvertingInterval:2000 sucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 4){
        //radioTxPower
        [MKEddystoneInterface readEddystoneRadioTxPowerWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 5){
        //set radioTxPower
        [MKEddystoneInterface setEddystoneRadioTxPower:slotRadioTxPowerNeg8dBm sucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 6){
        //AdvTxPower
        [MKEddystoneInterface readEddystoneAdvTxPowerWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 7){
        //set AdvTxPower
        [MKEddystoneInterface setEddystoneAdvTxPower:-58 sucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 8){
        //password
        [MKEddystoneInterface setEddystoneNewPassword:@"Moko4321" originalPassword:@"Moko4321" sucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 9){
        //advData
        [MKEddystoneInterface readEddystoneAdvDataWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 10){
        //Mac Address
        [MKEddystoneInterface readEddystoneMacAddressWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 11){
        //slot type
        [MKEddystoneInterface readEddystoneSlotDataTypeWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 12){
        //DeviceName
        [MKEddystoneInterface readEddystoneDeviceNameWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 13){
        //ConnectEnable
        [MKEddystoneInterface readEddystoneConnectEnableStatusWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 14){
        //iBeacon Adv Data
        [MKEddystoneInterface readEddystoneiBeaconAdvDataWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 15){
        //set url
        [MKEddystoneInterface setURLEddystoneAdvData:urlHeaderType1 urlContent:@"baidu.com" sucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 16){
        //set uid
        [MKEddystoneInterface setUIDEddystoneAdvDataWithNameSpace:@"01020304050607080910" instanceID:@"666666666666" sucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 17){
        //set iBeacon Data
        [MKEddystoneInterface setiBeaconEddystoneAdvDataWithMajor:111 minor:111 uuid:@"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa" measurePower:20 sucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 18){
        //vendor
        [MKEddystoneInterface readEddystoneVendorWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 19){
        //modeID
        [MKEddystoneInterface readEddystoneModeIDWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 20){
        //ProductionDate
        [MKEddystoneInterface readEddystoneProductionDateWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 21){
        //hardware
        [MKEddystoneInterface readEddystoneHardwareWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 22){
        //firmware
        [MKEddystoneInterface readEddystoneFirmwareWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 23){
        //software
        [MKEddystoneInterface readEddystoneSoftwareWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }else if (indexPath.row == 24){
        //battery
        [MKEddystoneInterface readEddystoneBatteryWithSucBlock:^(id returnData) {
            NSLog(@"success-%@",returnData);
        } failedBlock:^(NSError *error) {
            NSLog(@"error-%@",error);
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKTestViewControllerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKTestViewControllerCell"];
    }
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - MKEddystoneCentralManagerDelegate
- (void)eddystoneLockStateChanged:(MKEddystoneLockState)lockState manager:(MKCentralManager *)manager{
    
}

- (void)centralStateChanged:(MKEddystoneCentralManagerState)managerState manager:(MKCentralManager *)manager{
    
}

- (void)peripheralConnectStateChanged:(MKEddystoneConnectStatus)connectState manager:(MKCentralManager *)manager{
    NSLog(@"连接状态发生改变:%@",@(connectState));
}

#pragma mark -
- (void)loadDatas{
    [self.dataList addObject:@"activeSlot"];
    [self.dataList addObject:@"set activeSlot"];
    [self.dataList addObject:@"advertisingInterval"];
    [self.dataList addObject:@"set advertisingInterval"];
    [self.dataList addObject:@"radioTxPower"];
    [self.dataList addObject:@"set radioTxPower"];
    [self.dataList addObject:@"advTxPower"];
    [self.dataList addObject:@"set advTxPower"];
    [self.dataList addObject:@"set password"];
    [self.dataList addObject:@"advData"];
    [self.dataList addObject:@"mac Address"];
    [self.dataList addObject:@"slot type"];
    [self.dataList addObject:@"Device Name"];
    [self.dataList addObject:@"Connect Enable"];
    [self.dataList addObject:@"iBeacon Adv Data"];
    [self.dataList addObject:@"set URL"];
    [self.dataList addObject:@"set UID"];
    [self.dataList addObject:@"set iBeacon Data"];
    [self.dataList addObject:@"vendor"];
    [self.dataList addObject:@"modelID"];
    [self.dataList addObject:@"production Date"];
    [self.dataList addObject:@"hardware"];
    [self.dataList addObject:@"firmware"];
    [self.dataList addObject:@"software"];
    [self.dataList addObject:@"battery"];
    [self.tableView reloadData];
}

- (HCKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[HCKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
