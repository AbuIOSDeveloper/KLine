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
    K_LINE_5MIN = 0x01,
    K_LINE_15MIN = 0x02,
    K_LINE_30MIN = 0x03,
    K_LINE_60MIN = 0x04,
    K_LINE_DAY = 0x05,
    K_LINE_WEEK = 0x06,
    K_LINE_MONTH = 0x07,
    K_LINE_VANE = 0x08,
    K_LINE_YEAR = 0x09,
    K_LINE_MANY_DAY = 15,
    K_LINE_MANY_MIN = 16,
    K_LINE_MANY_HOUR = 17,
    K_LINE_1MIN = 34,
    K_LINE_MIN = 35,
    K_LINE_3MIN = 36,
    K_LINE_1HOUR = 37,
    K_LINE_4HOUR = 38, 
    
}KLINETYPE;

@protocol KlineTitleViewDelegate <NSObject>

- (void)selectIndex:(KLINETYPE)type;

@end

@interface KlineTitleView : UIView

@property (nonatomic, weak) id<KlineTitleViewDelegate> delegate;

- (instancetype)initWithklineTitleArray:(NSArray *)titleArray typeArray:(NSArray *)typeArray;



@end
