//
//  AbuKlineView.m
//  AbuKlineView
//
//  Created by Jefferson.zhang on 2017/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuKlineView.h"
#import "AbuCandChartView.h"
#import "KlineCurrentPriceView.h"
#import "KlineVerticalView.h"
#import "KlinePriceView.h"
@interface AbuKlineView()<AbuChartViewProtocol>
@property (nonatomic, strong) UIScrollView                           * scrollView;
@property (nonatomic, strong) AbuCandChartView                 * candleChartView;
@property (nonatomic, strong) KLineModel                            * model;
@property (nonatomic,strong) KlinePriceView                         * priceView;
@property (nonatomic, strong) KlinePriceView                        *  quotaPriceView;
@property (nonatomic, strong) UILongPressGestureRecognizer * longPressGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer        * pinchPressGesture;
@property (nonatomic, strong) UITapGestureRecognizer          * tapGesture;
@property (nonatomic, strong) KlineVerticalView                     * verticalView;
@property (nonatomic, strong) KlineCurrentPriceView              * leavView;
@property (nonatomic, strong) UILabel                                  * dataLable;
@property (nonatomic, strong) KlineCurrentPriceView             * currentPriceView;
@property (nonatomic, assign) NSInteger                                 curentIndex;
@property (nonatomic,assign) UIInterfaceOrientation                 orientation;
@property (nonatomic, assign) BOOL                                      ishow;
@end

@implementation AbuKlineView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    
    _curentIndex = 0;
    self.ishow = YES;
    [self addSubview:self.scrollView];
    [self initChartView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    WS(weakSelf);

    self.orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(ChartViewHigh);
        }];
        [self.candleChartView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(ChartViewHigh);
        }];
    }
    if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(LandscapeChartViewHigh);
        }];
        [self.candleChartView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(LandscapeChartViewHigh);
        }];
    }
    if (self.ishow) {
        [self.priceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf.scrollView.mas_right);
            make.height.mas_equalTo(weakSelf.candleChartView.mas_height).multipliedBy(2.0f / 3.0f);
        }];
         [self.priceView updateFrameWithHeight:weakSelf.scrollView.height * orignIndicatorOrignY];
    }
    else
    {
        [self.priceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf.scrollView.mas_right);
        }];
         [self.priceView updateFrameWithHeight:weakSelf.scrollView.height];
    }
}
-(void)initChartView{
    [self addSubview:self.priceView];
    [self addSubview:self.quotaPriceView];
    [self.scrollView addSubview:self.candleChartView];
    [self addConstrains];
    [self addGesture];
    [self initCrossLine];
    [self initdataLabel];
    [self initCurrentPrice];
}

- (void)addConstrains
{
    WS(weakSelf);
    
    self.orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat height = 0.0;
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf);
            make.right.equalTo(weakSelf.mas_right).offset(-priceWidth);
            make.height.mas_offset(ChartViewHigh);
        }];
        
        [self.candleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf.scrollView.mas_left);
            make.right.equalTo(weakSelf).offset(-5);
            make.height.mas_offset(ChartViewHigh);
        }];
        height = ChartViewHigh;
    }
    if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf).offset(5);
            make.right.equalTo(weakSelf.mas_right).offset(-priceWidth);
            make.height.mas_offset(LandscapeChartViewHigh);
        }];
        [self.candleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf.scrollView.mas_left);
            make.right.equalTo(weakSelf).offset(-5);
            make.height.mas_offset(LandscapeChartViewHigh);
        }];
        height = LandscapeChartViewHigh;
    }
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.right.equalTo(weakSelf);
        make.left.equalTo(weakSelf.scrollView.mas_right);
        make.height.mas_equalTo(weakSelf.candleChartView.mas_height).multipliedBy(2.0f / 3.0f);
    }];
    
    [self.quotaPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.priceView.mas_bottom);
        make.right.equalTo(weakSelf);
        make.left.equalTo(weakSelf.scrollView.mas_right);
        make.bottom.equalTo(weakSelf);
    }];
     [self.priceView updateFrameWithHeight:height * 2.0f / 3.0f];
    [self.quotaPriceView updateFrameWithHeight:height * 1.0f / 3.0f];
}
- (void)addGesture
{
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
    [self.candleChartView addGestureRecognizer:_longPressGesture];
    
    _pinchPressGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.scrollView addGestureRecognizer:_pinchPressGesture];
}

