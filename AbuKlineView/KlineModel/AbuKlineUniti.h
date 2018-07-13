//
//  AbuKlineUniti.h
//  AbuKlineView
//
//  Created by Jefferson.zhang on 2017/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbuKlineUniti : NSObject

@property(assign, nonatomic) CGFloat value;

@property(retain, nonatomic) NSString *date;

- (id)initWithValue:(CGFloat)value date:(NSString *)date;

@end
