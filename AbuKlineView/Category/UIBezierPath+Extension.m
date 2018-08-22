//
//  UIBezierPath+Extension.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "UIBezierPath+Extension.h"

@implementation UIBezierPath (Extension)
/**
 *  绘制单条折线
 */
+(UIBezierPath *)drawLine:(NSMutableArray *)linesArray
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [linesArray enumerateObjectsUsingBlock:^(AbuKlineModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.xPosition == 0) {
            return ;
        }
        //判断是否为一个元素
        if (idx == 0) {
            [path moveToPoint:CGPointMake(obj.xPosition, obj.yPosition)];
        }
        else //多个数据连接起来
        {
            [path addLineToPoint:CGPointMake(obj.xPosition, obj.yPosition)];
        }
    }];
    return path;
}

/**
 *  绘制多条折线
 */
+(NSMutableArray<UIBezierPath *> *)drawLines:(NSMutableArray<NSMutableArray *> *)linesArray
{
    if (IsArrayNull(linesArray))
        return nil;
    NSMutableArray * result = [NSMutableArray array];
    
    for (NSMutableArray * lineArray in linesArray) {
        UIBezierPath * path = [UIBezierPath drawLine:lineArray];
        [result addObject:path];
    }
    
    return result;
    
}

/**
 *  绘制柱状图
 */
+ (UIBezierPath *)drawKLine:(CGFloat)open close:(CGFloat)close high:(CGFloat)high low:(CGFloat)low candleWidth:(CGFloat)candleWidth  xPostion:(CGFloat)xPostion lineWidth:(CGFloat)lineWidth
{
    UIBezierPath * candlePath = [UIBezierPath bezierPath];
    candlePath.lineWidth = lineWidth;
    CGFloat y = open > close ? close : open;
    CGFloat height = fabs(close-open);
    [candlePath moveToPoint:CGPointMake(xPostion, y)];
    [candlePath addLineToPoint:CGPointMake(xPostion + candleWidth / 2.0f, y)];
    if (y > high) {
      [candlePath addLineToPoint:CGPointMake(xPostion + candleWidth / 2.0f, high)];
      [candlePath addLineToPoint:CGPointMake(xPostion + candleWidth / 2.0f, y)];
    }

    [candlePath addLineToPoint:CGPointMake(xPostion + candleWidth, y)];
    [candlePath addLineToPoint:CGPointMake(xPostion + candleWidth, y + height)];
    [candlePath addLineToPoint:CGPointMake(xPostion + candleWidth / 2.0f, y + height)];
//    if ( (y + height) > max) {
//        [candlePath addLineToPoint:CGPointMake(xPostion + candleWidth / 2.0f, max)];
//        [candlePath addLineToPoint:CGPointMake(xPostion + candleWidth / 2.0f, y+height)];
//    }
     if ((y + height) < low)
    {
        [candlePath addLineToPoint:CGPointMake(xPostion + candleWidth / 2.0f, low)];
        [candlePath addLineToPoint:CGPointMake(xPostion + candleWidth / 2.0f, y+height)];
    }
    [candlePath addLineToPoint:CGPointMake(xPostion, y + height)];
    [candlePath addLineToPoint:CGPointMake(xPostion, y)];
    [candlePath closePath];
    return candlePath;
}

@end
