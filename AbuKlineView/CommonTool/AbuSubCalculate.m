//
//  AbuSubCalculate.m
//  AbuKlineView
//
//  Created by jefferson on 2018/7/12.
//  Copyright © 2018年 阿布. All rights reserved.
//

#import "AbuSubCalculate.h"
static NSString *const kRise = @"kRise";
static NSString *const kDrop = @"kDrop";

@interface AbuSubCalculate()

@end

@implementation AbuSubCalculate
static id _instance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (NSArray <AbuChartCandleModel *>*)initializeQuotaDataWithArray:(NSArray <AbuChartCandleModel *>*)dataArray KPIType:(SubKPIType)type
{
    __weak typeof(self) weakSelf = self;
    [dataArray enumerateObjectsUsingBlock:^(AbuChartCandleModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [weakSelf handleQuotaDataWithDataArr:dataArray model:model index:idx KPIType:type];
        
    }];
    return dataArray;
}

- (void)handleQuotaDataWithDataArr:(NSArray *)dataArr model:(AbuChartCandleModel *)model index:(NSInteger)idx KPIType:(SubKPIType)type
{
    if (type == SubMACD) {
        //MACD
        [self calculateMACDWithDataArr:dataArr model:model index:idx];
        [self calculateKDWithDataArr:dataArr model:model index:idx];
        [self calculateWRWithDataArr:dataArr model:model index:idx];
    }
}

//MACD
- (void)calculateMACDWithDataArr:(NSArray *)dataArr model:(AbuChartCandleModel *)model index:(NSInteger)idx
{
    AbuChartCandleModel *previousKlineModel = [AbuChartCandleModel new];
    if (idx>0&&idx<dataArr.count) {
        
        previousKlineModel = dataArr[idx-1];
    }
    model.previousKlineModel = previousKlineModel;
    [model reInitData];
}


//KDJ
- (void)calculateKDJWithDataArr:(NSArray *)dataArr model:(AbuChartCandleModel *)model index:(NSInteger)idx
{
    NSInteger num = 9;
    if (idx>=num-1) {
        NSMutableArray *previousNineKlineModelArr = [NSMutableArray array];
        for (NSInteger i = idx-(num-1); i<=idx; i++) {
            
            if (i>=0&&i<dataArr.count) {
                AbuChartCandleModel *model = dataArr[i];
                [previousNineKlineModelArr addObject:@(model. high)];
                [previousNineKlineModelArr addObject:@(model.low)];
            }
        }
        NSDictionary *resultDic = [[AbuCalculate sharedInstance] calculateMaxAndMinValueWithDataArr:previousNineKlineModelArr];
        model.HNinePrice = resultDic[kMaxValue];
        model.LNinePrice = resultDic[kMinValue];
        [model reInitKDJData];
    }
}

// HHV
- (double)HHV_dataArray:(NSArray *)dataArray
                      N:(NSInteger)N
             currentDay:(NSInteger)currentDay{
    double result = 0;
    if (currentDay < N - 1) {
        for (NSInteger i = 0; i <= currentDay ; i++) {
            AbuChartCandleModel *model = dataArray[i];
            result = MAX(model.close, MAX(model.open, MAX(model.high, model.low)));
        }
    } else {
        for (NSInteger i = currentDay - N + 1; i <= currentDay ; i++) {
            AbuChartCandleModel *model = dataArray[i];
            result = MAX(model.close, MAX(model.open, MAX(model.high, model.low)));
        }
    }
    return result;
};

// LLV
- (double)LLV_dataArray:(NSArray *)dataArray
                      N:(NSInteger)N
             currentDay:(NSInteger)currentDay{
    double result = MAXFLOAT;
    if (currentDay < N - 1) {
        for (NSInteger i = 0; i <= currentDay ; i++) {
            AbuChartCandleModel *model = dataArray[i];
            result = MIN(model.close, MIN(model.open, MIN(model.high, model.low)));
        }
    } else {
        for (NSInteger i = currentDay - N + 1; i <= currentDay ; i++) {
            AbuChartCandleModel *model = dataArray[i];
            result = MIN(model.close, MIN(model.open, MIN(model.high, model.low)));
        }
    }
    return result;
};

