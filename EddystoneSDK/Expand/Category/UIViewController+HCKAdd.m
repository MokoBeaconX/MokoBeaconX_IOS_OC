//
//  UIViewController+HCKAdd.m
//  HCKEddStone
//
//  Created by aa on 2017/11/28.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "UIViewController+HCKAdd.h"
#import <objc/runtime.h>

static char *vcNavBarBgAlphaKey = "vcNavBarBgAlphaKey";

@implementation UIViewController (HCKAdd)

- (void)setNavBarBgAlpha:(NSString *)navBarBgAlpha{
    if (!ValidStr(navBarBgAlpha)) {
        return;
    }
    /*
     OBJC_ASSOCIATION_ASSIGN;            //assign策略
     OBJC_ASSOCIATION_COPY_NONATOMIC;    //copy策略
     OBJC_ASSOCIATION_RETAIN_NONATOMIC;  // retain策略
     
     OBJC_ASSOCIATION_RETAIN;
     OBJC_ASSOCIATION_COPY;
     */
    /*
     * id object 给哪个对象的属性赋值
     const void *key 属性对应的key
     id value  设置属性值为value
     objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
     */
    
    objc_setAssociatedObject(self, vcNavBarBgAlphaKey, navBarBgAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    // 设置导航栏透明度（利用Category自己添加的方法）
    [self.navigationController setNeedsNavigationBackground:[navBarBgAlpha floatValue]];
}

- (NSString *)navBarBgAlpha{
    return objc_getAssociatedObject(self, vcNavBarBgAlphaKey) ? : @"1.0";
}

@end
