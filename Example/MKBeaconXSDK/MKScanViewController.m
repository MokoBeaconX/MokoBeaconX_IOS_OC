//
//  MKScanViewController.m
//  EddystoneSDK
//
//  Created by aa on 2018/8/17.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKScanViewController.h"
#import "MKEddystoneSDK.h"
#import "MKTestViewController.h"

@interface MKScanViewController ()<UITableViewDelegate, UITableViewDataSource, MKEddystoneScanDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.navigationItem setTitle:@"scan"];
    [MKCentralManager sharedInstance].scanDelegate = self;
    [[MKCentralManager sharedInstance] startScanPeripheral];
    [self setUIConfig];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MKBaseReceiveBeacon *beacon = self.dataList[indexPath.row];
    [[MKCentralManager sharedInstance] connectPeripheral:beacon.peripheral password:@"MOKOMOKO" progressBlock:^(float progress) {
        NSLog(@"------%f",progress);
    } sucBlock:^(CBPeripheral *peripheral) {
        MKTestViewController *vc = [[MKTestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } failedBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scanCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"scanCell"];
    }
    MKBaseReceiveBeacon *beacon = self.dataList[indexPath.row];
    cell.textLabel.text = beacon.identifier;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"rssi-%@",beacon.rssi];
    return cell;
}

#pragma mark - MKEddystoneScanDelegate
- (void)didReceiveBeacon:(MKBaseReceiveBeacon *)beacon manager:(MKCentralManager *)manager{
    if (!beacon || beacon.frameType == MKEddystoneUnknownFrameType || beacon.frameType == MKEddystoneNODATAFrameType) {
        return;
    }
    NSString *identy = beacon.peripheral.identifier.UUIDString;
    @synchronized(self.dataList){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identy];
        NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
        BOOL contain = (array.count > 0);
        if (contain) {
            return;
        }
        //不存在，则加入
        [self.dataList addObject:beacon];
        [self.tableView reloadData];
    }
}

#pragma mark - event method
- (void)scanMethod{
    [[MKCentralManager sharedInstance] startScanPeripheral];
}

- (void)stopMethod{
    [[MKCentralManager sharedInstance] stopScanPeripheral];
}

#pragma mark -
- (void)setUIConfig{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100.f)];
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(15.f, 15.f, self.view.frame.size.width - 30, 30.f);
    [scanButton setTitle:@"Scan" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanMethod) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:scanButton];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopButton.frame = CGRectMake(15, 60.f, self.view.frame.size.width - 30, 30.f);
    [stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [stopButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stopMethod) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:stopButton];
    
    self.tableView.tableFooterView = footerView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   80.f,
                                                                   self.view.frame.size.width, self.view.frame.size.height - 80 - 45.f)
                                                  style:UITableViewStylePlain];
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
