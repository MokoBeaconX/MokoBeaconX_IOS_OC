//
//  HCKSlotConfigController.m
//  HCKEddStone
//
//  Created by aa on 2017/12/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSlotConfigController.h"
#import "HCKBaseTableView.h"
#import "HCKSlotConfigCellModel.h"
#import "HCKSlotBaseCell.h"
#import "HCKAdvContentiBeaconCell.h"
#import "HCKAdvContentUIDCell.h"
#import "HCKAdvContentURLCell.h"
#import "HCKAdvContentBaseCell.h"
#import "HCKBaseParamsCell.h"
#import "HCKFrameTypeView.h"
#import "HCKSlotLineHeader.h"

static CGFloat const offset_X = 15.f;
static CGFloat const headerViewHeight = 130.f;
static CGFloat const baseParamsCellHeight = 185.f;
static CGFloat const iBeaconAdvCellHeight = 145.f;
static CGFloat const uidAdvCellHeight = 120.f;
static CGFloat const urlAdvCellHeight = 100.f;

@interface HCKSlotConfigController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)HCKBaseTableView *tableView;

@property (nonatomic, strong)HCKFrameTypeView *tableHeader;

@property (nonatomic, assign)slotFrameType frameType;

@property (nonatomic, strong)NSMutableArray *dataList;

/**
 进来的时候拿的当前通道数据
 */
@property (nonatomic, strong)NSDictionary *originalDic;

@end

@implementation HCKSlotConfigController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"HCKSlotConfigController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MKPeripheralConnectStateChangedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self.rightButton setImage:LOADIMAGE(@"slotSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(5.f);
        make.bottom.mas_equalTo(0);
    }];
    [self reloadTableViewData];
    [self readSlotDetailData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peripheralConnectStateChanged)
                                                 name:MKPeripheralConnectStateChangedNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法
- (NSString *)defaultTitle{
    return [self getDefaultTitle];
}

- (void)rightButtonMethod{
    [self saveDetailDatasToEddStone];
}

#pragma mark - 代理方法
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.dataList.count) {
        HCKSlotConfigCellModel *model = self.dataList[indexPath.section];
        switch (model.cellType) {
            case iBeaconAdvContent:
                return iBeaconAdvCellHeight;
                
            case uidAdvContent:
                return uidAdvCellHeight;
                
            case urlAdvContent:
                return urlAdvCellHeight;
            
            case baseParam:
                return baseParamsCellHeight;
            default:
                break;
        }
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HCKSlotLineHeader *header = [HCKSlotLineHeader initHeaderViewWithTableView:tableView];
    return header;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCKSlotBaseCell *cell;
    if (indexPath.section < self.dataList.count) {
        HCKSlotConfigCellModel *model = self.dataList[indexPath.section];
        switch (model.cellType) {
            case iBeaconAdvContent:
                cell = [HCKAdvContentiBeaconCell initCellWithTableView:tableView];
                break;
            case uidAdvContent:
                cell = [HCKAdvContentUIDCell initCellWithTableView:tableView];
                break;
            case urlAdvContent:
                cell = [HCKAdvContentURLCell initCellWithTableView:tableView];
                break;
            case baseParam:
                cell = [HCKBaseParamsCell initCellWithTableView:tableView];
                [self setBaseCellType:cell];
                break;
            default:
                break;
        }
        if ([cell respondsToSelector:@selector(setDataDic:)]) {
            [cell performSelector:@selector(setDataDic:) withObject:model.dataDic];
        }
    }
    return cell;
}

#pragma mark - note method
- (void)peripheralConnectStateChanged{
    if ([MKCentralManager sharedInstance].connectState != MKEddystoneConnectStatusConnected
        && [MKCentralManager sharedInstance].managerState == MKEddystoneCentralManagerStateEnable) {
        [self leftButtonMethod];
    }
}

#pragma mark - Private method

/**
 从eddStone读取详情数据
 */
