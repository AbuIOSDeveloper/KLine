//
//  KLineSocketDataRefersh.m
//  ABuKLineChartView
//
//  Created by jefferson on 2018/7/20.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "KLineSocketDataRefersh.h"

@interface KLineSocketDataRefersh()

@property (nonatomic, strong)NSString      * currentRequestType;

@end

@implementation KLineSocketDataRefersh

static id _instance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

- (void)refreshNewKlineModelWithNewPrice:(double)newPrice timestamp:(NSInteger)timestamp time:(NSString *)time volumn:(NSNumber *)volumn dataArray:(NSMutableArray<KLineModel *> *)dataArray currentType:(NSString *)type
{
    self.currentRequestType = type;
    KLineModel *lastKlineModel = dataArray.lastObject;
    
    KLineModel *newKlineMlodel = nil;
    
    NSInteger shouldAddTimestamp = [[KLineCalculate sharedInstance] getTimesampIntervalWithRequestType:self.currentRequestType timesamp:lastKlineModel.timestamp];
    
    NSInteger shouldShortTimestamp =  [self transformTimestampWithTimestamp:timestamp requestType:self.currentRequestType];
    
     NSInteger totalTimeTamp = lastKlineModel.timestamp+shouldAddTimestamp;
    
    if (((timestamp >= lastKlineModel.timestamp)&&(timestamp < totalTimeTamp))) {
        newKlineMlodel = [KLineModel new];
        newKlineMlodel.openPrice = lastKlineModel.openPrice;
        newKlineMlodel.closePrice = newPrice;
        
        if (newPrice>lastKlineModel.highPrice) {
            
            newKlineMlodel.highPrice = newPrice;
            
        }else{
            
            newKlineMlodel.highPrice = lastKlineModel.highPrice;
        }
        if (newPrice<lastKlineModel.lowPrice) {
            
            newKlineMlodel.lowPrice = newPrice;
            
        }else{
            
            newKlineMlodel.lowPrice = lastKlineModel.lowPrice;
        }
        newKlineMlodel.xPoint = lastKlineModel.xPoint;
        newKlineMlodel.isNew = NO;
        newKlineMlodel.timestamp = timestamp-shouldShortTimestamp;
        newKlineMlodel.timeStr = [self setTime:[NSString stringWithFormat:@"%ld",newKlineMlodel.timestamp]];
        if (!volumn) {
            newKlineMlodel.volumn = @"0";
        }else{
            newKlineMlodel.volumn = [NSString stringWithFormat:@"%lf",[volumn floatValue]];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshNewKlineModel:)]) {
            [self.delegate refreshNewKlineModel:newKlineMlodel];
        }
    }
    else
    {
        newKlineMlodel = [KLineModel new];
        newKlineMlodel.timestamp = timestamp-shouldShortTimestamp;
        newKlineMlodel.timeStr = [self setTime:[NSString stringWithFormat:@"%ld",newKlineMlodel.timestamp]];
        newKlineMlodel.xPoint = lastKlineModel.xPoint+1;
        newKlineMlodel.openPrice = newPrice;
        newKlineMlodel.closePrice = newPrice;
        newKlineMlodel.highPrice = newPrice;
        newKlineMlodel.lowPrice = newPrice;
        newKlineMlodel.volumn = @"0";
        newKlineMlodel.isNew = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshNewKlineModel:)]) {
        [self.delegate refreshNewKlineModel:newKlineMlodel];
    }
}


- (NSInteger)transformTimestampWithTimestamp:(NSInteger)timestamp requestType:(NSString *)requestType
{
    NSDate*lastDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekday|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:lastDate];
    NSInteger weekday = [components weekday];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    
    NSInteger timesampInterval = 0;
    if ([requestType isEqualToString:@"M1"]) {
        timesampInterval = second;
    }else if ([requestType isEqualToString:@"M5"])
    {
        timesampInterval = (minute%5*60+second);
    }else if ([requestType isEqualToString:@"M15"])
    {
        timesampInterval = (minute%15*60+second);
    }else if ([requestType isEqualToString:@"M30"])
    {
        timesampInterval = (minute%30*60+second);
    }else if ([requestType isEqualToString:@"H1"])
    {
        timesampInterval = (minute*60+second);
    }else if ([requestType isEqualToString:@"D1"])
    {
        timesampInterval = (hour*60*60+minute*60+second);
    }else if ([requestType isEqualToString:@"W1"])
    {
        timesampInterval = ((weekday-1)*24*60*60+hour*60*60+minute*60+second);
    }else if ([requestType isEqualToString:@"MN"])
    {
        
        timesampInterval = ((day-1)*24*60*60+hour*60*60+minute*60+second);
        NSLog(@"减去的MN时间为:%ld",(long)((day-1)*24*60*60+hour*60*60+minute*60+second));
    }
    return timesampInterval;
}

-(NSString*)setTime:(NSString*)time{
    
    NSString *format = nil;
    if ([self.currentRequestType containsString:@"D"]||[self.currentRequestType containsString:@"W"]||[self.currentRequestType isEqualToString:@"MN"]) {
        format = @"MMdd";
    }else if ([self.currentRequestType containsString:@"M"]||[self.currentRequestType containsString:@"H"])
    {
        format = @"MMdd HH:mm";
    }
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    int timeval = [time intValue];
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeval];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}


@end
