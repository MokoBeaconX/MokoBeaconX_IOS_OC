//
//  HCKNomalBlockDefines.h
//  FitPolo
//
//  Created by aa on 17/5/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}

/**
 cell点击事件block，需要知道cell的选中状态时候用的block
 
 @param path 被点击cell的NSIndexPath
 @param selected 是否被选中，YES选中，NO取消选中
 */
typedef void(^HCKBaseCellSelectedBlock)(NSIndexPath *path, BOOL selected);

/**
 cell点击事件block，不需要知道选中状态

 @param path 被点击cell的NSIndexPath
 */
typedef void(^HCKBaseCellSelectedWithNoStateBlock)(NSIndexPath *path);

/**
 从EddStone读取数据成功Block

 @param returnData 读回来的数据
 */
typedef void(^readDataFromEddStoneSuccessBlock)(id returnData);

/**
 从EddStone读取数据失败Block

 @param error 错误详情
 */
typedef void(^readDataFromEddStoneFailedBlock)(NSError *error);

/**
 设置数据给eddStone成功回调
 */
typedef void(^setDataToEddStoneSuccessBlock)(void);

/**
 设置数据给eddStone失败回调

 @param error 错误原因
 */
typedef void(^setDataToEddStoneFailedBlock)(NSError *error);

