//
//  KLineSubCalculate.m
//  ABuKLineChartView
//
//  Created by jefferson on 2018/7/19.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "KLineSubCalculate.h"
#import "KLineModel.h"

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


@end
