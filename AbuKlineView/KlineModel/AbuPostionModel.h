//
//  AbuPostionModel.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AbuPostionModel : NSObject

/**
 *  开盘点
 */
@property (nonatomic, assign) CGPoint openPoint;

/**
 *  收盘点
 */
@property (nonatomic, assign) CGPoint closePoint;

/**
 *  最高点
 */
@property (nonatomic, assign) CGPoint highPoint;

/**
 *  最低点
 */
@property (nonatomic, assign) CGPoint lowPoint;

/**
 *  日期
 */
@property (nonatomic, copy) NSString *date;

@property (nonatomic,assign) BOOL isDrawDate;
/**
 *  模型赋值转换
 */
+ (instancetype)itemWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint date:(NSString*)date;

@end
