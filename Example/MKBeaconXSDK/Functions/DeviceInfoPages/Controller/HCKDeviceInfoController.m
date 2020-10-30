//
//  HCKDeviceInfoController.m
//  HCKEddStone
//
//  Created by aa on 2017/12/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKDeviceInfoController.h"
#import "HCKBaseTableView.h"
#import "HCKIconInfoCell.h"
#import "HCKDeviceInfoModel.h"

static NSString *const HCKDeviceInfoControllerCellIdenty = @"HCKDeviceInfoControllerCellIdenty";

@interface HCKDeviceInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)HCKBaseTableView *tableView;

@property (nonatomic, strong)HCKDeviceInfoModel *infoModel;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation HCKDeviceInfoController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKDeviceInfoController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadDatas];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadSystemInfoDatas];
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return @"Device info";
}

- (void)leftButtonMethod{
    [[NSNotificationCenter defaultCenter] postNotificationName:HCKPopToRootViewControllerNotification
                                                        object:nil];
}

#pragma mark - 代理方法

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HCKIconInfoCell getCellHeight];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCKIconInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKDeviceInfoControllerCellIdenty];
    if (!cell) {
        cell = [[HCKIconInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKDeviceInfoControllerCellIdenty];
    }
    if (indexPath.row < self.dataList.count) {
        cell.dataModel = self.dataList[indexPath.row];
    }
    return cell;
}

#pragma mark - Private method

- (void)loadSystemInfoDatas{
    [[HCKHudManager share] showHUDWithTitle:@"Loading..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [self.infoModel startLoadSystemInformation:^(id returnData) {
        //不需要解析这个returnData，直接从infoModel拿数据
        [[HCKHudManager share] hide];
        [weakSelf reloadDatas];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)reloadDatas{
    if (ValidStr(self.infoModel.battery)) {
        HCKMainCellModel *soc = self.dataList[0];
        soc.rightMsg = [self.infoModel.battery stringByAppendingString:@"%"];
    }
    if (ValidStr(self.infoModel.macAddress)) {
        HCKMainCellModel *mac = self.dataList[1];
        mac.rightMsg = self.infoModel.macAddress;
    }
    if (ValidStr(self.infoModel.produce)) {
        HCKMainCellModel *produceModel = self.dataList[2];
        produceModel.rightMsg = self.infoModel.produce;
    }
    if (ValidStr(self.infoModel.software)) {
        HCKMainCellModel *softwareModel = self.dataList[3];
        softwareModel.rightMsg = self.infoModel.software;
    }
    if (ValidStr(self.infoModel.firmware)) {
        HCKMainCellModel *firmwareModel = self.dataList[4];
        firmwareModel.rightMsg = self.infoModel.firmware;
    }
    if (ValidStr(self.infoModel.hardware)) {
        HCKMainCellModel *hardware = self.dataList[5];
        hardware.rightMsg = self.infoModel.hardware;
    }
    if (ValidStr(self.infoModel.manuDate)) {
        HCKMainCellModel *manuDateModel = self.dataList[6];
        manuDateModel.rightMsg = self.infoModel.manuDate;
    }
    if (ValidStr(self.infoModel.manu)) {
        HCKMainCellModel *manuModel = self.dataList[7];
        manuModel.rightMsg = self.infoModel.manu;
    }
    [self.tableView reloadData];
}

- (void)loadDatas{
    HCKMainCellModel *socModel = [[HCKMainCellModel alloc] init];
    socModel.leftIconName = @"device_soc";
    socModel.leftMsg = @"SOC";
    socModel.rightMsg = @"100%";
    socModel.hiddenRightIcon = YES;
    [self.dataList addObject:socModel];
    
    HCKMainCellModel *macModel = [[HCKMainCellModel alloc] init];
    macModel.leftIconName = @"device_macadress";
    macModel.leftMsg = @"Mac Address";
    macModel.rightMsg = @"CE:12:A4:32:1B:2E";
    macModel.hiddenRightIcon = YES;
    [self.dataList addObject:macModel];
    
    HCKMainCellModel *produceModel = [[HCKMainCellModel alloc] init];
    produceModel.leftIconName = @"device_productmodel";
    produceModel.leftMsg = @"Produce Model";
    produceModel.rightMsg = @"HHHH";
    produceModel.hiddenRightIcon = YES;
    [self.dataList addObject:produceModel];
    
    HCKMainCellModel *softwareModel = [[HCKMainCellModel alloc] init];
    softwareModel.leftIconName = @"device_software";
    softwareModel.leftMsg = @"Software Version";
    softwareModel.rightMsg = @"V1.0.0";
    softwareModel.hiddenRightIcon = YES;
    [self.dataList addObject:softwareModel];
    
    HCKMainCellModel *firmwareModel = [[HCKMainCellModel alloc] init];
    firmwareModel.leftIconName = @"device_firmware";
    firmwareModel.leftMsg = @"Firmware Version";
    firmwareModel.rightMsg = @"V1.0.0";
    firmwareModel.hiddenRightIcon = YES;
    [self.dataList addObject:firmwareModel];
    
    HCKMainCellModel *hardwareModel = [[HCKMainCellModel alloc] init];
    hardwareModel.leftIconName = @"device_hardware";
    hardwareModel.leftMsg = @"Hardware Version";
    hardwareModel.rightMsg = @"V1.0.0";
    hardwareModel.hiddenRightIcon = YES;
    [self.dataList addObject:hardwareModel];
    
    HCKMainCellModel *manuDateModel = [[HCKMainCellModel alloc] init];
    manuDateModel.leftIconName = @"device_runningtime";
    manuDateModel.leftMsg = @"Manufacture Date";
    manuDateModel.rightMsg = @"1d2h3m15s";
    manuDateModel.hiddenRightIcon = YES;
    [self.dataList addObject:manuDateModel];
    
    HCKMainCellModel *manuModel = [[HCKMainCellModel alloc] init];
    manuModel.leftIconName = @"device_manufacture";
    manuModel.leftMsg = @"Manufacture";
    manuModel.rightMsg = @"LTD";
    manuModel.hiddenRightIcon = YES;
    [self.dataList addObject:manuModel];
    
    [self.tableView reloadData];
}

- (void)loadSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-49.f);
    }];
}

#pragma mark - setter & getter

- (HCKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[HCKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (HCKDeviceInfoModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [HCKDeviceInfoModel new];
    }
    return _infoModel;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
