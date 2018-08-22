//
//  AbuMacadPostionModel.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbuMacadPostionModel : NSObject

@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGPoint endPoint;

+ (instancetype)initPostion:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
