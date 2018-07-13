//
//  AbuKlineView.h
//  AbuKlineView
//
//  Created by Jefferson.zhang on 2017/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AbuKlineView : UIView

/**
 数据源数组 在调用绘制方法之前设置 。Demo中数据源个数是固定的，如需实现类似右拉加载更多效果(参考网易贵金属)，需要在每次添加数据的时候设置 然后调用绘制方法 (现在本地数据是重复的6组)
 */
@property (nonatomic,strong) NSMutableArray<__kindof AbuChartCandleModel*> *dataArray;

/**
 可视区域显示多少根k线 (如果数据源数组不足以占满屏幕，需要手动给定宽度)
 */
@property (nonatomic,assign) NSInteger displayCount;

/**
 * 是否显示副图
 */
@property (nonatomic,assign) BOOL isShowIndictorView;

/**
 * 拿到最后一口报价 刷新K线
 */
- (void)refreshFSKlineView:(AbuChartCandleModel *)model;

- (void)isShowOrHiddenIditionChart:(BOOL)isShow;
@end
