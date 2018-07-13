//
//  AbuKilneData.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuKilneData.h"

@implementation AbuKilneData

- (id)initWithData:(NSMutableArray *)data color:(UIColor *)color title:(NSString *)title
{
    self = [self init];
    if (self)
    {
        self.data = data;
        self.color = color;
        self.title = title;
    }
    
    return self;
}

@end
