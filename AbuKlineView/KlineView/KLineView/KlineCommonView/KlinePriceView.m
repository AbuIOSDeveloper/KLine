//
//  KlinePriceView.m
//  ExchangeKline
//
//  Created by jefferson on 2018/8/2.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "KlinePriceView.h"

#define NormalTextColor [UIColor colorWithRed:(153/255.0f) green:(153/255.0f) blue:(153/255.0f) alpha:1]

static CGFloat const priceLabelHeight = 14;
@interface KlinePriceView()
@property (nonatomic,strong) NSMutableArray   * priceLabelArr;
@property (nonatomic,strong) UILabel               * currentPositionPriceLabel;
@property (nonatomic,strong) UILabel               * zeroLabel;
@end

@implementation KlinePriceView

- (instancetype)initWithFrame:(CGRect)frame PriceArr:(NSArray *)priceArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.priceArr = priceArr;
        [self creatPriceLabel];
        [self creatCurrentPositionPriceLabel];
        [self creatXZeroLabel];
    }
    return self;
}

- (void)updateFrameWithHeight:(CGFloat)height
{
    
    CGFloat intervalSpace = height/(self.priceArr.count-1);
    [self.priceLabelArr enumerateObjectsUsingBlock:^(UILabel *priceLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        [priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            if (idx==0) {
                
                make.top.mas_equalTo(self);
            }else if (idx==self.priceLabelArr.count-1){
                
                make.bottom.mas_equalTo(self);
            }else
            {
                make.top.mas_equalTo(self).offset(intervalSpace*idx-priceLabelHeight/2);
            }
            
            
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(priceLabelHeight);
            
        }];
        
    }];
}

- (void)creatPriceLabel
{
    
    CGFloat intervalSpace = self.frame.size.height/(self.priceArr.count-1);
    for (int i = 0; i<self.priceArr.count; i++) {
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = NormalTextColor;
        priceLabel.font = [UIFont systemFontOfSize:9];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        priceLabel.text = self.priceArr[i];
        priceLabel.frame = CGRectMake(4, intervalSpace*i-priceLabelHeight/2, self.frame.size.width-4, priceLabelHeight);
        [self.priceLabelArr addObject:priceLabel];
        [self addSubview:priceLabel];
    }
}
- (void)reloadPriceWithPriceArr:(NSArray *)priceArr precision:(int)precision
{
    [self.priceLabelArr enumerateObjectsUsingBlock:^(UILabel *priceLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *priceStrr = [NSString stringWithFormat:@"%.*f",precision,[[priceArr[idx] stringValue] doubleValue]];
        priceLabel.text = priceStrr;
        
    }];
}

- (void)creatXZeroLabel
{
    [self addSubview:self.zeroLabel];
    [self.zeroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.height.mas_equalTo(priceLabelHeight);
    }];
    [self bringSubviewToFront:self.zeroLabel];
    self.zeroLabel.hidden = YES;
}

- (void)refreshCurrentPositionPricePositonY:(CGFloat)positionY price:(NSString *)price
{
    self.zeroLabel.hidden = NO;
    [self.zeroLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-(positionY-priceLabelHeight/2));
    }];
    self.zeroLabel.text = price;
}

- (void)hideZeroLabel:(BOOL)isHide
{
    if (isHide) {
        
        self.zeroLabel.hidden = YES;
    }else{
        self.zeroLabel.hidden = NO;
    }
}

- (void)refreshCurrentPositionPrice:(NSString *)price
{
    self.zeroLabel.text = price;
}

- (void)creatCurrentPositionPriceLabel
{
    [self addSubview:self.currentPositionPriceLabel];
    [self.currentPositionPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(4);
        make.height.mas_equalTo(priceLabelHeight);
    }];
    [self bringSubviewToFront:self.currentPositionPriceLabel];
    self.currentPositionPriceLabel.hidden = YES;
}

- (void)hideCurrentPositionPriceLabel
{
    self.currentPositionPriceLabel.hidden = YES;
}

- (NSMutableArray *)priceLabelArr
{
    if (!_priceLabelArr) {
        _priceLabelArr = [NSMutableArray array];
    }
    return _priceLabelArr;
}

- (UILabel *)zeroLabel
{
    if (!_zeroLabel) {
        _zeroLabel = [UILabel new];
        _zeroLabel.text = @"0";
        _zeroLabel.backgroundColor = [UIColor clearColor];
        _zeroLabel.textAlignment = NSTextAlignmentCenter;
        _zeroLabel.textColor = NormalTextColor;
        _zeroLabel.font = [UIFont systemFontOfSize:9];
        
    }
    return _zeroLabel;
}

- (UILabel *)currentPositionPriceLabel
{
    if (!_currentPositionPriceLabel) {
        _currentPositionPriceLabel = [UILabel new];
        _currentPositionPriceLabel.backgroundColor = [UIColor whiteColor];
        _currentPositionPriceLabel.textColor = [UIColor blackColor];
        _currentPositionPriceLabel.font = [UIFont systemFontOfSize:9];
        
    }
    return _currentPositionPriceLabel;
}

@end
