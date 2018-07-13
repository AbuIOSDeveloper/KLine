//
//  AbuMacadPostionModel.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuMacadPostionModel.h"

@implementation AbuMacadPostionModel
+(instancetype)initPostion:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    AbuMacadPostionModel *model = [[AbuMacadPostionModel alloc] init];
    model.startPoint = startPoint;
    model.endPoint = endPoint;
    return model;
}
@end
