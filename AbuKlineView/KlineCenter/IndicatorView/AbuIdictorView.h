//
//  AbuIdictorView.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/9.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AbuIdictorDelegate <NSObject>
/**
 * 选择哪个按钮
 */
- (void)selectIndex:(NSInteger)index;

@end

@interface AbuIdictorView : UIView

@property (nonatomic, weak) id<AbuIdictorDelegate> delegate;

- (instancetype)initWithTitleArray:(NSArray *)array;

@end
