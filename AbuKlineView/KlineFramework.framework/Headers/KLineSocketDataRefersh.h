//
//  KLineSocketDataRefersh.h
//  ABuKLineChartView
//
//  Created by jefferson on 2018/7/20.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineModel.h"
@protocol KLineSocketDataRefershDelegate <NSObject>

- (void)refreshNewKlineModel:(KLineModel *)newKlineModel;

@end

@interface KLineSocketDataRefersh : NSObject
@property (nonatomic, weak) id<KLineSocketDataRefershDelegate> delegate;
+ (instancetype)sharedInstance;
- (void)refreshNewKlineModelWithNewPrice:(double)newPrice timestamp:(NSInteger)timestamp time:(NSString *)time volumn:(NSNumber *)volumn dataArray:(NSMutableArray<KLineModel *> *)dataArray currentType:(NSString *)type;

@end
