//
//  KlineCurrentPriceView.h
//  ABuKLineChartView
//
//  Created by jefferson on 2018/9/14.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KlineCurrentPriceView : UIView
- (instancetype)initWithUpdate:(BOOL)update;
- (void)updateNewPrice:(NSString *)newPrice backgroundColor:(UIColor *)color precision:(int)precision;
@end
