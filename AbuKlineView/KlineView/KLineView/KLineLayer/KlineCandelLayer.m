//
//  KlineCandelLayer.m
//  ABuKLineChartView
//
//  Created by jefferson on 2018/9/7.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "KlineCandelLayer.h"

@interface KlineCandelLayer()

@property (nonatomic, strong) NSArray  *               klineDataSource;
@property (nonatomic,assign) double                      heightPerpoint;
@property (nonatomic,assign) CGFloat                    candleWidth;
@property (nonatomic,assign) CGFloat                    candleSpace;
@property (nonatomic,assign) CGFloat                    startIndex;
@property (nonatomic,assign) double                      maxValue;
@property (nonatomic,assign) double                      contentWidth;
@end
@implementation KlineCandelLayer
- (instancetype)initQuotaDataArr:(NSArray *)dataArr candleWidth:(CGFloat)candleWidth candleSpace:(CGFloat)candleSpace startIndex:(CGFloat)startIndex maxValue:(CGFloat)maxValue heightPerpoint:(CGFloat)heightPerpoint scrollViewContentWidth:(CGFloat)contentWidth
{
    self = [super init];
    if (self) {
        self.klineDataSource = dataArr;
        self.candleWidth = candleWidth;
        self.candleSpace = candleSpace;
        self.startIndex = startIndex;
        self.maxValue = maxValue;
        self.heightPerpoint = heightPerpoint;
        self.contentWidth = contentWidth;
        [self convertToKlinePositionDataArr:self.klineDataSource];
        [self drawCandleSublayers];
    }
    return self;
}

- ( void)convertToKlinePositionDataArr:(NSArray *)dataArr
{
    for (NSInteger i = 0 ; i < dataArr.count; i++)
    {
        KLineModel *model  = [dataArr objectAtIndex:i];
        CGFloat open = ((self.maxValue - model.openPrice) * self.heightPerpoint);
        CGFloat close = ((self.maxValue - model.closePrice) * self.heightPerpoint);
        CGFloat high = ((self.maxValue - model.highPrice) * self.heightPerpoint);
        CGFloat low = ((self.maxValue - model.lowPrice) * self.heightPerpoint);
        CGFloat left = self.startIndex + ((self.candleWidth + self.candleSpace) * i);
       
        if (left >= self.contentWidth)
        {
            left = self.contentWidth - self.candleWidth/2.f;
        }
        model.opensPoint = CGPointMake(left, open);
        model.closesPoint = CGPointMake(left, close);
        model.highestPoint = CGPointMake(left, high);
        model.lowestPoint = CGPointMake(left, low);
    }
}

- (CAShapeLayer*)getShaperLayer:(KLineModel*)postion
{
    CGFloat openPrice = postion.opensPoint.y + topDistance;
    CGFloat closePrice = postion.closesPoint.y + topDistance;
    CGFloat hightPrice = postion.highestPoint.y + topDistance;
    CGFloat lowPrice = postion.lowestPoint.y + topDistance;
    CGFloat x = postion.opensPoint.x;
    UIBezierPath *path = [UIBezierPath drawKLine:openPrice close:closePrice high:hightPrice low:lowPrice candleWidth:self.candleWidth xPostion:x lineWidth:self.lineWidth];
    
    CAShapeLayer *subLayer = [CAShapeLayer layer];
    subLayer.fillColor = [UIColor clearColor].CGColor;
    if (postion.opensPoint.y >= postion.closesPoint.y)
    {
        subLayer.strokeColor = RISECOLOR.CGColor;
        //        subLayer.fillColor = RISECOLOR.CGColor;
    }
    else
    {
        subLayer.strokeColor = DROPCOLOR.CGColor;
        //        subLayer.fillColor = DROPCOLOR.CGColor;
    }
    subLayer.path = path.CGPath;
    [path removeAllPoints];
    return subLayer;
}

- (void)drawCandleSublayers
{
    WS(weakSelf);
    [self.klineDataSource enumerateObjectsUsingBlock:^(KLineModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *subLayer = [weakSelf getShaperLayer:obj];
        [weakSelf addSublayer:subLayer];
    }];
}

@end
