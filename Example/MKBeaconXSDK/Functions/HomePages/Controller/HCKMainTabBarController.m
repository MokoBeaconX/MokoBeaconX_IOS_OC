//
//  HCKMainTabBarController.m
//  HCKEddStone
//
//  Created by aa on 2017/12/6.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKMainTabBarController.h"
#import "HCKSlotController.h"
#import "HCKSettingController.h"
#import "HCKDeviceInfoController.h"

NSString *const peripheralIdenty = @"peripheralIdenty";
NSString *const passwordIdenty = @"passwordIdenty";

@interface HCKMainTabBarController ()

@property (nonatomic, strong)UINavigationController *optionsVC;

@property (nonatomic, strong)UINavigationController *settingVC;

@property (nonatomic, strong)UINavigationController *deviceInfoVC;

@property (nonatomic, assign)BOOL modifyPassword;

@property (nonatomic, assign)BOOL isShow;

@end

@implementation HCKMainTabBarController

#pragma mark - life circle

- (void)dealloc{
    NSLog(@"HCKMainTabBarController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:HCKPopToRootViewControllerNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:HCKEddStoneModifyPasswordSuccessNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MKCentralManagerStateChangedNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MKPeripheralLockStateChangedNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MKPeripheralConnectStateChangedNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:HCKEddystonePowerOffNotification
                                                  object:nil];
    [HCKDataManager share].password = @"";
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if (![[self.navigationController viewControllers] containsObject:self]){
        self.isShow = NO;
        [[MKCentralManager sharedInstance] disconnect];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShow = YES;
    [self statusMonitoring];
    // Do any additional setup after loading the view.
}

#pragma mark - Notification event
- (void)centralManagerStateChanged{
    if (!self.isShow) {
        return;
    }
    if ([MKCentralManager sharedInstance].managerState != MKEddystoneCentralManagerStateEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!"];
    }
}

- (void)peripheralLockStateChanged{
    if (!self.isShow) {
        return;
    }
    if ([MKCentralManager sharedInstance].lockState != MKEddystoneLockStateOpen
        && [MKCentralManager sharedInstance].lockState != MKEddystoneLockStateUnlockAutoMaticRelockDisabled
        && [MKCentralManager sharedInstance].connectState == MKEddystoneConnectStatusConnected) {
        [self performSelector:@selector(showLockStateAlert)
                       withObject:nil
                       afterDelay:0.1f];
    }
}

- (void)peripheralConnectStateChanged{
    if (!self.isShow) {
        return;
    }
    if ([MKCentralManager sharedInstance].connectState == MKEddystoneConnectStatusDisconnect
        && [MKCentralManager sharedInstance].managerState == MKEddystoneCentralManagerStateEnable) {
        [self disconnectAlert];
    }
}

- (void)gotoRootViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)devicePowerOff{
    self.isShow = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 修改密码成功之后，锁定状态发生改变，弹窗提示修改密码成功
 */
- (void)modifyPasswordSuccess{
    self.modifyPassword = YES;
}

#pragma mark - Private method

- (void)statusMonitoring{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoRootViewController) name:HCKPopToRootViewControllerNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modifyPasswordSuccess)
                                                 name:HCKEddStoneModifyPasswordSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centralManagerStateChanged)
                                                 name:MKCentralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peripheralLockStateChanged)
                                                 name:MKPeripheralLockStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peripheralConnectStateChanged)
                                                 name:MKPeripheralConnectStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(devicePowerOff)
                                                 name:HCKEddystonePowerOffNotification
                                               object:nil];
    [self loadChildVCS];
}

- (void)showLockStateAlert{
    NSString *msg = (self.modifyPassword ? @"Password modified successfully! Reconnecting the device" : @"The device is locked!");
    [self showAlertWithMsg:msg];
}

/**
 当前手机蓝牙不可用、锁定状态改为不可用的时候，提示弹窗

 @param msg 弹窗显示的内容
 */
- (void)showAlertWithMsg:(NSString *)msg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf gotoRootViewController];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

/**
 eddStone设备的连接状态发生改变提示弹窗
 */
- (void)disconnectAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                             message:@"The device is disconnected"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoRootViewController];
    }];
    [alertController addAction:exitAction];
    
    UIAlertAction *connectAction = [UIAlertAction actionWithTitle:@"Reconnect" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reconnectDevice];
    }];
    [alertController addAction:connectAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)reconnectDevice{
    [[HCKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [[MKCentralManager sharedInstance] connectPeripheral:self.params[peripheralIdenty] password:self.params[passwordIdenty] progressBlock:^(float progress) {
        
    } sucBlock:^(CBPeripheral *peripheral) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Connect Success"];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadChildVCS{
    self.viewControllers = @[self.optionsVC,self.settingVC,self.deviceInfoVC];
}

#pragma mark - setter & getter
- (UINavigationController *)optionsVC{
    if (!_optionsVC) {
        HCKSlotController *vc = [[HCKSlotController alloc] initWithNavigationType:GYNaviTypeShow];
        vc.tabBarItem.title = @"SLOT";
        vc.tabBarItem.image = LOADIMAGE(@"slotTabBarItemUnselected", @"png");
        vc.tabBarItem.selectedImage = LOADIMAGE(@"slotTabBarItemSelected", @"png");
        _optionsVC = [[UINavigationController alloc] initWithRootViewController:vc];
        
    }
    return _optionsVC;
}

- (UINavigationController *)settingVC{
    if (!_settingVC) {
        HCKSettingController *vc = [[HCKSettingController alloc] initWithNavigationType:GYNaviTypeShow];
        vc.tabBarItem.title = @"SETTING";
        vc.tabBarItem.image = LOADIMAGE(@"settingTabBarItemUnselected", @"png");
        vc.tabBarItem.selectedImage = LOADIMAGE(@"settingTabBarItemSelected", @"png");
        _settingVC = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    return _settingVC;
}

- (UINavigationController *)deviceInfoVC{
    if (!_deviceInfoVC) {
        HCKDeviceInfoController *vc = [[HCKDeviceInfoController alloc] initWithNavigationType:GYNaviTypeShow];
        vc.tabBarItem.title = @"DEVICE";
        vc.tabBarItem.image = LOADIMAGE(@"deviceTabBarItemUnselected", @"png");
        vc.tabBarItem.selectedImage = LOADIMAGE(@"deviceTabBarItemSelected", @"png");
        _deviceInfoVC = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    return _deviceInfoVC;
}

@end
