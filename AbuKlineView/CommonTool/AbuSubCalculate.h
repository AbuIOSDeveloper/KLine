//
//  AbuSubCalculate.h
//  AbuKlineView
//
//  Created by jefferson on 2018/7/12.
//  Copyright © 2018年 阿布. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SubATR = 0,
    SubBIAS = 1,
    SubCCI = 2,
    SubKD = 3,
    SubMACD = 4,
    SubRSI = 5,
    SubW_R = 6,
    SubARBR = 7,
    SubDKBY = 8,
    SubKDJ = 9,
    SubLW_R = 10, ///< _ -> &
    SubQHLSR = 11,
}SubKPIType;

@interface AbuSubCalculate : NSObject

+ (instancetype)sharedInstance;
- (void)handleQuotaDataWithDataArr:(NSArray *)dataArr model:(AbuChartCandleModel *)model index:(NSInteger)idx KPIType:(SubKPIType)type;;
- (NSArray <AbuChartCandleModel *>*)initializeQuotaDataWithArray:(NSArray <AbuChartCandleModel *>*)dataArray KPIType:(SubKPIType)type;;

@end
