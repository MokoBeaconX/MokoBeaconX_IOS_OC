//
//  MKBaseReceiveBeacon+HCKAdd.m
//  HCKEddStone
//
//  Created by aa on 2018/8/14.
//  Copyright © 2018年 HCK. All rights reserved.
//

#import "MKBaseReceiveBeacon+HCKAdd.h"
#import <objc/runtime.h>

static const char *indexKey = "indexKey";

@implementation MKBaseReceiveBeacon (HCKAdd)

- (void)setIndex:(NSInteger)index{
    objc_setAssociatedObject(self, &indexKey, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index{
    return [objc_getAssociatedObject(self, &indexKey) integerValue];
}

@end
