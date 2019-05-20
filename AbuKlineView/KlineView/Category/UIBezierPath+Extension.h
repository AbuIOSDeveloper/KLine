//
//  UIBezierPath+Extension.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Extension)

+ (UIBezierPath*)drawWireLine:(NSMutableArray*)linesArray;


+ (NSMutableArray<__kindof UIBezierPath*>*)drawLines:(NSMutableArray<NSMutableArray*>*)linesArray;

+ (UIBezierPath *)drawKLine:(CGFloat)open close:(CGFloat)close high:(CGFloat)high low:(CGFloat)low candleWidth:(CGFloat)candleWidth xPostion:(CGFloat)xPostion lineWidth:(CGFloat)lineWidth;

@end
