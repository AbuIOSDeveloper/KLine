//
//  KlineCandleDataReformer.m
//  ExchangeKline
//
//  Created by jefferson on 2018/8/3.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "KlineCandleDataReformer.h"

@interface KlineCandleDataReformer()

@property (nonatomic,strong) NSString *currentRequestType;

@end

@implementation KlineCandleDataReformer
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

- (NSArray<KLineModel *> *)coverToDataArr:(NSArray *)dataArr currentRequestType:(NSString *)currentRequestType
{
    self.currentRequestType = currentRequestType;

    NSMutableArray *tempArr = [NSMutableArray array];
    
    [dataArr enumerateObjectsUsingBlock:^(KLineModel * candleModel, NSUInteger idx, BOOL * _Nonnull stop) {
        KLineModel * model = [KLineModel new];
        model.timestamp = (NSInteger)[self changeTime:candleModel.date];
        model.timeStr = [self setTime:[NSString stringWithFormat:@"%ld",model.timestamp]];
        model.date = candleModel.date;
        model.closePrice = candleModel.closePrice;
        model.openPrice = candleModel.openPrice;
        model.highPrice = candleModel.highPrice;
        model.lowPrice = candleModel.lowPrice;
        model.volumn = candleModel.volumn;
        model.isDrawDate = candleModel.isDrawDate;
        model.xPoint = idx;
        [tempArr addObject:model];
    }];
    return tempArr;
}

- (long)changeTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *lastDate = [formatter dateFromString:time];
    long firstStamp = [lastDate timeIntervalSince1970];
    return firstStamp;
}

-(NSString*)setTime:(NSString*)time{
    
    NSString *format = nil;
    if ([self.currentRequestType containsString:@"D"]||[self.currentRequestType containsString:@"W"]||[self.currentRequestType isEqualToString:@"MN"]) {
        format = @"MM-dd";
    }else if ([self.currentRequestType containsString:@"M"] || [self.currentRequestType containsString:@"H"]  || [self.currentRequestType containsString:@"M1"])
    {
        format = @"MM-dd HH:mm";
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
