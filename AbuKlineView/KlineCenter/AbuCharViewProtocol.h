//
//  AbuCharViewProtocol.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbuChartCandleModel.h"
#import "AbuPostionModel.h"
@protocol AbuChartViewProtocol <NSObject>

@optional

/**
 取得当前屏幕内模型数组的开始下标以及个数
 
 @param leftPostion 当前屏幕最右边的位置
 @param index 下标
 @param count 个数
 */
- (void)displayScreenleftPostion:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count;

/**
 长按手势获得当前k线下标以及模型
 
 @param kLineModeIndex 当前k线在可视范围数组的位置下标
 @param kLineModel   k线模型
 */
- (void)longPressCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(AbuChartCandleModel *)kLineModel;

/**
 返回当前屏幕最后一根k线模型
 
 @param kLineModel k线模型
 */
- (void)displayLastModel:(AbuChartCandleModel *)kLineModel;

/**
 * 刷新报价
 @param kLineModel k线模型
 */
- (void)refreshCurrentPrice:(AbuPostionModel *)kLineModel candleModel:(AbuChartCandleModel *)candleModel;

/**
 加载更多数据
 */
- (void)displayMoreData;

@end
