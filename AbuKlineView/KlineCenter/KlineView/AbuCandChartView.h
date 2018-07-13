//
//  AbuCandChartView.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbuCandChartView : UIView
/**
 * 最大Y值
 */
@property (nonatomic,assign) CGFloat maxY;
/**
 * 最小Y值
 */
@property (nonatomic,assign) CGFloat minY;
/**
 * 最大X值
 */
@property (nonatomic,assign) CGFloat maxX;
/**
 * 最小X值
 */
@property (nonatomic,assign) CGFloat minX;
/**
 * 最大尺寸Y值
 */
@property (nonatomic,assign) CGFloat scaleY;
/**
 * 最大尺寸X值
 */
@property (nonatomic,assign) CGFloat scaleX;
/**
 * 宽度
 */
@property (nonatomic,assign) CGFloat lineWidth;
/**
 * 线的范围
 */
@property (nonatomic,assign) CGFloat lineSpace;
/**
 * 左边距
 */
@property (nonatomic,assign) CGFloat leftMargin;
/**
 * 右边距
 */
@property (nonatomic,assign) CGFloat rightMargin;
/**
 * 上边距
 */
@property (nonatomic,assign) CGFloat topMargin;
/**
 * 下边距
 */
@property (nonatomic,assign) CGFloat bottomMargin;
/**
 * 线的color
 */
@property (nonatomic,strong) UIColor *lineColor;
/**
 * 数据源数组
 */
@property (nonatomic,strong) NSMutableArray<__kindof AbuChartCandleModel*> * dataArray;
/**
 * 当前屏幕范围内显示的k线模型数组
 */
@property (nonatomic,strong) NSMutableArray * currentDisplayArray;
/**
 * 当前屏幕范围内显示的k线frame数组
 */
@property (nonatomic,strong) NSMutableArray * currentPostionArray;
/**
 * 可视区域显示多少根k线 (如果数据源数组不足以占满屏幕，需要手动给定宽度)
 */
@property (nonatomic,assign) NSInteger        displayCount;
/**
 * k线之间的距离
 */
@property (nonatomic,assign) CGFloat          candleSpace;
/**
 * k线的宽度 根据每页k线的根数和k线之间的距离动态计算得出
 */
@property (nonatomic,assign) CGFloat          candleWidth;
/**
 * k线最小高度
 */
@property (nonatomic,assign) CGFloat          minHeight;
/**
 * 当前屏幕范围内绘制起点位置
 */
@property (nonatomic,assign) CGFloat          leftPostion;
/**
 * 当前绘制的起始下标
 */
@property (nonatomic,assign) NSInteger        currentStartIndex;
/**
 * 滑到最右侧的偏移量
 */
@property (nonatomic,assign) CGFloat          previousOffsetX;
/**
 * 当前偏移量
 */
@property (nonatomic,assign) CGFloat          contentOffset;

@property (nonatomic,assign) BOOL             kvoEnable;
//空心阳线
@property (nonatomic,assign) BOOL             hollowRise;
/**
 * KDJ最大Y值
 */
@property (nonatomic,assign) double indicatorMaxY;
/**
 * KDJ最小Y值
 */
@property (nonatomic,assign) double indicatorMinY;
/**
 * KDJ最大X值
 */
@property (nonatomic,assign) double indicatorMaxX;
/**
 * KDJ最小X值
 */
@property (nonatomic,assign) double indicatorMinX;
/**
 * KDJ最大尺寸Y值
 */
@property (nonatomic,assign) double indicatorScaleY;
/**
 * KDJ最大尺寸X值
 */
@property (nonatomic,assign) double indicatorScaleX;


/**
 长按手势返回对应model的相对位置
 
 @param xPostion 手指在屏幕的位置
 @return 距离手指位置最近的model位置
 */
- (CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion;

- (void)stockFill;
- (void)calcuteCandleWidth;
- (void)updateWidth;
- (void)drawKLine;
- (void)refreshKLineView:(AbuChartCandleModel *)model;
/**
 * 是否隐藏幅图指标
 */
- (void)isShowOrHiddenIditionChart:(BOOL)isShow;
//- (void)drawIndoctorSubViewWith:(DataLineType)type;
@property (nonatomic,weak) id <AbuChartViewProtocol> delegate;
@property (nonatomic,assign) DataLineType currentType;
@end
