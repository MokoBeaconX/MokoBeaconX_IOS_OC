//
//  UIApplication+HCKAdd.h
//  FitPolo
//
//  Created by aa on 17/7/4.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (HCKAdd)

// 跳转到 设置首页
- (BOOL)shipToSetHome;

// 跳转到 root->通用页
- (BOOL)skipToGeneral;

// 跳到 root->wifi设置页
- (BOOL)skipToWifi;

// 跳转到 root->通用->关于页
- (BOOL)skipToAbout;

// 跳转到 root->通用->辅助功能
- (BOOL)skipToAccessibility;

// 跳转到 root->通用->自动锁定
- (BOOL)skipToAutoLock;

// 跳转到 root->显示与亮度
- (BOOL)skipToBrightness;

// 跳转到 root->蓝牙
- (BOOL)skipToBluetooth;

// 跳转到 root->通用->日期与时间
- (BOOL)skipToDateTime;

// 跳转到 root->FaceTime
- (BOOL)skipToFaceTime;

// 跳转到 root->通用->键盘
- (BOOL)skipToKeyboard;

// 跳转到 root->iClound
- (BOOL)skipToiCloud;

// 跳转到 root->iClound->储存空间
- (BOOL)skipToiCloudStorage;

// 跳转到 root->通用->语言与地区
- (BOOL)skipInternational;

// 跳转到 root->隐私->定位服务
- (BOOL)skipToLocationServices;

// 跳转到 root->音乐
- (BOOL)skipToMusic;

// 跳转到 root->音乐->音量
- (BOOL)skipToMusicVolumeLimit;

// 跳转到 root->蜂窝移动网络
- (BOOL)skipToCellular;

// 跳转到 root->备忘录
- (BOOL)skipToNotes;

// 跳转到 root->通知
- (BOOL)skipToNotification;

// 跳转到 root->相册
- (BOOL)skipToPhotos;

// 跳转到 root->隐私
- (BOOL)skipToPrivacy;

// 跳转到 root->通用->描述文件
- (BOOL)skipToProfile;

// 跳转到 root->通用->还原
- (BOOL)skipToReset;

// 跳转到 root->safari
- (BOOL)skipToSafari;

// 跳转到 root->通用->siri
- (BOOL)skipToSiri;

// 跳转到 root->声音
- (BOOL)skipToSounds;

// 跳转到 root->通用->软件更新
- (BOOL)skipToSoftwareUpdate;

// 跳转到 root->iTunes Store & AppStore
- (BOOL)skipToStore;

// 跳转到 root->Twitter
- (BOOL)skipToTwitter;

// 跳转到 root->通用->储存空间与iCloud
- (BOOL)skipToUsage;

// 跳转到 root->通用->VPN
- (BOOL)skipToVPN;

// 跳转到 root->墙纸
- (BOOL)skipToWallpaper;

@end
