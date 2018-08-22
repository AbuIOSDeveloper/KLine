//
//  AbuIdictorView.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/9.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuIdictorView.h"

@interface AbuIdictorView()

@property (nonatomic, assign) NSInteger     selectIndex;

@end

@implementation AbuIdictorView

- (instancetype)initWithTitleArray:(NSArray *)array
{
    self = [super init];
    
    if (self) {
        
        [self makeEqualWidth:array inView:self LRpadding:20 viewPadding:10];
        [self changeButtonTextColor];
    }
    return self;
}

-(void)makeEqualWidth:(NSArray *)array inView:(UIView *)containerView LRpadding:(CGFloat)LRpadding viewPadding :(CGFloat)viewPadding
{
    UIButton * lastBtn;
    for (int i = 0; i < array.count; i++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:btn];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        if (lastBtn) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(containerView);
                make.left.equalTo(lastBtn.mas_right).offset(5);
                make.width.equalTo(lastBtn);
            }];
        }else
        {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(containerView).offset(10);
                make.top.bottom.equalTo(containerView);
            }];
        }
        lastBtn = btn;
    }
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containerView).offset(-5);
    }];

}

- (void)buttonAction:(UIButton *)button
{
    self.selectIndex = button.tag;
    [self changeButtonTextColor];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIndex:)]) {
        [self.delegate selectIndex:button.tag];
    }
}

- (void)changeButtonTextColor
{
    for (UIView *view in [self subviews]) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)view;
            
            if (button.tag == self.selectIndex) {
                [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            }else{
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
}

@end
