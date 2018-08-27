//
//  KlineDataReformer.m
//  ExchangeKline
//
//  Created by jefferson on 2018/8/3.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "KlineDataReformer.h"
#import "KlineCandleDataReformer.h"
#import "KLineSubCalculate.h"


@implementation KlineDataReformer

static id _instance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

- (id)copy{
    return self;
}

- (id)mutableCopy{
    return self;
}

- (NSArray<KLineModel *> *)coverToOriginalDataArray:(NSArray *)dataArray currentRequestType:(NSString *)currentRequestType KPIType:(SubKPIType)type
{
    self.currentRequestType = currentRequestType;
    if (IsArrayNull(dataArray)) {
        return nil;
    }
    NSArray <KLineModel *>*candleTransformerDataArray = [[KlineCandleDataReformer sharedInstance] coverToDataArr:dataArray currentRequestType:currentRequestType];

    NSArray <KLineModel *>*quotaInitDataArray = [[KLineSubCalculate sharedInstance] initializeQuotaDataWithArray:candleTransformerDataArray KPIType:type];
    return quotaInitDataArray;
}

@end
