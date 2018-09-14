//
//  KLineSubCalculate.m
//  ABuKLineChartView
//
//  Created by jefferson on 2018/7/19.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "KLineSubCalculate.h"

static NSString *const kRise = @"kRise";
static NSString *const kDrop = @"kDrop";

@implementation KLineSubCalculate

static id _instance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (NSArray <KLineModel *>*)initializeQuotaDataWithArray:(NSArray <KLineModel *>*)dataArray KPIType:(SubKPIType)type
{
    __weak typeof(self) weakSelf = self;
    [dataArray enumerateObjectsUsingBlock:^(KLineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [weakSelf handleQuotaDataWithDataArr:dataArray model:model index:idx KPIType:type];
        
    }];
    return dataArray;
}

- (void)handleQuotaDataWithDataArr:(NSArray *)dataArr model:(KLineModel *)model index:(NSInteger)idx KPIType:(SubKPIType)type
{
    if (type == SubMACD) {
        [self calculateMACDWithDataArr:dataArr model:model index:idx];
        [self calculateKDWithDataArr:dataArr model:model index:idx];
        [self calculateWRWithDataArr:dataArr model:model index:idx];
        [self calculateMAWithDataArr:dataArr num:5 model:model index:idx];
        [self calculateMAWithDataArr:dataArr num:10 model:model index:idx];
        [self calculateMAWithDataArr:dataArr num:20 model:model index:idx];
        
    }
}

- (void)calculateMACDWithDataArr:(NSArray *)dataArr model:(KLineModel *)model index:(NSInteger)idx
{
    KLineModel *previousKlineModel = [KLineModel new];
    if (idx>0&&idx<dataArr.count) {
        
        previousKlineModel = dataArr[idx-1];
    }
    model.previousKlineModel = previousKlineModel;
    [model reInitData];
}

- (void)calculateMAWithDataArr:(NSArray *)dataArr num:(NSInteger)num model:(KLineModel *)model index:(NSInteger)idx
{
 
        CGFloat sum = 0;
        if (idx>=num-1) {
            for (int i = 0; i<num; i++) {
                KLineModel *model = dataArr[idx - i];
                sum += model.closePrice;
            }
            double value = sum/num;
            if (num == 5) {
                model.MA5 = @(value);
            }
            else if (num == 10)
            {
                model.MA10 = @(value);
            }
            else if (num == 20)
            {
                model.MA20 = @(value);
            }
            
        }

}

- (void)calculateKDJWithDataArr:(NSArray *)dataArr model:(KLineModel *)model index:(NSInteger)idx
{
    NSInteger num = 9;
    if (idx>=num-1) {
        NSMutableArray *previousNineKlineModelArr = [NSMutableArray array];
        for (NSInteger i = idx-(num-1); i<=idx; i++) {
            
            if (i>=0&&i<dataArr.count) {
                KLineModel *model = dataArr[i];
                [previousNineKlineModelArr addObject:@(model. highPrice)];
                [previousNineKlineModelArr addObject:@(model.lowPrice)];
            }
        }
        NSDictionary *resultDic = [[KLineCalculate sharedInstance] calculateMaxAndMinValueWithDataArr:previousNineKlineModelArr];
        model.HNinePrice = resultDic[kMaxValue];
        model.LNinePrice = resultDic[kMinValue];
        [model reInitKDJData];
    }
}

- (double)HHV_dataArray:(NSArray *)dataArray
                      N:(NSInteger)N
             currentDay:(NSInteger)currentDay{
    double result = 0;
    if (currentDay < N - 1) {
        for (NSInteger i = 0; i <= currentDay ; i++) {
            KLineModel *model = dataArray[i];
            result = MAX(model.closePrice, MAX(model.openPrice, MAX(model.highPrice, model.lowPrice)));
        }
    } else {
        for (NSInteger i = currentDay - N + 1; i <= currentDay ; i++) {
            KLineModel *model = dataArray[i];
            result = MAX(model.closePrice, MAX(model.openPrice, MAX(model.highPrice, model.lowPrice)));
        }
    }
    return result;
};

- (double)LLV_dataArray:(NSArray *)dataArray
                      N:(NSInteger)N
             currentDay:(NSInteger)currentDay{
    double result = MAXFLOAT;
    if (currentDay < N - 1) {
        for (NSInteger i = 0; i <= currentDay ; i++) {
            KLineModel *model = dataArray[i];
            result = MIN(model.closePrice, MIN(model.openPrice, MIN(model.highPrice, model.lowPrice)));
        }
    } else {
        for (NSInteger i = currentDay - N + 1; i <= currentDay ; i++) {
            KLineModel *model = dataArray[i];
            result = MIN(model.closePrice, MIN(model.openPrice, MIN(model.highPrice, model.lowPrice)));
        }
    }
    return result;
};

- (void)calculateKDWithDataArr:(NSArray *)dataArr model:(KLineModel *)model index:(NSInteger)idx
{
    int N = 9;
    int M1 = 3;
    int M2 = 3;
    
    double RSV = 0;
    double K = 0;
    double D = 0;
    double lowPrice = MAXFLOAT;
    double highPrice = 0;
    if (idx < N - 1) {
        lowPrice = [self getHighPrice:dataArr currentIdx:idx aveg:N isMax:NO];
        highPrice = [self getHighPrice:dataArr currentIdx:idx aveg:N isMax:YES];
    }
    else
    {
        for (NSInteger i = idx - N + 1; i <= idx ; i++) {
            lowPrice = [self getHighPrice:dataArr currentIdx:idx aveg:N isMax:NO];
            highPrice = [self getHighPrice:dataArr currentIdx:idx aveg:N isMax:YES];
            RSV = (model.closePrice - lowPrice) * 100 / (highPrice - lowPrice);
            model.RSV = RSV;

            K = [self getRSVWithDataArray:dataArr currentDay:idx aveDay:M1];
            model.K = K;

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
            KLineModel * model = dataArray[j];
            if (isMax) {
                [resultArray addObject:[NSNumber numberWithDouble:model.highPrice]];
            }
            else
            {
                [resultArray addObject:[NSNumber numberWithDouble:model.lowPrice]];
            }
        }
    } else {
        for (NSInteger j = idx - aveDay + 1; j <= idx; j++) {
            KLineModel * model = dataArray[j];
            if (isMax) {
                [resultArray addObject:[NSNumber numberWithDouble:model.highPrice]];
            }
            else
            {
                [resultArray addObject:[NSNumber numberWithDouble:model.lowPrice]];
            }
            
        }
    }
    NSDictionary *resultDic = [[KLineCalculate sharedInstance] calculateMaxAndMinValueWithDataArr:@[resultArray]];
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
            KLineModel * model = dataArray[j];
            result += model.RSV;
        }
        result = result / (currentDay + 1);
    } else {
        for (NSInteger j = currentDay - aveDay + 1; j <= currentDay; j++) {
            KLineModel * model = dataArray[j];
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
            KLineModel * model = dataArray[j];
            result += model.K;
        }
        result = result / (currentDay + 1);
    } else {
        for (NSInteger j = currentDay - aveDay + 1; j <= currentDay; j++) {
            KLineModel * model = dataArray[j];
            result += model.K;
        }
        result = result / aveDay;
    }
    return result;
}

#pragma mark - WR
- (void)calculateWRWithDataArr:(NSArray *)dataArr model:(KLineModel *)model index:(NSInteger)idx
{
    NSInteger N = 14;
    double lowPrice = MAXFLOAT;
    double highPrice = 0;     
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
    
    model.WR = (highPrice - model.closePrice) * 100 / (highPrice - lowPrice);
}


@end
