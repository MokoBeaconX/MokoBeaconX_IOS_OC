//
//  HCKSlider.m
//  HCKEddStone
//
//  Created by aa on 2017/12/11.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSlider.h"

@implementation HCKSlider

- (instancetype)init{
    if (self = [super init]) {
        [self setThumbImage:[LOADIMAGE(@"sliderThumbIcon", @"png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                   forState:UIControlStateNormal];
        [self setThumbImage:[LOADIMAGE(@"sliderThumbIcon", @"png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                   forState:UIControlStateHighlighted];
        [self setMinimumTrackImage:[LOADIMAGE(@"sliderMinimumTrackIcon", @"png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                          forState:UIControlStateNormal];
        [self setMaximumTrackImage:[LOADIMAGE(@"sliderMaximumTrackImage", @"png") resizableImageWithCapInsets:UIEdgeInsetsZero] forState:UIControlStateNormal];
    }
    return self;
}

@end
