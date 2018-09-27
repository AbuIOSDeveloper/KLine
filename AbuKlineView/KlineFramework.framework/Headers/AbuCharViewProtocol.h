//
//  AbuCharViewProtocol.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineModel.h"
@protocol AbuChartViewProtocol <NSObject>

@optional

- (void)displayScreenleftPostion:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count;

- (void)longPressCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(KLineModel *)kLineModel;

- (void)displayLastModel:(KLineModel *)kLineModel;

- (void)refreshCurrentPrice:(KLineModel *)kLineModel candleModel:(KLineModel *)candleModel;

- (void)reloadPriceViewWithPriceArr:(NSArray *)priceArr;

- (void)reloadPriceViewWithQuotaMaxValue:(double)maxValue MinValue:(double)minValue;

- (void)displayMoreData;

@end
