//
//  MKBaseReceiveBeacon+index.m
//  EddystoneSDK
//
//  Created by aa on 2018/8/10.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKBaseReceiveBeacon+index.h"
#import <objc/runtime.h>

static const char *indexKey = "indexKey";

@implementation MKBaseReceiveBeacon (index)

- (void)setIndex:(NSInteger)index{
    objc_setAssociatedObject(self, &indexKey, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index{
    return [objc_getAssociatedObject(self, &indexKey) integerValue];
}

@end
