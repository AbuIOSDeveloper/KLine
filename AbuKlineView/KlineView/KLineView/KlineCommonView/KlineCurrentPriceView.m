//
//  KlineCurrentPriceView.m
//  ABuKLineChartView
//
//  Created by jefferson on 2018/9/14.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "KlineCurrentPriceView.h"
#define CoordinateDisPlayLabelColor [UIColor clearColor]
@interface KlineCurrentPriceView()
@property (nonatomic,strong) UIView              * currentPriceLine;
@property (nonatomic,strong) UILabel             * priceLabel;
@property (nonatomic,assign) BOOL                  update;
@property (nonatomic,strong) CAShapeLayer   * horizontalLineLayer;
@end

@implementation KlineCurrentPriceView

- (instancetype)initWithUpdate:(BOOL)update
{
    self = [super init];
    if (self) {
        self.update = update;
        [self buildUI];
        [self addConstrains];
    }
    return self;
}

- (void)buildUI
{
    
    self.currentPriceLine = [[UIView alloc] init];
    if (self.update) {
        self.currentPriceLine.backgroundColor = [UIColor clearColor];
        [self.currentPriceLine.layer addSublayer:[self creatLayerWithColor:CoordinateDisPlayLabelColor]];
    }else{
        self.currentPriceLine.backgroundColor = CoordinateDisPlayLabelColor;
    }
    [self addSubview:self.currentPriceLine];
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.priceLabel.backgroundColor = CoordinateDisPlayLabelColor;
    self.priceLabel.text = @"";
    self.priceLabel.textColor = [UIColor whiteColor];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.font = [UIFont systemFontOfSize:9];
    [self addSubview:self.priceLabel];
    
}

- (CAShapeLayer *)creatLayerWithColor:(UIColor *)color
{
    [self.horizontalLineLayer removeFromSuperlayer];
    self.horizontalLineLayer = nil;
    self.horizontalLineLayer = [CAShapeLayer layer];
    UIBezierPath *topLine = [UIBezierPath bezierPath];
    [topLine moveToPoint:CGPointMake(0,0)];
    if (!Portrait) {
        [topLine addLineToPoint:CGPointMake(KSCREEN_HEIGHT - priceWidth,0)];
    }else{
        [topLine addLineToPoint:CGPointMake(KSCREEN_WIDTH - priceWidth,0)];
    }
    self.horizontalLineLayer.lineWidth = 1;
    self.horizontalLineLayer.lineDashPattern = @[@4, @4];
    self.horizontalLineLayer.path = topLine.CGPath;
    self.horizontalLineLayer.strokeColor = color.CGColor;
    return self.horizontalLineLayer;
}

- (void)addConstrains
{
    [self.currentPriceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-priceWidth);
        make.left.mas_equalTo(self);
        make.height.equalTo(@0.5);
        make.centerY.mas_equalTo(self);
        
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.currentPriceLine.mas_right);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)updateNewPrice:(NSString *)newPrice backgroundColor:(UIColor *)color precision:(int)precision
{
    
    NSString *priceStrr = [NSString stringWithFormat:@"%.*f",precision,[newPrice doubleValue]];
    
    self.priceLabel.text = priceStrr;
    if (color) {
        
        self.priceLabel.backgroundColor = color;
        if (self.update)
            self.currentPriceLine.backgroundColor = [UIColor clearColor];
        [self.currentPriceLine.layer addSublayer:[self creatLayerWithColor:color]];
    }
}

@end
