//
//  AbuCalculate.m
//  AbuKlineView
//
//  Created by jefferson on 2018/7/12.
//  Copyright © 2018年 阿布. All rights reserved.
//

#import "AbuCalculate.h"

@implementation AbuCalculate
static id _instance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (NSDictionary *)calculateMaxAndMinValueWithDataArr:(NSArray *)dataArr
{
    NSMutableArray *calculateArr  = [NSMutableArray array];
    for (NSObject *item in dataArr) {
        if ([item isKindOfClass:[NSArray class]]) {
            
            [calculateArr addObjectsFromArray:(NSArray *)item];
        }else{
            
            [calculateArr addObject:item];
        }
    }
    __block double maxValue = 0;
    __block double minValue = 0;
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    [calculateArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        double value = [obj doubleValue];
        if (idx==0) {
            
            maxValue = value;
            minValue = value;
        }else{
            
            if (value>maxValue) {
                maxValue = value;
            }else if (value<minValue)
            {
                minValue = value;
            }
        }
        
    }];
    resultDic[kMaxValue] = @(maxValue);
    resultDic[kMinValue] = @(minValue);
    return [resultDic copy];
}

- (NSInteger)getTimesampIntervalWithRequestType:(NSString *)requestType timesamp:(NSInteger)lastKlineModelTimesamp
{
    NSInteger timesampInterval = 0;
    if ([requestType isEqualToString:@"M1"]) {
        timesampInterval = 60*1;
    }else if ([requestType isEqualToString:@"M5"])
    {
        timesampInterval = 60*5;
    }else if ([requestType isEqualToString:@"M15"])
    {
        timesampInterval = 60*15;
    }else if ([requestType isEqualToString:@"M30"])
    {
        timesampInterval = 60*30;
    }else if ([requestType isEqualToString:@"H1"])
    {
        timesampInterval = 60*60;
    }else if ([requestType isEqualToString:@"H4"])
    {
        timesampInterval = 4*60*60;
    }
    else if ([requestType isEqualToString:@"D1"])
    {
        timesampInterval = 60*60*24;
    }else if ([requestType isEqualToString:@"W1"])
    {
        timesampInterval = 60*60*24*7;
    }else if ([requestType isEqualToString:@"MN"])
    {
        
        NSDate*lastDate = [NSDate dateWithTimeIntervalSince1970:lastKlineModelTimesamp];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:lastDate];
        NSInteger year  = [components year];
        NSInteger month = [components month];
        
        
        if (month == 1||month == 3||month==5||month == 7||month==8||month == 10||month==12) {
            //31
            timesampInterval = 60*60*31;
        }else if (month==2)
        {
            
            if ([self bissextile:year]) {
                //闰年
                timesampInterval = 60*60*24*29;
            }else{
                timesampInterval = 60*60*24*28;
            }
            
        }else{
            //30
            timesampInterval = 60*60*24*30;
        }
        
    }
    return timesampInterval;
}
-(BOOL)bissextile:(NSInteger)year {
    if ((year%4==0 && year %100 !=0) || year%400==0) {
        return YES;
    }else {
        return NO;
    }
    return NO;
}

@end
