//
//  KlineVerticalView.h
//  ABuKLineChartView
//
//  Created by jefferson on 2018/9/14.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KlineVerticalView : UIView
- (void)updateTimeString:(NSString *)timeString;
- (void)updateTimeLeft:(CGFloat)leftdistance;
- (void)updateHeight:(CGFloat)candleChartHeight;
@end
