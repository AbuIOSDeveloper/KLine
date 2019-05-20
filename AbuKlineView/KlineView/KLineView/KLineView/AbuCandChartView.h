//
//  AbuCandChartView.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbuCandChartView : UIView
@property (nonatomic,strong) NSMutableArray<__kindof KLineModel*> * dataArray;
@property (nonatomic,assign) CGFloat          candleSpace;
@property (nonatomic,assign) CGFloat          candleWidth;
@property (nonatomic,assign) NSInteger        currentStartIndex;
@property (nonatomic,assign) CGFloat          contentOffset;
@property (nonatomic,assign) BOOL             kvoEnable;
@property (nonatomic,assign) BOOL             hollowRise;

- (CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion;
- (void)reloadKline;
- (void)calcuteCandleWidth;
- (void)updateWidth;
- (void)drawKLine;
- (void)drawPresetQuota:(KlineSubKPIType)presetQuotaName;
- (void)refreshKLineView:(KLineModel *)model;
@property (nonatomic,weak) id <AbuChartViewProtocol> delegate;
@property (nonatomic,assign) DataLineType currentType;
@end
