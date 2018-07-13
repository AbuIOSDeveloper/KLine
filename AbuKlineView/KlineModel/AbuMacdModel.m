//
//  AbuMacdModel.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuMacdModel.h"

@implementation AbuMacdModel

- (id)initWithDea:(CGFloat)dea diff:(CGFloat)diff macd:(CGFloat)macd date:(NSString *)date
{
    AbuMacdModel *model = [[AbuMacdModel alloc] init];
    model.dea = dea;
    model.diff = diff;
    model.macd = macd;
    model.date = date;
    return model;
}

@end
