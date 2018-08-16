//
//  HCKSystemResource.h
//  FitPolo
//
//  Created by aa on 17/7/4.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCKSystemResource : NSObject

+ (instancetype)share;
/**
 *  是否允许定位
 */
+ (BOOL)isAlowPosition;

/**
 *  是否允许访问相机
 */
+ (BOOL)isAllowAccessCamera;

/**
 *  是否允许访问相册
 */
+ (BOOL)isAllowAccessPhotos;

/**
 是否允许访问麦克风
 */
+ (BOOL)isAllowAccessMicrophone;

/**
 是否有打电话功能
 */
+ (BOOL)isAllowAccessTelephone;

/**
 *  2016年09月03日 add by 胡仕君： 处理调用相机
 *
 *  @param target   响应方法的界面
 *  @param selector 允许使用相机资源后调用的方法
 */
- (void)handleAccessCameraWithTarget:(id) target selecter:(SEL)selector;

/**
 *  2016年09月03日 add by 胡仕君： 处理调用相册
 *
 *  @param target   响应方法的界面
 *  @param selector 允许使用相册资源后调用的方法
 */
- (void)handleAccessPhotosWithTarget:(id) target selecter:(SEL)selector;

/**
 2016年09月19日 add by 胡仕君：处理调用麦克风
 
 @param target   响应方法的界面
 @param selector 允许使用麦克风资源后调用的方法
 */
- (void)handleAccessMicrophoneWithTarget:(id) target selecter:(SEL)selector;

/**
 *  处理调用相机
 *
 *  @param allowInvocation 允许使用相机资源后调用的方法
 */
- (void)handleAccessCamera:(NSInvocation *)allowInvocation;

/**
 *  处理调用相册
 *
 *  @param allowInvocation 允许使用相册资源后调用的方法
 */
- (void)handleAccessPhotos:(NSInvocation *)allowInvocation;


/**
 处理调用麦克风
 
 @param allowInvocation 允许使用麦克风资源后调用的方法
 */
- (void)handleAccessMicrophone:(NSInvocation *)allowInvocation;

@end