- (void)initCrossLine
{
    WS(weakSelf);
    self.verticalView = [[KlineVerticalView alloc] init];
    self.verticalView.clipsToBounds = YES;
    [self.scrollView addSubview:self.verticalView];
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scrollView.mas_top);
        make.width.equalTo(@(2));
        make.bottom.equalTo(weakSelf.candleChartView.mas_bottom).offset(-20);
        make.left.equalTo(@(0));
    }];
    self.leavView = [[KlineCurrentPriceView alloc] initWithUpdate:NO];
    self.leavView.clipsToBounds = YES;
    [self addSubview:self.leavView];
    [self.leavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf.candleChartView);
        make.height.equalTo(@(15));
    }];

    self.leavView.hidden = YES;
    self.verticalView.hidden = YES;
}

- (void)initdataLabel
{
    _dataLable = [[UILabel alloc]init];
    _dataLable.font = [UIFont systemFontOfSize:10];
    _dataLable.textColor = [UIColor whiteColor];
    _dataLable.backgroundColor = [UIColor orangeColor];
    [self.candleChartView addSubview:self.dataLable];
    WS(weakSelf);
    [self.dataLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.candleChartView.mas_bottom);
        make.width.mas_offset(priceWidth);
        make.height.mas_offset(15);
        make.left.equalTo(@0);
    }];
    self.dataLable.hidden = YES;
}

- (void)initCurrentPrice
{
    WS(weakSelf);
    _currentPriceView = [[KlineCurrentPriceView alloc]initWithUpdate:YES];
    [self addSubview:self.currentPriceView];
    [self.currentPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf.candleChartView);
        make.height.equalTo(@(14));
    }];
    self.currentPriceView.hidden = YES;
}

- (void)longGesture:(UILongPressGestureRecognizer*)longPress
{
    static CGFloat oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state)
    {
        CGPoint location = [longPress locationInView:self.candleChartView];
        if(ABS(oldPositionX - location.x) < (self.candleChartView.candleWidth + self.candleChartView.candleSpace)/2)
        {
            return;
        }
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
        CGPoint point = [self.candleChartView getLongPressModelPostionWithXPostion:location.x];
        CGFloat xPositoin = point.x + (self.candleChartView.candleWidth)/2.f - self.candleChartView.candleSpace/2.f ;
        CGFloat yPositoin = point.y;
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPositoin));
        }];
        [self.leavView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(yPositoin);
        }];
        [self.dataLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPositoin - 35));
        }];
        self.verticalView.hidden = NO;
        self.leavView.hidden = NO;
        self.dataLable.hidden = NO;
    }
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        if(self.verticalView)
        {
            self.verticalView.hidden = YES;
        }
        
        if(self.leavView)
        {
            self.leavView.hidden = YES;
        }
        oldPositionX = 0;
        self.scrollView.scrollEnabled = YES;
        self.dataLable.hidden = YES;
    }
}

float oldScale = 0;

- (void)pinchGesture:(UIPinchGestureRecognizer*)pinchPress
{
    if (pinchPress.numberOfTouches < 2)
    {
        _candleChartView.kvoEnable = YES;
        _scrollView.scrollEnabled = YES;
        return;
    }
    
    switch (pinchPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            _scrollView.scrollEnabled = NO;
            _candleChartView.kvoEnable = NO;
            oldScale = pinchPress.scale;
        }break;
        case UIGestureRecognizerStateEnded:
        {
            _scrollView.scrollEnabled = YES;
            _candleChartView.kvoEnable = YES;
        }break;
        default:
            break;
    }
    CGFloat minScale = 0.03;
    CGFloat diffScale = pinchPress.scale - oldScale;
    
    if (fabs(diffScale) > minScale)
    {
        CGFloat oldKlineWidth = self.candleChartView.candleWidth;
        
        self.candleChartView.candleWidth = (1 + diffScale) * oldKlineWidth;
        
        if (self.candleChartView.candleWidth > maxCandelWith) {
            self.candleChartView.candleWidth = maxCandelWith;
        }
        if (self.candleChartView.candleWidth < minCandelWith) {
            self.candleChartView.candleWidth = minCandelWith;
        }
        [_candleChartView updateWidth];
        CGPoint point1 = [pinchPress locationOfTouch:0 inView:self.scrollView];
        CGPoint point2 = [pinchPress locationOfTouch:1 inView:self.scrollView];
        CGFloat pinCenterX = (point1.x + point2.x) / 2;
        CGFloat scrollViewPinCenterX =  pinCenterX;
        NSInteger pinCenterLeftCount = scrollViewPinCenterX / (_candleChartView.candleWidth + _candleChartView.candleSpace);
        pinCenterLeftCount = _candleChartView.currentStartIndex;
        CGFloat newPinCenterX = pinCenterLeftCount * _candleChartView.candleWidth + (pinCenterLeftCount) * _candleChartView.candleSpace;
        CGFloat newOffsetX = newPinCenterX;
        _scrollView.contentOffset = CGPointMake(newOffsetX > 0 ? newOffsetX : 0, 0);
        _candleChartView.contentOffset = _scrollView.contentOffset.x;
        [_candleChartView drawKLine];
    }
}


