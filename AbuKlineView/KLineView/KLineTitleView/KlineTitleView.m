//
//  KlineTitleView.m
//  LGTS2
//
//  Created by Jefferson.zhang on 2017/7/18.
//  Copyright © 2017年 Mata. All rights reserved.
//

#import "KlineTitleView.h"


#define kHeight [UIScreen mainScreen].bounds.size.height

#define lineWidth 30.0f

#define lineHight 3.0f

@interface KlineTitleView()

@property (nonatomic, strong) UIView        * line;

@property (nonatomic, strong) UIView        * titleView;

@property (nonatomic, assign) NSInteger       selectIndex;

@property (nonatomic, strong) NSArray       * titleArray;

@property (nonatomic, strong) NSArray       * typeArray;

@property (nonatomic, assign) NSInteger       count;

@end


@implementation KlineTitleView

- (instancetype)initWithklineTitleArray:(NSArray *)titleArray typeArray:(NSArray *)typeArray
{
    self = [super init];
    if (self) {
        self.selectIndex = 0;
        self.titleArray = titleArray;
        self.typeArray = typeArray;
        self.count = typeArray.count;
        [self buildTitleView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    NSInteger inde = self.selectIndex;
    for (UIView * view in self.titleView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        self.titleView.frame = CGRectMake(0, 0, TotalWidth, 33);
        [self buildTitleButton];
    }else if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        self.titleView.frame = CGRectMake(0, 0, TotalWidth, 33);
        self.count = self.typeArray.count;
        [self buildTitleButton];
    }
    
    [self changeLineFrame:inde];
}

- (void)buildTitleView
{
    [self addConstrains];
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.line];
}

- (void)addConstrains
{
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        self.titleView.frame = CGRectMake(0, 0, TotalWidth, 33);
        //创建标题按钮
        [self buildTitleButton];
        
        
    }else if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        self.titleView.frame = CGRectMake(0, 0, TotalWidth, 33);
        //创建标题按钮
        [self buildTitleButton];
    }
}

- (void)buildTitleButton
{
    for (NSInteger i = 0; i < self.typeArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(TotalWidth / self.count * i, 0, TotalWidth / self.count, 30);
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        if (i == self.selectIndex) {
            button.selected = YES;
        }
        [button setTitleColor:[UIColor colorWithHexString:@"#608fdb"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithHexString:@"#7b8396"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.userInteractionEnabled = YES;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = [self.typeArray[i] integerValue];
        [self.titleView addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)btn
{
    KLINETYPE type = (KLINETYPE)btn.tag;
    for (int i = 0; i < self.typeArray.count; i++) {
        if (btn.tag == [self.typeArray[i] integerValue]) {
            self.selectIndex = i;
        }
    }
    for (UIButton *bt in self.titleView.subviews) {
        if ([bt isKindOfClass:[UIButton class]]) {
            bt.selected = NO;
            if (self.selectIndex<self.typeArray.count) {
                if ([self.typeArray[self.selectIndex] integerValue] == bt.tag) {
                    bt.selected = YES;
                }
            }
        }
    }
    [self changeLineFrame:self.selectIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIndex:)]) {
        [self.delegate selectIndex:type];
    }
}

- (void)changeLineFrame:(NSInteger)index
{
    CGRect frame = self.line.frame;
    CGFloat orignX;
    orignX =  ((CGFloat)(TotalWidth / self.count) ) * index + ((TotalWidth / self.count) - lineWidth) / 2.0f;
    frame.origin.x = orignX;
    self.line.frame = frame;
}

- (UIView *)line
{
    if (!_line) {
        _line  = [[UIView alloc] initWithFrame:CGRectMake((TotalWidth / self.count - lineWidth) / 2.0f, 30, lineWidth, lineHight)];
         _line.backgroundColor = [UIColor colorWithHexString:@"#608fdb"];
    }
    return _line;
}

-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
    }
    return _titleView;
}

- (UIInterfaceOrientation)orientation
{
    
    return [[UIApplication sharedApplication] statusBarOrientation];
}


@end
