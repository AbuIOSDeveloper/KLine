//
//  KlineTimeLayer.m
//  ABuKLineChartView
//
//  Created by jefferson on 2018/9/7.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "KlineTimeLayer.h"

@interface KlineTimeLayer()
@property (nonatomic, strong) NSArray  *               klineDataSource;
@property (nonatomic,assign) double                      height;
@property (nonatomic,assign) CGFloat                    candleWidth;
@property (nonatomic,assign) double                      timeHeight;
@property (nonatomic,assign) double                      bottomMargin;
@property (nonatomic,assign) double                      lineWidth;

@end

@implementation KlineTimeLayer

- (instancetype)initQuotaDataArr:(NSArray *)dataArr candleWidth:(CGFloat)candleWidth height:(CGFloat)height timeHight:(CGFloat)timeHeight bottomMargin:(CGFloat)bottomMargin lineWidth:(CGFloat)lineWidth
{
    self = [super init];
    if (self) {
        self.klineDataSource = dataArr;
        self.candleWidth = candleWidth;
        self.height = height;
        self.timeHeight = timeHeight;
        self.bottomMargin = bottomMargin;
        self.lineWidth = lineWidth;
        [self drawTimeLayer];
    }
    return self;
}

- (void)drawTimeLayer
{
    [self.klineDataSource enumerateObjectsUsingBlock:^(KLineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (model.isDrawDate)
        {
            CATextLayer *layer = [self getTextLayer];
            layer.string = model.timeStr;
            if (model.highestPoint.x <= 0.00001f)
            {
                layer.frame =  CGRectMake(0, self.height - timeheight, 80, timeheight);
                
            }
            
            else
            {
                layer.position = CGPointMake(model.highestPoint.x + self.candleWidth, self.height - timeheight/2 - self.bottomMargin);
                layer.bounds = CGRectMake(0, 0, 80, timeheight);
                
            }
            [self addSublayer:layer];
            
            CAShapeLayer *lineLayer = [self getAxispLayer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            path.lineWidth = self.lineWidth;
            lineLayer.lineWidth = self.lineWidth;
            
            [path moveToPoint:CGPointMake(model.highestPoint.x + self.candleWidth/2 - self.lineWidth/2, 1*heightradio)];
            [path addLineToPoint:CGPointMake(model.highestPoint.x + self.candleWidth/2 - self.lineWidth/2 ,self.height - timeheight- self.bottomMargin)];
            lineLayer.path = path.CGPath;
            lineLayer.lineDashPattern = @[@6,@10];
            [self addSublayer:lineLayer];
        }
    }];
}

- (CATextLayer*)getTextLayer
{
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.fontSize = 12.f;
    layer.alignmentMode = kCAAlignmentLeft;
    layer.foregroundColor =
    [UIColor grayColor].CGColor;
    return layer;
}

- (CAShapeLayer*)getAxispLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithHexString:@"#ededed"].CGColor;
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

@end
