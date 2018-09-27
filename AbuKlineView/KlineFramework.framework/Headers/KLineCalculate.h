//
//  KLineCalculate.h
//  ABuKLineChartView
//
//  Created by jefferson on 2018/7/19.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kMaxValue = @"kMaxValue";
static NSString *const kMinValue = @"kMinValue";

@interface KLineCalculate : NSObject

+ (instancetype)sharedInstance;

- (NSDictionary *)calculateMaxAndMinValueWithDataArr:(NSArray *)dataArr;

- (NSInteger)getTimesampIntervalWithRequestType:(NSString *)requestType timesamp:(NSInteger)lastKlineModelTimesamp;

@end
