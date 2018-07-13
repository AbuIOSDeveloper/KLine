//
//  AbuKlineUniti.m
//  AbuKlineView
//
//  Created by Jefferson.zhang on 2017/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuKlineUniti.h"

@implementation AbuKlineUniti

- (id)initWithValue:(CGFloat)value date:(NSString *)date {
    self = [self init];
    
    if (self) {
        self.value = value;
        self.date = date;
    }
    return self;
}

@end
