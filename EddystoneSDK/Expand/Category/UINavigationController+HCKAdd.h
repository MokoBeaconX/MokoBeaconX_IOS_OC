//
//  UINavigationController+HCKAdd.h
//  HCKEddStone
//
//  Created by aa on 2017/11/28.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (HCKAdd)<UINavigationBarDelegate, UINavigationControllerDelegate>

@property (copy, nonatomic) NSString *cloudox;

- (void)setNeedsNavigationBackground:(CGFloat)alpha;

@end
