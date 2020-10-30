//
//  HCKSlotController.m
//  HCKEddStone
//
//  Created by aa on 2017/12/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSlotController.h"
#import "HCKHaveRefreshTableView.h"
#import "HCKOptionsCell.h"
#import "HCKSlotConfigController.h"
#import "HCKSlotDataTypeModel.h"

static NSString *const HCKSlotControllerCellIdenty = @"HCKSlotControllerCellIdenty";

@interface HCKSlotController ()<UITableViewDelegate, UITableViewDataSource, HCKHaveRefreshTableViewDelegate>

@property (nonatomic, strong)HCKHaveRefreshTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

/**
 当进入到通道页面之后，再次返回才需要重新获取通道数据类型
 */
@property (nonatomic, assign)BOOL needReloadData;

@end

@implementation HCKSlotController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKSlotController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.needReloadData || [MKCentralManager sharedInstance].connectState != MKEddystoneConnectStatusConnected) {
        return;
    }
    [self getSlotDataType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    self.needReloadData = YES;
//    [self loadDatas];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return @"Options";
}

- (void)leftButtonMethod{
    [[NSNotificationCenter defaultCenter] postNotificationName:HCKPopToRootViewControllerNotification object:nil];
}

#pragma mark - 代理方法

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HCKOptionsCell getCellHeight];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCKOptionsCell *cell = [HCKOptionsCell initCellWithTabelView:tableView];
    if (indexPath.row < self.dataList.count) {
        cell.dataModel = self.dataList[indexPath.row];
        WS(weakSelf);
        cell.configSlotDataBlock = ^(HCKSlotDataTypeModel *dataModel) {
            weakSelf.needReloadData = YES;
            weakSelf.hidesBottomBarWhenPushed = YES;
            HCKSlotConfigController *vc = [[HCKSlotConfigController alloc] initWithNavigationType:GYNaviTypeShow];
            vc.vcModel = dataModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            weakSelf.hidesBottomBarWhenPushed = NO;
        };
    }
    return cell;
}

#pragma mark - HCKHaveRefreshTableViewDelegate
/**
 *  header开始刷新执行的方法（写刷新逻辑）
 */
- (void)refreshTableView:(HCKHaveRefreshTableView *)tableView headBeginRefreshing:(UIView *)headView{
    [self getSlotDataType];
}

#pragma mark - Private method

- (void)getSlotDataType{
    [[HCKHudManager share] showHUDWithTitle:@"Loading..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKEddystoneInterface readEddystoneSlotDataTypeWithSucBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        [weakSelf.tableView stopRefresh];
        weakSelf.needReloadData = NO;
        [weakSelf parseSlotDataTypeDatas:returnData];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.tableView stopRefresh];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)parseSlotDataTypeDatas:(id)returnData{
    if (!ValidDict(returnData)) {
        return;
    }
    NSArray *list = returnData[@"result"][@"slotTypeList"];
    if (!ValidArray(list)) {
        for (HCKSlotDataTypeModel *model in self.dataList) {
            model.clickEnable = NO;
        }
        return;
    }
    [self.dataList removeAllObjects];
    for (NSInteger i = 0; i < list.count; i ++) {
        NSString *type = list[i];
        HCKSlotDataTypeModel *slotInfo = [[HCKSlotDataTypeModel alloc] init];
        slotInfo.slotType = [self getSlotFrameType:type];
        slotInfo.clickEnable = YES;
        slotInfo.slotIndex = i;
        [self.dataList addObject:slotInfo];
    }
//    //把最后一个通道加进来
//    HCKSlotDataTypeModel *slotModel = [[HCKSlotDataTypeModel alloc] init];
//    slotModel.slotType = slotFrameTypeInfo;
//    slotModel.clickEnable = YES;
//    slotModel.slotIndex = eddStoneActiveSlot6;
//    [self.dataList addObject:slotModel];
    
    [self.tableView reloadData];
}
- (slotFrameType )getSlotFrameType:(NSString *)type{
    if (!ValidStr(type) || [type isEqualToString:@"ff"]) {
        return slotFrameTypeNull;
    }
    if ([type isEqualToString:@"00"]) {
        return slotFrameTypeUID;
    }
    if ([type isEqualToString:@"10"]) {
        return slotFrameTypeURL;
    }
    if ([type isEqualToString:@"20"]) {
        return slotFrameTypeTLM;
    }
    if ([type isEqualToString:@"50"]) {
        return slotFrameTypeiBeacon;
    }
    return slotFrameTypeNull;
}

- (void)loadDatas{
    HCKSlotDataTypeModel *slotInfo = [[HCKSlotDataTypeModel alloc] init];
    HCKSlotDataTypeModel *slotModel = [[HCKSlotDataTypeModel alloc] init];
    slotModel.slotType = slotFrameTypeInfo;
    slotModel.clickEnable = NO;
    slotModel.slotIndex = 6;
    [self.dataList addObject:slotInfo];
    
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

- (HCKHaveRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[HCKHaveRefreshTableView alloc] initWithFrame:CGRectZero sourceType:PLHaveRefreshSourceTypeHeader];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshDelegate = self;
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
