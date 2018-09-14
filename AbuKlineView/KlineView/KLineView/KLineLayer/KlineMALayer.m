//
//  KlineMALayer.m
//  ABuKLineChartView
//
//  Created by jefferson on 2018/9/7.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "KlineMALayer.h"

@interface KlineMALayer()
@property (nonatomic, strong) NSArray  *               klineDataSource;
@property (nonatomic,assign) double                      heightPerpoint;
@property (nonatomic,assign) CGFloat                    candleWidth;
@property (nonatomic,assign) CGFloat                    candleSpace;
@property (nonatomic,assign) CGFloat                    startIndex;
@property (nonatomic,assign) CGFloat                    maxValue;
@property (nonatomic,strong) UIColor                   * color;
@property (nonatomic,assign) CGFloat                     totalHeight;
@property (nonatomic,assign) double                       lineWidth;
@property (nonatomic,assign) WIRETYPE                  wiretype;
@property (nonatomic,assign) KlineWireSubOrMain    klineWiretype;
@end

@implementation KlineMALayer

- (instancetype)initQuotaDataArr:(NSArray *)dataArr candleWidth:(CGFloat)candleWidth candleSpace:(CGFloat)candleSpace startIndex:(CGFloat)startIndex maxValue:(CGFloat)maxValue heightPerpoint:(CGFloat)heightPerpoint totalHeight:(CGFloat)totalHeight lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor wireType:(WIRETYPE)wiretype klineSubOrMain:(KlineWireSubOrMain)klineWiretype
{
    self = [super init];
    if (self) {
        self.klineDataSource = dataArr;
        self.candleWidth = candleWidth;
        self.candleSpace = candleSpace;
        self.startIndex = startIndex;
        self.maxValue = maxValue;
        self.heightPerpoint = heightPerpoint;
        self.totalHeight = totalHeight;
        self.lineWidth = lineWidth;
        self.color = lineColor;
        self.wiretype = wiretype;
        self.klineWiretype = klineWiretype;
        [self drawWireLine:[self coverPostionModel]];
    }
    return self;
}

- (NSMutableArray *)coverPostionModel
{
    NSMutableArray * postions = [NSMutableArray array];
    for (int i = 0; i< self.klineDataSource.count; i++) {
        KLineModel *model = self.klineDataSource[i];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        CGPoint postionPoint;
        NSNumber * value = @0.0;
        CGFloat yPosition = 0.0;
        if (self.wiretype == MA5TYPE) {
            value = model.MA5;
        }
       if (self.wiretype == MA10TYPE)
        {
            value = model.MA10;
        }
        if (self.wiretype == MA20TYPE)
        {
            value = model.MA20;
        }
        if (self.wiretype == MACDDIFF) {
            value = model.DIF;
        }
        if (self.wiretype == MACDDEA) {
            value = model.DEA;
        }
        if (self.wiretype == KDJ_K) {
            if (model.K > 0) {
             value = @(model.K);
            }
        }
        if (self.wiretype == KDJ_D) {
            if (model.D > 0) {
               value = @(model.D);
            }
        }
        if (self.wiretype == KLINE_WR) {
                value = @(model.WR);
        }
        if (!IsObjectNull(value)) {
            CGFloat xPosition = self.startIndex + ((self.candleWidth  + self.candleSpace) * i) + self.candleWidth/2;
            if (self.klineWiretype == Main) {
                 yPosition = ((self.maxValue - [value floatValue]) * self.heightPerpoint) + topDistance;
            }
            else if (self.klineWiretype == Sub)
            {
                yPosition = ABS((self.maxValue - [value floatValue])/self.heightPerpoint) +  self.totalHeight + midDistance; 
            }
           
            postionPoint = CGPointMake(xPosition, yPosition);
            [dictionary setValue:[NSString stringWithFormat:@"%f",postionPoint.x] forKey:@"x"];
            [dictionary setValue:[NSString stringWithFormat:@"%f",postionPoint.y] forKey:@"y"];
            [postions addObject:dictionary];
        }
    }
    return postions;
}

- (void)drawWireLine:(NSMutableArray *)postions
{
    UIBezierPath * path = [UIBezierPath drawWireLine:postions];
    self.path = path.CGPath;
    struct CGColor *strokeColor = nil;
    strokeColor = self.color.CGColor;
    self.strokeColor = strokeColor;
    self.fillColor = [UIColor clearColor].CGColor;
}

@end
