//
//  AbuPostionModel.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuPostionModel.h"

@implementation AbuPostionModel

+(instancetype)itemWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint date:(NSString *)date
{
    AbuPostionModel * model = [[AbuPostionModel alloc]init];
    model.openPoint = openPoint;
    model.closePoint = closePoint;
    model.highPoint = highPoint;
    model.lowPoint = lowPoint;
    model.date = date;
    return model;
}

@end
