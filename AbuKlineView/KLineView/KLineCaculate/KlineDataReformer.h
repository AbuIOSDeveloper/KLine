//
//  KlineDataReformer.h
//  ExchangeKline
//
//  Created by jefferson on 2018/8/3.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineModel.h"

@interface KlineDataReformer : NSObject

+ (instancetype)sharedInstance;
- (NSArray <KLineModel *>*)coverToOriginalDataArray:(NSArray *)dataArray currentRequestType:(NSString *)currentRequestType KPIType:(SubKPIType)type;
@property (nonatomic,strong) NSString *currentRequestType;

@end
