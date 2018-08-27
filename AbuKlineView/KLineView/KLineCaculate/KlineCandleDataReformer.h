//
//  KlineCandleDataReformer.h
//  ExchangeKline
//
//  Created by jefferson on 2018/8/3.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KlineCandleDataReformer : NSObject

+ (instancetype)sharedInstance;

- (NSArray<KLineModel *>*)coverToDataArr:(NSArray *)dataArr currentRequestType:(NSString *)currentRequestType;

@end
