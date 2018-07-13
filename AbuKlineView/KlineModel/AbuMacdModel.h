//
//  AbuMacdModel.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbuMacdModel : NSObject

@property(assign, nonatomic) CGFloat dea;
@property(assign, nonatomic) CGFloat diff;
@property(assign, nonatomic) CGFloat macd;
@property(copy,   nonatomic) NSString *date;

- (id)initWithDea:(CGFloat)dea diff:(CGFloat)diff macd:(CGFloat)macd date:(NSString *)date;

@end
