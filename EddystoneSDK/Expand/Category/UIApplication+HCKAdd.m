//
//  UIApplication+HCKAdd.m
//  FitPolo
//
//  Created by aa on 17/7/4.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "UIApplication+HCKAdd.h"

@implementation UIApplication (HCKAdd)

- (BOOL)skipTo:(NSString *)URLString{
    NSURL*url=[NSURL URLWithString:URLString];
    return [self openURL:url];
}

- (BOOL)shipToSetHome{
    return [self skipTo:@"prefs:root"];
}

- (BOOL)skipToGeneral{
    return [self skipTo:@"prefs:root=General"];
}

- (BOOL)skipToWifi{
    return [self skipTo:@"prefs:root=WIFI"];
}

- (BOOL)skipToAbout{
    return [self skipTo:@"prefs:root=General&path=About"];
}

- (BOOL)skipToAccessibility{
    return [self skipTo:@"prefs:root=General&path=AUTOLOCK"];
}

- (BOOL)skipToAutoLock{
    return [self skipTo:@"prefs:root=General&path=ACCESSIBILITY"];
}

- (BOOL)skipToBrightness{
    return [self skipTo:@"prefs:root=Brightness"];
}

- (BOOL)skipToBluetooth{
    return [self skipTo:@"prefs:root=General&path=Bluetooth"];
}

- (BOOL)skipToDateTime{
    return [self skipTo:@"prefs:root=General&path=DATE_AND_TIME"];
}

- (BOOL)skipToFaceTime{
    return [self skipTo:@"prefs:root=FACETIME"];
}

- (BOOL)skipToKeyboard{
    return [self skipTo:@"prefs:root=General&path=Keyboard"];
}

- (BOOL)skipToiCloud{
    return [self skipTo:@"prefs:root=CASTLE"];
}

- (BOOL)skipToiCloudStorage{
    return [self skipTo:@"prefs:root=CASTLE&path=STORAGE_AND_BACKUP"];
}

- (BOOL)skipInternational{
    return [self skipTo:@"prefs:root=General&path=INTERNATIONAL"];
}

- (BOOL)skipToLocationServices{
    return [self skipTo:@"prefs:root=LOCATION_SERVICES"];
}

- (BOOL)skipToMusic{
    return [self skipTo:@"prefs:root=Music"];
}


- (BOOL)skipToMusicVolumeLimit{
    return [self skipTo:@"prefs:root=MUSIC&path=VolumeLimit"];
}

- (BOOL)skipToCellular{
    return [self skipTo:@"prefs:root=Cellular"];
}

- (BOOL)skipToNotes{
    return [self skipTo:@"prefs:root=NOTES"];
}

- (BOOL)skipToNotification{
    return [self skipTo:@"prefs:root=NOTIFICATIONS_ID"];
}


- (BOOL)skipToPhotos{
    return [self skipTo:@"prefs:root=Photos"];
}

- (BOOL)skipToPrivacy{
    return [self skipTo:@"prefs:root=Privacy"];
}

- (BOOL)skipToProfile{
    return [self skipTo:@"prefs:root=General&path=ManagedConfigurationList"];
}

- (BOOL)skipToReset{
    return [self skipTo:@"prefs:root=General&path=Reset"];
}

- (BOOL)skipToSafari{
    return [self skipTo:@"prefs:root=Safari"];
}

- (BOOL)skipToSiri{
    return [self skipTo:@"prefs:root=General&path=Assistant"];
}

- (BOOL)skipToSounds{
    return [self skipTo:@"prefs:root=Sounds"];
}

- (BOOL)skipToSoftwareUpdate{
    return [self skipTo:@"prefs:root=General&path=SOFTWARE_UPDATE_LINK"];
}

- (BOOL)skipToStore{
    return [self skipTo:@"prefs:root=STORE"];
}

- (BOOL)skipToTwitter{
    return [self skipTo:@"prefs:root=TWITTER"];
}

- (BOOL)skipToUsage{
    return [self skipTo:@"prefs:root=General&path=USAGE"];
}

- (BOOL)skipToVPN{
    return [self skipTo:@"prefs:root=General&path=Network/VPN"];
}

- (BOOL)skipToWallpaper{
    return [self skipTo:@"prefs:root=Wallpaper"];
}

@end
