//
//  AbuChartCandleModel.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuChartCandleModel.h"

static NSString *const kRise = @"kRise";
static NSString *const kDrop = @"kDrop";

@interface AbuChartCandleModel()


@end

@implementation AbuChartCandleModel

- (void)initData
{
    
    [self EMA12];
    [self EMA26];
    [self DIF];
    [self DEA];
    [self MACD];
}

//在最新的蜡烛数据来的时候需要重新每次计算
- (void)reInitData
{
    NSInteger SHORT = 12;
    NSInteger LONG = 26;
    NSInteger M = 9;

    self.EMA12 = @((2.0 * self.close + (SHORT - 1) *(self.previousKlineModel.EMA12.doubleValue))/(SHORT + 1));
    self.EMA26 = @((2 * self.close + (LONG -1) * self.previousKlineModel.EMA26.doubleValue)/(LONG + 1));
    self.DIF = @(self.EMA12.doubleValue - self.EMA26.doubleValue);
    self.DEA = @(self.previousKlineModel.DEA.doubleValue * (M-1)/(M+1) + 2.0 / (M+1) *self.DIF.doubleValue);
    self.MACD = @(2*(self.DIF.doubleValue - self.DEA.doubleValue));
    
}



//KDJ
- (void)reInitKDJData
{
    
    self.RSV_9 = @((self.close - self.LNinePrice.doubleValue)/(self.HNinePrice.doubleValue-self.LNinePrice.doubleValue)*100);
    
    
    double previousK = 0;
    if (self.xPoint==8) {
        
        previousK = 50;
    }else{
        previousK = self.previousKlineModel.KDJ_K.doubleValue;
    }
    self.KDJ_K = @(previousK*2/3.0+1/3.0*self.RSV_9.doubleValue);
    
    
    double previousD = 0;
    if (self.xPoint==8) {
        
        previousD = 50;
    }else{
        previousD = self.previousKlineModel.KDJ_D.doubleValue;
    }
    self.KDJ_D = @(previousD*2/3.0+1/3.0*self.KDJ_K.doubleValue);
    
    
    self.KDJ_J = @(3*self.KDJ_K.doubleValue-2*self.KDJ_D.doubleValue);
    
    if (isnan(self.KDJ_K.doubleValue)) {
        self.KDJ_K = self.previousKlineModel.KDJ_K;
        
    }
    if (isnan(self.KDJ_D.doubleValue)) {
        
        self.KDJ_D = self.previousKlineModel.KDJ_D;
    }
    if (isnan(self.KDJ_J.doubleValue)) {
        
        self.KDJ_J = self.previousKlineModel.KDJ_J;
    }
}

@end
