//
//  AbuMacdView.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/9.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbuMacdView : UIView
//MACD数据
@property (nonatomic,strong) NSMutableArray <__kindof AbuMacdModel*>*dataArray;
//KDJ数据
@property (nonatomic,strong) NSMutableArray <__kindof AbuKilneData*>*KDJDataArray;
@property (nonatomic,assign) CGFloat    leftPostion;
@property (nonatomic,assign) NSInteger  startIndex;
@property (nonatomic,assign) NSInteger  displayCount;
@property (nonatomic,assign) CGFloat    candleWidth;
@property (nonatomic,assign) CGFloat    candleSpace;
@property (nonatomic,assign) CGFloat    lineWidth;

/**
 * 当前绘制的起始下标
 */
@property (nonatomic,assign) NSInteger        currentStartIndex;

@property (nonatomic,assign) BOOL             kvoEnable;

- (void)stockFill;

@end
