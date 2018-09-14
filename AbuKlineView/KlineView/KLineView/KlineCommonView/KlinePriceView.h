//
//  KlinePriceView.h
//  ExchangeKline
//
//  Created by jefferson on 2018/8/2.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KlinePriceView : UIView

@property (nonatomic,strong) NSArray *priceArr;

- (instancetype)initWithFrame:(CGRect)frame PriceArr:(NSArray *)priceArr;

- (void)reloadPriceWithPriceArr:(NSArray *)priceArr precision:(int)precision;

- (void)hideZeroLabel:(BOOL)isHide;

- (void)refreshCurrentPositionPricePositonY:(CGFloat)positionY price:(NSString *)price;

- (void)refreshCurrentPositionPrice:(NSString *)price;

- (void)updateFrameWithHeight:(CGFloat)height;

@end
