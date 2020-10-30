//
//  HCKSettingController.m
//  HCKEddStone
//
//  Created by aa on 2017/12/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSettingController.h"
#import "HCKBaseTableView.h"
#import "HCKIconInfoCell.h"
#import "HCKConnectableCell.h"

static NSString *const HCKSettingControllerCellIdenty = @"HCKSettingControllerCellIdenty";

@interface HCKSettingController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)HCKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

/**
 修改名字的输入框
 */
@property (nonatomic, strong)UITextField *nameTextField;

@property (nonatomic, strong)UITextField *passwordTextField;

@property (nonatomic, strong)UITextField *confirmTextField;

@end

@implementation HCKSettingController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKSettingController销毁");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getConnectable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadDatas];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return @"Setting";
}

- (void)leftButtonMethod{
    [[NSNotificationCenter defaultCenter] postNotificationName:HCKPopToRootViewControllerNotification
                                                        object:nil];
}

#pragma mark - Private method

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
    if (indexPath.row < self.dataList.count - 2) {
        HCKIconInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HCKSettingControllerCellIdenty];
        if (!cell) {
            cell = [[HCKIconInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HCKSettingControllerCellIdenty];
        }
        if (indexPath.row < self.dataList.count) {
            cell.dataModel = self.dataList[indexPath.row];
        }
        
        return cell;
    }
    //最后一个cell带开关
    HCKConnectableCell *cell = [HCKConnectableCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    if (indexPath.row == self.dataList.count - 1) {
        cell.isOn = YES;
    }
    WS(weakSelf);
    cell.connectStatusChangedBlock = ^(BOOL connectable) {
        if (indexPath.row == weakSelf.dataList.count - 2) {
            //设置可连接状态
            [weakSelf setConnectEnable:connectable];
            return ;
        }
        //开关机
        [weakSelf powerOff];
    };
    return cell;
}

#pragma mark - Private method

- (void)getConnectable{
    WS(weakSelf);
    [[HCKHudManager share] showHUDWithTitle:@"Reading..."
                                     inView:self.view
                              isPenetration:NO];
    [MKEddystoneInterface readEddystoneConnectEnableStatusWithSucBlock:^(id returnData) {
        [weakSelf setCellSwitchStatus:[returnData[@"result"][@"connectEnable"] boolValue] row:weakSelf.dataList.count - 2];
        [weakSelf getDeviceName];
    } failedBlock:^(NSError *error) {
        [weakSelf getDeviceName];
    }];
}

- (void)getDeviceName{
    WS(weakSelf);
    [[HCKHudManager share] showHUDWithTitle:@"Reading..."
                                     inView:self.view
                              isPenetration:NO];
    [MKEddystoneInterface readEddystoneDeviceNameWithSucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        HCKMainCellModel *model = weakSelf.dataList[0];
        model.rightMsg = returnData[@"result"][@"deviceName"];
        [weakSelf.tableView reloadData];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设备名称设置

- (void)setEddStoneName{
    WS(weakSelf);
    NSString *msg = @"Tips:The length of device name should be 1-8 characters.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Device Name"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.nameTextField = nil;
        weakSelf.nameTextField = textField;
        [weakSelf.nameTextField setPlaceholder:@"Device Name"];
        [weakSelf.nameTextField addTarget:self
                                   action:@selector(deviceNameChanged)
                         forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!ValidStr(weakSelf.nameTextField.text)) {
            [weakSelf.view showCentralToast:@"Device name can not be nil"];
            return ;
        }
        if (weakSelf.nameTextField.text.length > 8) {
            [weakSelf.view showCentralToast:@"The device name a maximum length of eight characters"];
            return ;
        }
        [weakSelf setDeviceNameToEddStone:weakSelf.nameTextField.text];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)deviceNameChanged{
    NSString *tempInputString = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!ValidStr(tempInputString)) {
        self.nameTextField.text = @"";
        return;
    }
    self.nameTextField.text = (tempInputString.length > 8 ? [tempInputString substringToIndex:8] : tempInputString);
}

- (void)setDeviceNameToEddStone:(NSString *)newDeviceName{
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKEddystoneInterface setEddystoneDeviceName:newDeviceName sucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [weakSelf getDeviceName];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设置密码
- (void)setPassword{
    WS(weakSelf);
    NSString *msg = @"Note:The password length should be 8 characters,and only letters and numbers can be entered.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Modify Password"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.passwordTextField = nil;
        weakSelf.passwordTextField = textField;
        [weakSelf.passwordTextField setPlaceholder:@"New password"];
        [weakSelf.passwordTextField addTarget:self
                                       action:@selector(passwordTextFieldValueChanged:)
                             forControlEvents:UIControlEventEditingChanged];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.confirmTextField = nil;
        weakSelf.confirmTextField = textField;
        [weakSelf.confirmTextField setPlaceholder:@"Confirm new password"];
        [weakSelf.confirmTextField addTarget:self
                                      action:@selector(passwordTextFieldValueChanged:)
                            forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setPasswordToDevice];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)passwordTextFieldValueChanged:(UITextField *)textField{
    NSString *tempInputString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!ValidStr(tempInputString)) {
        textField.text = @"";
        return;
    }
    NSString *newInput = [tempInputString substringWithRange:NSMakeRange(tempInputString.length - 1, 1)];
    //只能是字母、数字
    BOOL correct = [newInput isLetterOrRealNumbers];
    NSString *sourceString = (correct ? tempInputString : [tempInputString substringWithRange:NSMakeRange(0, tempInputString.length - 1)]);
    textField.text = (sourceString.length > 8 ? [sourceString substringToIndex:8] : sourceString);
}

- (void)setPasswordToDevice{
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *confirmpassword = [self.confirmTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!ValidStr(password) || !ValidStr(confirmpassword) || password.length != 8 || confirmpassword.length != 8) {
        [self.view showCentralToast:@"Length should be 8 bits."];
        return;
    }
    if (![password isEqualToString:confirmpassword]) {
        [self.view showCentralToast:@"The two passwords differ."];
        return;
    }
    WS(weakSelf);
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKEddystoneInterface setEddystoneNewPassword:password originalPassword:[HCKDataManager share].password sucBlock:^(id returnData) {
        //修改密码成功之后，eddStone的锁定状态发生改变，需要区分锁定状态是由于修改密码引起的
        [[HCKHudManager share] hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:HCKEddStoneModifyPasswordSuccessNotification
                                                            object:nil];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 恢复出厂设置

- (void)factoryReset{
    NSString *msg = @"Are you sure to reset the device?";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    WS(weakSelf);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf sendResetCommandToDevice];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)sendResetCommandToDevice{
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKEddystoneInterface eddystoneFactoryDataResetWithSucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Reset successfully!"];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设置可连接状态
- (void)setConnectEnable:(BOOL)connect{
    NSString *msg = (connect ? @"Are you sure to make device connectable?" : @"Are you sure to make device disconnectable?");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setCellSwitchStatus:!connect row:weakSelf.dataList.count - 2];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setConnectStatusToDevice:connect];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)setConnectStatusToDevice:(BOOL)connect{
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKEddystoneInterface setEddystoneConnectStatus:connect sucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        [weakSelf setCellSwitchStatus:!connect row:weakSelf.dataList.count - 2];
    }];
}

