//
//  KlineCandelLayer.h
//  ABuKLineChartView
//
//  Created by jefferson on 2018/9/7.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface KlineCandelLayer : CAShapeLayer

- (instancetype)initQuotaDataArr:(NSArray *)dataArr  candleWidth:(CGFloat)candleWidth candleSpace:(CGFloat)candleSpace startIndex:(CGFloat)startIndex maxValue:(CGFloat)maxValue heightPerpoint:(CGFloat)heightPerpoint scrollViewContentWidth:(CGFloat)contentWidth;

@end
