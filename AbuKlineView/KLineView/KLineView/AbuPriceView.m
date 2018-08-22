//
//  AbuPriceView.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuPriceView.h"

@implementation AbuPriceView


-(UILabel *)maxPriceLabel
{
    if (!_maxPriceLabel)
    {
        _maxPriceLabel = [self createLabel];
        [self addSubview:_maxPriceLabel];
        [_maxPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
        }];
    }
    return _maxPriceLabel;
}

-(UILabel *)middlePriceLabel
{
    if (!_middlePriceLabel)
    {
        _middlePriceLabel = [self createLabel];
        [self addSubview:_middlePriceLabel];
        [_middlePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.left.equalTo(self);
        }];
    }
    return _middlePriceLabel;
}

-(UILabel *)minPriceLabel
{
    if (!_minPriceLabel)
    {
        _minPriceLabel = [self createLabel];
        [self addSubview:_minPriceLabel];
        [_minPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.equalTo(self);
        }];
    }
    return _minPriceLabel;
}

-(UILabel*)createLabel
{
    UILabel *label = [UILabel new];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:11];
    return label;
}

@end