- (void)readSlotDetailData{
    [[HCKHudManager share] showHUDWithTitle:@"Loading..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [[HCKDataManager share] readSlotDetailData:self.vcModel successBlock:^(id returnData) {
        [[HCKHudManager share] hide];
        weakSelf.originalDic = returnData;
        weakSelf.frameType = [weakSelf loadFrameType:returnData[@"advData"][@"frameType"]];
        weakSelf.tableHeader.index = [weakSelf getHeaderViewSelectedRow];
        [weakSelf reloadTableViewData];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

/**
 刷新table
 */
- (void)reloadTableViewData{
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:[self reloadDatasWithType]];
    [self.tableView reloadData];
}

- (void)setBaseCellType:(UITableViewCell *)cell{
    if (!cell) {
        return;
    }
    NSString *type = @"";
    if (self.frameType == slotFrameTypeiBeacon) {
        type = HCKSlotBaseCelliBeaconType;
    }else if (self.frameType == slotFrameTypeTLM){
        type = HCKSlotBaseCellTLMType;
    }else if (self.frameType == slotFrameTypeUID){
        type = HCKSlotBaseCellUIDType;
    }else if (self.frameType == slotFrameTypeURL){
        type = HCKSlotBaseCellURLType;
    }
    [cell performSelector:@selector(setBaseCellType:) withObject:type];
}

/**
 根据frame type生成不同的数据

 @return 数据源
 */
- (NSArray *)reloadDatasWithType{
    switch (self.frameType) {
        case slotFrameTypeiBeacon:
            return [self createNewIbeaconList];

        case slotFrameTypeUID:
            return [self createNewUIDList];
            
        case slotFrameTypeURL:
            return [self createNewUrlList];
            
        case  slotFrameTypeTLM:
            return [self createNewTLMOrInfoList];
            
        case slotFrameTypeInfo:
            return [self createNewTLMOrInfoList];
            
        case slotFrameTypeNull:
            return @[];
        default:
            return nil;
            break;
    }
}

/**
 生成iBeacon模式下的数据源

 @return NSArray
 */
- (NSArray *)createNewIbeaconList{
    HCKSlotConfigCellModel *advModel = [[HCKSlotConfigCellModel alloc] init];
    advModel.cellType = iBeaconAdvContent;
    
    HCKSlotConfigCellModel *baseParamModel = [[HCKSlotConfigCellModel alloc] init];
    baseParamModel.cellType = baseParam;
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    if (self.vcModel.slotType == slotFrameTypeiBeacon && ValidDict(self.originalDic)) {
        advModel.dataDic = self.originalDic[@"advData"];
    }
    
    return @[advModel, baseParamModel];
}

/**
 生成UID模式下的数据源

 @return NSArray
 */
- (NSArray *)createNewUIDList{
    HCKSlotConfigCellModel *advModel = [[HCKSlotConfigCellModel alloc] init];
    advModel.cellType = uidAdvContent;
    
    HCKSlotConfigCellModel *baseParamModel = [[HCKSlotConfigCellModel alloc] init];
    baseParamModel.cellType = baseParam;
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    if (self.vcModel.slotType == slotFrameTypeUID && ValidDict(self.originalDic)) {
        advModel.dataDic = self.originalDic[@"advData"];
    }
    return @[advModel, baseParamModel];
}

/**
 生成url模式下的数据源

 @return NSArray
 */
- (NSArray *)createNewUrlList{
    HCKSlotConfigCellModel *advModel = [[HCKSlotConfigCellModel alloc] init];
    advModel.cellType = urlAdvContent;
    
    HCKSlotConfigCellModel *baseParamModel = [[HCKSlotConfigCellModel alloc] init];
    baseParamModel.cellType = baseParam;
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    if (self.vcModel.slotType == slotFrameTypeURL && ValidDict(self.originalDic)) {
        advModel.dataDic = self.originalDic[@"advData"];
    }
    return @[advModel, baseParamModel];
}

/**
 生成TLM模式下的数据源

 @return NSArray
 */
- (NSArray *)createNewTLMOrInfoList{
    HCKSlotConfigCellModel *baseParamModel = [[HCKSlotConfigCellModel alloc] init];
    baseParamModel.cellType = baseParam;
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    return @[baseParamModel];
}

- (slotFrameType )loadFrameType:(NSString *)type{
    if (!ValidStr(type)) {
        return 999;
    }
    if ([type isEqualToString:@"00"]) {
        return slotFrameTypeUID;
    }else if ([type isEqualToString:@"10"]){
        return slotFrameTypeURL;
    }else if ([type isEqualToString:@"20"]){
        return slotFrameTypeTLM;
    }else if ([type isEqualToString:@"50"]){
        return slotFrameTypeiBeacon;
    }else if ([type isEqualToString:@"60"]){
        return slotFrameTypeInfo;
    }else if ([type isEqualToString:@"70"]){
        return slotFrameTypeNull;
    }
    return 999;
}

/**
 根据通道号返回对应的title

 @return title
 */
- (NSString *)getDefaultTitle{
    if (!self.vcModel) {
        return nil;
    }
    switch (self.vcModel.slotIndex) {
        case eddystoneActiveSlot1:
            return @"SLOT1";

        case eddystoneActiveSlot2:
            return @"SLOT2";
            
        case eddystoneActiveSlot3:
            return @"SLOT3";
            
        case eddystoneActiveSlot4:
            return @"SLOT4";
            
        case eddystoneActiveSlot5:
            return @"SLOT5";
            
        default:
            break;
    }
    return nil;
}

/**
 根据通道数据类型返回列表header选中row

 @return 选中row
 */
- (NSInteger)getHeaderViewSelectedRow{
    switch (self.frameType) {
            
        case slotFrameTypeTLM:
            return 0;
            
        case slotFrameTypeUID:
            return 1;
            
        case slotFrameTypeURL:
            return 2;
            
        case slotFrameTypeiBeacon:
            return 3;
            
        case slotFrameTypeInfo:
            return 4;
            
        case slotFrameTypeNull:
            return 4;
            
        default:
            break;
    }
    return 9;
}

/**
 设置详情数据
 */
- (void)saveDetailDatasToEddStone{
    BOOL canSet = YES;
    NSMutableDictionary *detailDic = [NSMutableDictionary dictionary];
    if (self.frameType != slotFrameTypeNull) {
        //NO DATA情况下不需要详情
        NSArray *cellList = [self.tableView visibleCells];
        if (!ValidArray(cellList)) {
            [self.view showCentralToast:@"Set the data failure"];
            return;
        }
        for (HCKSlotBaseCell *cell in cellList) {
            NSDictionary *dic = [cell getContentData];
            if (!ValidDict(dic)) {
                canSet = NO;
                break;
            }
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"2"]) {
                canSet = NO;
                [self.view showCentralToast:dic[@"msg"]];
                break;
            }
            NSString *type = dic[@"result"][@"type"];
            if (ValidStr(type)) {
                [detailDic setObject:dic[@"result"] forKey:type];
            }
        }
    }
    
    if (!canSet) {
        return;
    }
    [[HCKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [[HCKDataManager share] setSlotDetailData:self.vcModel.slotIndex slotFrameType:self.frameType detailData:detailDic successBlock:^{
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:@"success"];
        [weakSelf performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
    } failedBlock:^(NSError *error) {
        [[HCKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - Public method
- (void)setVcModel:(HCKSlotDataTypeModel *)vcModel{
    _vcModel = nil;
    _vcModel = vcModel;
    if (!_vcModel) {
        return;
    }
    self.frameType = _vcModel.slotType;
}

#pragma mark - setter & getter
-(HCKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[HCKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = [self tableHeader];
    }
    return _tableView;
}

- (HCKFrameTypeView *)tableHeader{
    if (!_tableHeader) {
        _tableHeader = [[HCKFrameTypeView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          kScreenWidth - 2 * offset_X,
                                                                          headerViewHeight)];
        WS(weakSelf);
        _tableHeader.frameTypeChangedBlock = ^(slotFrameType frameType) {
            weakSelf.frameType = frameType;
            [weakSelf reloadTableViewData];
        };
        _tableHeader.index = [self getHeaderViewSelectedRow];
    }
    return _tableHeader;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