- (void)setDataArray:(NSMutableArray<__kindof KLineModel *> *)dataArray
{
    _dataArray = dataArray;
    self.candleChartView.dataArray = dataArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.candleChartView reloadKline];
    });
}


- (void)refreshFSKlineView:(KLineModel *)model
{
    [self.candleChartView refreshKLineView:model];
    [self.candleChartView layoutIfNeeded];
    [self setNeedsDisplay];
}

- (void)reloadPriceViewWithPriceArr:(NSArray *)priceArr
{
    [self.priceView reloadPriceWithPriceArr:priceArr precision:2];
}

- (void)reloadPriceViewWithQuotaMaxValue:(double)maxValue MinValue:(double)minValue
{
    [self.quotaPriceView reloadPriceWithPriceArr:@[@(maxValue),@(minValue)] precision:2];
}
- (void)showIndexLineView:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count
{

}

- (void)displayScreenleftPostion:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count
{
    [self showIndexLineView:leftPostion startIndex:index count:count];
}

- (void)longPressCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(KLineModel *)kLineModel
{
    self.dataLable.text = kLineModel.timeStr;
    [self.leavView updateNewPrice:[NSString stringWithFormat:@"%.2lf",kLineModel.openPrice] backgroundColor:[UIColor orangeColor] precision:2];
}

- (void)refreshCurrentPrice:(KLineModel *)kLineModel candleModel:(KLineModel *)candleModel
{
    CGFloat close = kLineModel.closesPoint.y;
    CGFloat y = close;
    [self.currentPriceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(y + topDistance);
    }];
    self.currentPriceView.hidden = NO;
    [self.currentPriceView updateNewPrice:[NSString stringWithFormat:@"%.2lf",candleModel.closePrice] backgroundColor:[UIColor orangeColor] precision:2];
}

- (void)displayLastModel:(KLineModel *)kLineModel
{

}

- (void)displayMoreData
{
    NSLog(@"1233333");
    
}

- (UIInterfaceOrientation)orientation
{
    return  [[UIApplication sharedApplication] statusBarOrientation];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.layer.borderWidth = 1.0f;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _scrollView;
}
- (AbuCandChartView *)candleChartView
{
    if (!_candleChartView) {
        _candleChartView = [[AbuCandChartView alloc]init];
        _candleChartView.delegate = self;
        _candleChartView.candleSpace = 2;
    }
    return _candleChartView;
}

- (KlinePriceView *)priceView
{
    if (!_priceView) {
        _priceView = [[KlinePriceView alloc] initWithFrame:CGRectMake(0,0,0,0) PriceArr:@[@"",@"",@"",@"",@"",@""]];
        _priceView.backgroundColor = [UIColor blackColor];
        
    }
    return _priceView;
}

- (KlinePriceView *)quotaPriceView
{
    if (!_quotaPriceView) {
        _quotaPriceView = [[KlinePriceView alloc]initWithFrame:CGRectMake(0,0,0,0) PriceArr:@[@"",@""]];
        _quotaPriceView.backgroundColor = [UIColor blackColor];
    }
    return _quotaPriceView;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
