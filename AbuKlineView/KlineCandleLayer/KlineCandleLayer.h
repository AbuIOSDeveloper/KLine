//
//  KlineCandleLayer.h
//  AbuKlineView
//
//  Created by jefferson on 2018/8/27.
//  Copyright © 2018年 阿布. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface KlineCandleLayer : CAShapeLayer

- (instancetype)initQuotaDataArr:(NSArray *)dataArr currentStartIndex:(NSInteger)startIndex candleWidth:(CGFloat)candleWidth minValue:(double)minValue maxValue:(CGFloat)maxValue heightPerpoint:(CGFloat)heightPerpoint ;

@end
