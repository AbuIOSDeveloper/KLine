//
//  AbuKlineModel.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AbuKlineModel : NSObject

@property (nonatomic,assign) CGFloat    xPosition;
@property (nonatomic,assign) CGFloat    yPosition;
@property (nonatomic,strong) UIColor  * lineColor;
@property (nonatomic,strong) NSString * title;

+ (instancetype)initxPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition color:(UIColor*)color;

@end
