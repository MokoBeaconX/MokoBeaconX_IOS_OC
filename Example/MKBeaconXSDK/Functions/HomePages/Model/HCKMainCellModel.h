//
//  HCKMainCellModel.h
//  HCKEddStone
//
//  Created by aa on 2017/12/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKBaseDataModel.h"

@interface HCKMainCellModel : HCKBaseDataModel
//左侧icon图片
@property (nonatomic, copy)NSString *leftIconName;
//左侧标题
@property (nonatomic, copy)NSString *leftMsg;
//右侧标题
@property (nonatomic, copy)NSString *rightMsg;
//右侧icon图片，如果不设置则显示右向箭头
@property (nonatomic, copy)NSString *rightIconName;
//是否可点击
@property (nonatomic, assign)BOOL clickEnable;
//是否隐藏右侧图标，如果设置成YES(不显示右侧图标)，则rightIconName设置无效
@property (nonatomic, assign)BOOL hiddenRightIcon;
//cell被选中时候绑定的控制器类
@property (nonatomic, assign)Class destVC;
//cell选中事件回调
@property (nonatomic, copy)void (^iconInfoCellSelectedBlock)(NSIndexPath *pata);

@end