#pragma mark - KD
- (void)calculateKDWithDataArr:(NSArray *)dataArr model:(AbuChartCandleModel *)model index:(NSInteger)idx
{
    //设置三个默认参数
    int N = 9;
    int M1 = 3;
    int M2 = 3;

    double RSV = 0;
    double K = 0;
    double D = 0;
    double lowPrice = MAXFLOAT; //最低价
    double highPrice = 0;       //最高价
    if (idx < N - 1) {
        lowPrice = [self getHighPrice:dataArr currentIdx:idx aveg:N isMax:NO];
        highPrice = [self getHighPrice:dataArr currentIdx:idx aveg:N isMax:YES];
    }
    else
    {
        for (NSInteger i = idx - N + 1; i <= idx ; i++) {
            lowPrice = [self getHighPrice:dataArr currentIdx:idx aveg:N isMax:NO];
            highPrice = [self getHighPrice:dataArr currentIdx:idx aveg:N isMax:YES];
            RSV = (model.close - lowPrice) * 100 / (highPrice - lowPrice);
            model.RSV = RSV;
            
            //K值
            K = [self getRSVWithDataArray:dataArr currentDay:idx aveDay:M1];
            model.K = K;
            
            //D值
            D = [self getKWithDataArray:dataArr currentDay:idx aveDay:M2];
            model.D = D;
        }
    }
}


- (double)getHighPrice:(NSArray *)dataArray currentIdx:(NSInteger)idx aveg:(NSInteger)aveDay isMax:(BOOL)isMax
{
    double result = 0;
    NSMutableArray * resultArray = [NSMutableArray array];
    if (resultArray) {
        [resultArray removeAllObjects];
    }
    if (idx < aveDay - 1) {
        for (NSInteger j = 0; j <= idx; j++) {
            AbuChartCandleModel * model = dataArray[j];
            if (isMax) {
                [resultArray addObject:[NSNumber numberWithDouble:model.high]];
            }
            else
            {
                [resultArray addObject:[NSNumber numberWithDouble:model.low]];
            }
        }
    } else {
        for (NSInteger j = idx - aveDay + 1; j <= idx; j++) {
            AbuChartCandleModel * model = dataArray[j];
            if (isMax) {
                [resultArray addObject:[NSNumber numberWithDouble:model.high]];
            }
            else
            {
                [resultArray addObject:[NSNumber numberWithDouble:model.low]];
            }
            
        }
    }
    NSDictionary *resultDic = [[AbuCalculate sharedInstance] calculateMaxAndMinValueWithDataArr:@[resultArray]];
    if (isMax) {
        result = [resultDic[kMaxValue] floatValue];
    }
    else
    {
        result = [resultDic[kMinValue] floatValue];
    }
    return  result;
}

- (double)getRSVWithDataArray:(NSArray *)dataArray
                   currentDay:(NSInteger)currentDay
                       aveDay:(NSInteger)aveDay{
    double result = 0;
    if (currentDay < aveDay - 1) {
        for (NSInteger j = 0; j <= currentDay; j++) {
            AbuChartCandleModel * model = dataArray[j];
            result += model.RSV;
        }
        result = result / (currentDay + 1);
    } else {
        for (NSInteger j = currentDay - aveDay + 1; j <= currentDay; j++) {
            AbuChartCandleModel * model = dataArray[j];
            result += model.RSV;
        }
        result = result / aveDay;
    }
    return result;
}

- (double)getKWithDataArray:(NSArray *)dataArray
                 currentDay:(NSInteger)currentDay
                     aveDay:(NSInteger)aveDay{
    double result = 0;
    if (currentDay < aveDay - 1) {
        for (NSInteger j = 0; j <= currentDay; j++) {
            AbuChartCandleModel * model = dataArray[j];
            result += model.K;
        }
        result = result / (currentDay + 1);
    } else {
        for (NSInteger j = currentDay - aveDay + 1; j <= currentDay; j++) {
            AbuChartCandleModel * model = dataArray[j];
            result += model.K;
        }
        result = result / aveDay;
    }
    return result;
}

#pragma mark - WR
- (void)calculateWRWithDataArr:(NSArray *)dataArr model:(AbuChartCandleModel *)model index:(NSInteger)idx
{
    //设置参数
    NSInteger N = 14;
    double lowPrice = MAXFLOAT; //最低价
    double highPrice = 0;       //最高价
    if (idx < N - 1) {
        lowPrice = [self getHighPrice:dataArr currentIdx:idx aveg:N isMax:NO];
        highPrice = [self getHighPrice:dataArr currentIdx:idx aveg:N isMax:YES];
    }
    else
    {
        for (NSInteger i = idx - N + 1; i <= idx ; i++) {
            lowPrice = [self getHighPrice:dataArr currentIdx:idx aveg:N isMax:NO];
            highPrice = [self getHighPrice:dataArr currentIdx:idx aveg:N isMax:YES];
        }
    }
    
    model.WR = (highPrice - model.close) * 100 / (highPrice - lowPrice);
}


@end
