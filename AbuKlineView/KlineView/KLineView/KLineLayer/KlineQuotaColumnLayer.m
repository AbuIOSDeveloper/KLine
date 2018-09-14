//
//  KlineQuotaColumnLayer.m
//  ABuKLineChartView
//
//  Created by jefferson on 2018/9/10.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "KlineQuotaColumnLayer.h"

static inline bool macdIsEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

static NSString *const macdStartX = @"macdStartX";
static NSString *const macdStartY = @"macdStartY";
static NSString *const macdEndX = @"macdEndX";
static NSString *const macdEndY = @"macdEndY";

@interface KlineQuotaColumnLayer()

@property (nonatomic, strong) NSArray  *               klineDataSource;
@property (nonatomic,assign) double                      heightPerpoint;
@property (nonatomic,assign) CGFloat                    candleWidth;
@property (nonatomic,assign) CGFloat                    candleSpace;
@property (nonatomic,assign) CGFloat                    startIndex;
@property (nonatomic,assign) CGFloat                    maxValue;
@property (nonatomic,assign) CGFloat                    qutoaHeight;
@end

@implementation KlineQuotaColumnLayer

- (instancetype)initQuotaDataArr:(NSArray *)dataArr candleWidth:(CGFloat)candleWidth candleSpace:(CGFloat)candleSpace startIndex:(CGFloat)startIndex maxValue:(CGFloat)maxValue heightPerpoint:(CGFloat)heightPerpoint qutoaHeight:(CGFloat)qutoaHeight
{
    self = [super init];
    if (self) {
        self.klineDataSource = dataArr;
        self.heightPerpoint = heightPerpoint;
        self.candleWidth = candleWidth;
        self.candleSpace = candleSpace;
        self.maxValue = maxValue;
        self.startIndex = startIndex;
        self.qutoaHeight = qutoaHeight;
        [self drawMacdLayer:[self coverMacdPostions]];
    }
    return self;
}

- (NSMutableArray *)coverMacdPostions
{
    NSMutableArray * postions = [NSMutableArray array];
    for (int i = 0; i < self.klineDataSource.count; ++i) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        KLineModel *model = [self.klineDataSource objectAtIndex:i];
        CGFloat xPosition = self.startIndex + ((self.candleSpace+self.candleWidth) * i);
        CGFloat yPosition = ABS((self.maxValue - [model.MACD floatValue])/self.heightPerpoint);
        dictionary[macdEndX] = @(xPosition);
        dictionary[macdEndY] = @(yPosition);
        CGPoint strartPoint = CGPointMake(xPosition,self.maxValue/self.heightPerpoint);
        dictionary[macdStartX] = @(strartPoint.x);
        dictionary[macdStartY] = @(strartPoint.y);
        float x = strartPoint.y - yPosition;
        if (macdIsEqualZero(x))
        {
            dictionary[macdEndY] = @(self.maxValue/self.heightPerpoint+1);
        }
        [postions addObject:dictionary];
    }
    return postions;
}

- (void)drawMacdLayer:(NSMutableArray *)postions
{
    [postions enumerateObjectsUsingBlock:^(NSDictionary* dic, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat strartX = [dic[macdStartX] floatValue];
        CGFloat strartY = [dic[macdStartY] floatValue];
        CGFloat endY = [dic[macdEndY] floatValue];
        CGRect rect = CGRectMake(strartX, strartY + self.qutoaHeight + midDistance, self.candleWidth, endY- strartY);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        CAShapeLayer * subLayer = [CAShapeLayer layer];
        subLayer.path = path.CGPath;
        
        if (endY > strartY)
        {
            subLayer.strokeColor = DROPCOLOR.CGColor;
            
            subLayer.fillColor = DROPCOLOR.CGColor;
        }
        else
        {
            subLayer.strokeColor = RISECOLOR.CGColor;
            subLayer.fillColor = RISECOLOR.CGColor;
        }
        [self addSublayer:subLayer];
    }];
}

@end
