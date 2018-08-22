//
//  AbuCandChartView.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbuCandChartView : UIView

@property (nonatomic,assign) CGFloat maxY;

@property (nonatomic,assign) CGFloat minY;

@property (nonatomic,assign) CGFloat maxX;

@property (nonatomic,assign) CGFloat minX;

@property (nonatomic,assign) CGFloat scaleY;

@property (nonatomic,assign) CGFloat scaleX;

@property (nonatomic,assign) CGFloat lineWidth;

@property (nonatomic,assign) CGFloat lineSpace;

@property (nonatomic,assign) CGFloat leftMargin;

@property (nonatomic,assign) CGFloat rightMargin;

@property (nonatomic,assign) CGFloat topMargin;

@property (nonatomic,assign) CGFloat bottomMargin;

@property (nonatomic,strong) UIColor *lineColor;

@property (nonatomic,strong) NSMutableArray<__kindof KLineModel*> * dataArray;

@property (nonatomic,strong) NSMutableArray * currentDisplayArray;

@property (nonatomic,strong) NSMutableArray * currentPostionArray;

@property (nonatomic,assign) NSInteger        displayCount;

@property (nonatomic,assign) CGFloat          candleSpace;

@property (nonatomic,assign) CGFloat          candleWidth;

@property (nonatomic,assign) CGFloat          minHeight;

@property (nonatomic,assign) CGFloat          leftPostion;

@property (nonatomic,assign) NSInteger        currentStartIndex;

@property (nonatomic,assign) CGFloat          previousOffsetX;

@property (nonatomic,assign) CGFloat          contentOffset;

@property (nonatomic,assign) BOOL             kvoEnable;

@property (nonatomic,assign) BOOL             hollowRise;

@property (nonatomic,assign) double indicatorMaxY;

@property (nonatomic,assign) double indicatorMinY;

@property (nonatomic,assign) double indicatorMaxX;

@property (nonatomic,assign) double indicatorMinX;

@property (nonatomic,assign) double indicatorScaleY;

@property (nonatomic,assign) double indicatorScaleX;


- (CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion;

- (void)stockFill;
- (void)calcuteCandleWidth;
- (void)updateWidth;
- (void)drawKLine;
- (void)refreshKLineView:(KLineModel *)model;
- (void)isShowOrHiddenIditionChart:(BOOL)isShow;
@property (nonatomic,weak) id <AbuChartViewProtocol> delegate;
@property (nonatomic,assign) DataLineType currentType;
@end
