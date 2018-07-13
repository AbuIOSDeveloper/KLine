//
//  UIWindow+FHH.m
//  FHHFPSIndicator
//
//  Created by 002 on 16/6/27.
//  Copyright © 2016年 002. All rights reserved.
//

#import "UIWindow+FHH.h"

#define TAG_fpsLabel 110213

@implementation UIWindow (FHH)

- (void)layoutSubviews {

    [super layoutSubviews];
    
    for (UIView *label in self.subviews) {
        if ([label isKindOfClass:[UILabel class]]&& label.tag == TAG_fpsLabel) {
            [self bringSubviewToFront:label];
            return;
        }
    }
}

@end
