//
//  HCKSlotLineHeader.m
//  HCKEddStone
//
//  Created by aa on 2017/12/11.
//  Copyright © 2017年 HCK. All rights reserved.
//

#import "HCKSlotLineHeader.h"

static NSString *const HCKSlotLineHeaderIdenty = @"HCKSlotLineHeaderIdenty";

@implementation HCKSlotLineHeader

+ (HCKSlotLineHeader *)initHeaderViewWithTableView:(UITableView *)tableView{
    HCKSlotLineHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HCKSlotLineHeaderIdenty];
    if (!view) {
        view = [[HCKSlotLineHeader alloc] initWithReuseIdentifier:HCKSlotLineHeaderIdenty];
    }
    return view;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:RGBCOLOR(242, 242, 242)];
    }
    return self;
}

@end
