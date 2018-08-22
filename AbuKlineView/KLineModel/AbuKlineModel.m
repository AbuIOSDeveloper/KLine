//
//  AbuKlineModel.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuKlineModel.h"

@implementation AbuKlineModel

+(instancetype)initxPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition color:(UIColor *)color
{
    AbuKlineModel * model = [[AbuKlineModel alloc]init];
    model.xPosition = xPositon;
    model.yPosition = yPosition;
    model.lineColor = color;
    return model;
}

@end
