//
//  KlineVerticalView.m
//  ABuKLineChartView
//
//  Created by jefferson on 2018/9/14.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "KlineVerticalView.h"

#define timeLableheight 20

@interface KlineVerticalView()

@property (nonatomic,assign) UIInterfaceOrientation         orientation;

@property (nonatomic,strong) UILabel                           * timeLabel;

@property (nonatomic,strong) CAShapeLayer                 * vereticalLineLayer;

@end

@implementation KlineVerticalView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self buildUI];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)buildUI
{
    [self buildVerticalLineWithCandleHeight:self.candleChartHeight];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(self.candleChartHeight+(timeLableheight-14)/2);
        make.height.mas_equalTo(14);
        make.centerX.mas_equalTo(self);
    }];
    self.timeLabel.text = @"00:00";
}

- (void)buildVerticalLineWithCandleHeight:(CGFloat)candleChartHeight
{
    [self.vereticalLineLayer removeFromSuperlayer];
    self.vereticalLineLayer = nil;
    self.vereticalLineLayer = [CAShapeLayer layer];
    UIBezierPath *topLine = [UIBezierPath bezierPath];
    [topLine moveToPoint:CGPointMake(0,0)];
    [topLine addLineToPoint:CGPointMake(0,candleChartHeight)];
    self.vereticalLineLayer.lineWidth = 1;
    self.vereticalLineLayer.path = topLine.CGPath;
    self.vereticalLineLayer.lineDashPattern = @[@4, @4];
    self.vereticalLineLayer.strokeColor = [UIColor orangeColor].CGColor;
    [self.layer addSublayer:self.vereticalLineLayer];
}

#pragma mark - PublicMethods
- (void)updateTimeString:(NSString *)timeString
{
    NSLog(@"%@",timeString);
    self.timeLabel.text = timeString;
}

- (void)updateTimeLeft:(CGFloat)leftdistance
{
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(leftdistance);
    }];
}

- (void)updateHeight:(CGFloat)candleChartHeight
{
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self).offset(candleChartHeight+(timeLableheight-14)/2);
    }];
    [self buildVerticalLineWithCandleHeight:candleChartHeight];
}
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    self.orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
    
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self).offset(self.candleChartHeight+(timeLableheight-14)/2);
        }];
        [self buildVerticalLineWithCandleHeight:self.candleChartHeight];
    }
    if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self).offset(self.candleChartHeight+(timeLableheight-14)/2);
        }];
        [self buildVerticalLineWithCandleHeight:self.candleChartHeight];
    }
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:9];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor colorWithHexString:@"#608fd8"];
    }
    return _timeLabel;
}
- (UIInterfaceOrientation)orientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}
- (CGFloat)candleChartHeight
{
    CGFloat HEIGH = 0;
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        HEIGH = ChartViewHigh - 20;
    }
    if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        
        HEIGH = LandscapeChartViewHigh - 20;
    }
    return HEIGH;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
