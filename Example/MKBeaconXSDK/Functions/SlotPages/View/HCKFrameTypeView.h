//
//  HCKFrameTypeView.h
//  HCKEddStone
//
//  Created by aa on 2017/12/8.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCKFrameTypeView : UIView

@property (nonatomic, copy)void (^frameTypeChangedBlock)(slotFrameType frameType);

/**
 当前选中的行数
 */
@property (nonatomic, assign)NSInteger index;

@end
