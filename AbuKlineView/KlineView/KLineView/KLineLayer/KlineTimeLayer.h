//
//  KlineTimeLayer.h
//  ABuKLineChartView
//
//  Created by jefferson on 2018/9/7.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface KlineTimeLayer : CAShapeLayer
- (instancetype)initQuotaDataArr:(NSArray *)dataArr  candleWidth:(CGFloat)candleWidth  height:(CGFloat)height timeHight:(CGFloat)timeHeight bottomMargin:(CGFloat)bottomMargin lineWidth:(CGFloat)lineWidth;
@end
