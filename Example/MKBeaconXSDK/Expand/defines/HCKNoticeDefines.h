
//从配置页面点击左上角返回rootViewController的通知
static NSString *const HCKPopToRootViewControllerNotification = @"HCKPopToRootViewControllerNotification";

//修改密码成功通知
static NSString *const HCKEddStoneModifyPasswordSuccessNotification = @"HCKEddStoneModifyPasswordSuccessNotification";

//dfu升级之后会把SDK里面的中心销毁，这个时候需要重新设置代理
static NSString *const HCKCentralDeallocNotification = @"HCKCentralDeallocNotification";

//关机之后抛出的通知，主页面回到扫描页面
static NSString *const HCKEddystonePowerOffNotification = @"HCKEddystonePowerOffNotification";
