//
//  MKConnectDeviceProgressView.h
//  MKSmartPlug
//
//  Created by aa on 2018/6/4.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKConnectDeviceProgressView : UIView

- (void)showConnectAlertViewWithTitle:(NSString *)title;

- (void)setProgress:(CGFloat)progress;

- (void)dismiss;

@end
