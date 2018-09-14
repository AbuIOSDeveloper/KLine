//
//  KlineTitleView.h
//  LGTS2
//
//  Created by Jefferson.zhang on 2017/7/18.
//  Copyright © 2017年 Mata. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    K_LINE_5MIN = 0x01,    // 5分钟
    K_LINE_15MIN = 0x02,    // 15分钟
    K_LINE_30MIN = 0x03,    // 30分钟
    K_LINE_60MIN = 0x04,    // 60分钟
    K_LINE_DAY = 0x05,        //日线
    K_LINE_WEEK = 0x06,    // 周线
    K_LINE_MONTH = 0x07,    // 月线
    K_LINE_VANE = 0x08, // 风向标
    K_LINE_YEAR = 0x09,    // 年线
    K_LINE_MANY_DAY = 15,    // 多日线
    K_LINE_MANY_MIN = 16,    // 多分钟线
    K_LINE_MANY_HOUR = 17,    // 多小时线
    K_LINE_1MIN = 34,    // 1分时图
    K_LINE_MIN = 35,    // 分钟线
    K_LINE_3MIN = 36,    // 3分钟
    K_LINE_1HOUR = 37,    // 1小时
    K_LINE_4HOUR = 38,    // 4小时
    
}KLINETYPE;

@protocol KlineTitleViewDelegate <NSObject>
- (void)selectIndex:(KLINETYPE)type;

@end

@interface KlineTitleView : UIView

@property (nonatomic, weak) id<KlineTitleViewDelegate> delegate;

- (instancetype)initWithklineTitleArray:(NSArray *)titleArray typeArray:(NSArray *)typeArray;



@end
