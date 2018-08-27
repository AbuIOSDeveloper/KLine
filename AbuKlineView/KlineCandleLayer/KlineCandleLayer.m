//
//  KlineCandleLayer.m
//  AbuKlineView
//
//  Created by jefferson on 2018/8/27.
//  Copyright © 2018年 阿布. All rights reserved.
//

#import "KlineCandleLayer.h"

@interface KlineCandleLayer ()

@property (nonatomic,strong) NSArray                *  dataArr;
@property (nonatomic,assign) NSInteger                 startIndex;
@property (nonatomic,assign) double                      heightPerpoint;
@property (nonatomic,assign) CGFloat                    candleWidth;
@property (nonatomic,assign) double                       quotaMinValue;
@property (nonatomic,assign) double                       quotaMaxValue;

@end

@implementation KlineCandleLayer

- (instancetype)initQuotaDataArr:(NSArray *)dataArr currentStartIndex:(NSInteger)startIndex candleWidth:(CGFloat)candleWidth minValue:(double)minValue maxValue:(CGFloat)maxValue heightPerpoint:(CGFloat)heightPerpoint
{
    self = [super init];
    if (self) {
        self.dataArr = dataArr;
        self.startIndex = startIndex;
        self.candleWidth = candleWidth;
        self.quotaMaxValue = maxValue;
        self.quotaMinValue = minValue;
        
    }
    return self;
}


@end
