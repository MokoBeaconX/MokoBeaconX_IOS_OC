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
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MKBaseReceiveBeacon *beacon = self.dataList[indexPath.row];
    [[MKCentralManager sharedInstance] connectPeripheral:beacon.peripheral password:@"Moko4321" progressBlock:^(float progress) {
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
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Scan"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(scanMethod)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Stop"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(stopMethod)];
    self.navigationController.navigationItem.leftBarButtonItems = @[leftItem];
    self.navigationController.navigationItem.rightBarButtonItems = @[rightItem];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   self.view.frame.size.width, self.view.frame.size.height)
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