- (void)setCellSwitchStatus:(BOOL)isOn row:(NSInteger)row{
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
    HCKConnectableCell *cell = [self.tableView cellForRowAtIndexPath:path];
    if (!cell || ![cell isKindOfClass:[HCKConnectableCell class]]) {
        return;
    }
    cell.isOn = isOn;
}

#pragma mark - 开关机
- (void)powerOff{
    NSString *msg = @"Are you sure to turn off the BeaconX? Please make sure the device has a button to turn on!";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setCellSwitchStatus:YES row:weakSelf.dataList.count - 1];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf commandPowerOff];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)commandPowerOff{
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKEddystoneInterface setEddystonePowerOffWithSucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
//        [weakSelf.view showCentralToast:@"Success!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:HCKEddystonePowerOffNotification object:nil];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        [weakSelf setCellSwitchStatus:YES row:weakSelf.dataList.count - 1];
    }];
}

- (void)loadDatas{
    WS(weakSelf);
    HCKMainCellModel *nameModel = [[HCKMainCellModel alloc] init];
    nameModel.leftIconName = @"setting_devicename";
    nameModel.leftMsg = @"Device Name";
    nameModel.rightMsg = @"MokoBeacon0001";
    nameModel.clickEnable = YES;
    nameModel.destVC = NSClassFromString(@"");
    nameModel.iconInfoCellSelectedBlock = ^(NSIndexPath *pata) {
        [weakSelf setEddStoneName];
    };
    [self.dataList addObject:nameModel];
    
    HCKMainCellModel *passwordModel = [[HCKMainCellModel alloc] init];
    passwordModel.leftIconName = @"setting_password";
    passwordModel.leftMsg = @"Modify Password";
    passwordModel.clickEnable = YES;
    passwordModel.destVC = NSClassFromString(@"");
    passwordModel.iconInfoCellSelectedBlock = ^(NSIndexPath *pata) {
        [weakSelf setPassword];
    };
    [self.dataList addObject:passwordModel];
    
    HCKMainCellModel *resetModel = [[HCKMainCellModel alloc] init];
    resetModel.leftIconName = @"setting_reset";
    resetModel.leftMsg = @"Reset Factory";
    resetModel.clickEnable = YES;
    resetModel.destVC = NSClassFromString(@"");
    resetModel.iconInfoCellSelectedBlock = ^(NSIndexPath *pata) {
      [weakSelf factoryReset];
    };
    [self.dataList addObject:resetModel];
    
    HCKMainCellModel *connectModel = [[HCKMainCellModel alloc] init];
    connectModel.leftIconName = @"setting_connectable";
    connectModel.leftMsg = @"Connectable";
    connectModel.clickEnable = YES;
    connectModel.destVC = NSClassFromString(@"");
    [self.dataList addObject:connectModel];
    
    HCKMainCellModel *powerOffModel = [[HCKMainCellModel alloc] init];
    powerOffModel.leftIconName = @"setting_powerOff";
    powerOffModel.leftMsg = @"Power Off";
    powerOffModel.clickEnable = YES;
    powerOffModel.destVC = NSClassFromString(@"");
    [self.dataList addObject:powerOffModel];
    
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

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
