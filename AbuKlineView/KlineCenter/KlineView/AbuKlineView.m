//
//  AbuKlineView.m
//  AbuKlineView
//
//  Created by Jefferson.zhang on 2017/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuKlineView.h"
#import "AbuCandChartView.h"


@interface AbuKlineView()<AbuChartViewProtocol,AbuIdictorDelegate>
/**
 * scrollView
 */
@property (nonatomic, strong) UIScrollView                 * scrollView;
/**
 * K线图
 */
@property (nonatomic, strong) AbuCandChartView             * candleChartView; //K线图
/**
 * K线模型
 */
@property (nonatomic, strong) AbuChartCandleModel          * model; //K线模型
/**
 * K线价格View
 */
@property (nonatomic, strong) AbuPriceView                 * candlePriceView;
/**
 * 指标价格线价格View
 */
@property (nonatomic, strong) AbuPriceView                 * indictorPriceView;
/**
 * 长按手势
 */
@property (nonatomic, strong) UILongPressGestureRecognizer * longPressGesture;
/**
 * 缩放手势
 */
@property (nonatomic, strong) UIPinchGestureRecognizer     * pinchPressGesture;
/**
 * 点击手势
 */
@property (nonatomic, strong) UITapGestureRecognizer       * tapGesture;
/**
 * 十字架垂直线
 */
@property (nonatomic, strong) UIView                       * verticalView;
/**
 * 十字架水平线
 */
@property (nonatomic, strong) UIView                       * leavView;
@property (nonatomic, strong) UILabel                      * priceLable;
@property (nonatomic, strong) UILabel                      * dataLable;

@property (nonatomic, strong) UILabel                      * currentPrice;

@property (nonatomic, strong) UIView                       * currentPriceView;
//指标选择
@property (nonatomic, strong) AbuIdictorView               * indictorView;
/**
 * 当前指标
 */
@property (nonatomic, assign) NSInteger                      curentIndex;

/**
 *横竖屏方向
 */
@property (nonatomic,assign) UIInterfaceOrientation orientation;

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
    [self addSubview:self.scrollView];
    [self initChartView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark - 旋转事件
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    WS(weakSelf);

    self.orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(ChartViewHigh);
        }];
        [self.candleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(ChartViewHigh);
        }];
        [self.candlePriceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(weakSelf.candleChartView.mas_height).multipliedBy(2.0f / 3.0f);
        }];
        
    }
    if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(LandscapeChartViewHigh);
        }];
        [self.candleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(LandscapeChartViewHigh);
        }];
        [self.candlePriceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(weakSelf.candleChartView.mas_height).multipliedBy(2.0f / 3.0f);
        }];
    }

}

#pragma mark K线图表
-(void)initChartView{
    [self addSubview:self.candlePriceView];
    [self addSubview:self.indictorPriceView];
    [self.scrollView addSubview:self.candleChartView];
    [self addConstrains];
    [self addGesture];
    [self initCrossLine];
    [self initPriceLabel];
    [self initdataLabel];
    [self initCurrentPrice];
}

- (void)addConstrains
{
    WS(weakSelf);
    
    self.orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf).offset(5);
            make.right.equalTo(weakSelf.mas_right).offset(-60);
            make.height.mas_offset(ChartViewHigh);
        }];
        [self.candleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.scrollView.mas_top);
            make.left.equalTo(weakSelf.scrollView.mas_left);
            make.right.equalTo(weakSelf.scrollView.mas_right).offset(-5);
            make.height.mas_offset(ChartViewHigh);
        }];
    }
    if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf).offset(5);
            make.right.equalTo(weakSelf.mas_right).offset(-60);
            make.height.mas_offset(LandscapeChartViewHigh);
        }];
        [self.candleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.scrollView.mas_top);
            make.left.equalTo(weakSelf.scrollView.mas_left);
            make.right.equalTo(weakSelf.scrollView.mas_right).offset(-5);
            make.height.mas_offset(LandscapeChartViewHigh);
        }];
    }
    
    [self.candlePriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scrollView);
        make.right.equalTo(weakSelf);
        make.left.equalTo(weakSelf.scrollView.mas_right);
        make.height.mas_equalTo(weakSelf.scrollView.mas_height).multipliedBy(2.0f / 3.0f);
    }];
    
    [self.indictorPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.candlePriceView.mas_bottom);
        make.right.equalTo(weakSelf);
        make.left.equalTo(weakSelf.scrollView.mas_right);
        make.height.mas_equalTo(weakSelf.candleChartView.mas_height).multipliedBy(1.0f / 3.0);
    }];
}
#pragma mark 指标视图
-(void)initIndictorView
{
    _indictorView = [[AbuIdictorView alloc]initWithTitleArray:@[@"MCAD",@"WR",@"KDJ"]];
    _indictorView.delegate = self;
    [self addSubview:_indictorView];
    WS(weakSelf);
    [_indictorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(5);
        make.top.equalTo(weakSelf.candlePriceView.mas_bottom);
        make.width.mas_offset(120);
        make.height.mas_offset(20);
    }];
}

#pragma mark 添加手势
- (void)addGesture
{
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
    [self.candleChartView addGestureRecognizer:_longPressGesture];
    
    _pinchPressGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.scrollView addGestureRecognizer:_pinchPressGesture];
}

#pragma mark 十字线
- (void)initCrossLine
{
    WS(weakSelf);
    //垂直线
    self.verticalView = [UIView new];
    self.verticalView.clipsToBounds = YES;
    [self.scrollView addSubview:self.verticalView];
    self.verticalView.backgroundColor = [UIColor colorWithHexString:@"#666666"];
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scrollView.mas_top);
        make.width.equalTo(@(_candleChartView.lineWidth));
        make.bottom.equalTo(weakSelf.candleChartView);
        make.left.equalTo(@(0));
    }];
    //水平线
    self.leavView = [UIView new];
    self.leavView.clipsToBounds = YES;
    [self.scrollView addSubview:self.leavView];
    self.leavView.backgroundColor = [UIColor colorWithHexString:@"#666666"];;
    [self.leavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf.candleChartView);
        make.height.equalTo(@(weakSelf.candleChartView.lineWidth));
    }];
    
    self.leavView.hidden = YES;
    self.verticalView.hidden = YES;
}
//十字架线显示的价格线
- (void)initPriceLabel
{
    _priceLable = [[UILabel alloc]init];
    _priceLable.font = [UIFont systemFontOfSize:10];
    _priceLable.textColor = [UIColor blackColor];
    _priceLable.backgroundColor = [UIColor blueColor];
    [self.candlePriceView addSubview:self.priceLable];
    WS(weakSelf);
    [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(weakSelf.candlePriceView.mas_left);
        make.right.equalTo(weakSelf.candlePriceView.mas_right);
        make.height.mas_offset(15);
    }];
    self.priceLable.hidden = YES;
}
//十字架显示的日期线
- (void)initdataLabel
{
    _dataLable = [[UILabel alloc]init];
    _dataLable.font = [UIFont systemFontOfSize:10];
    _dataLable.textColor = [UIColor blackColor];
    _dataLable.backgroundColor = [UIColor blueColor];
    [self.candleChartView addSubview:self.dataLable];
    WS(weakSelf);
    [self.dataLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.candleChartView.mas_bottom);
        make.width.mas_offset(60);
        make.height.mas_offset(15);
        make.left.equalTo(@0);
    }];
    self.dataLable.hidden = YES;
}

- (void)initCurrentPrice
{
    _currentPrice = [[UILabel alloc]init];
    _currentPrice.font = [UIFont systemFontOfSize:10];
    _currentPrice.backgroundColor = [UIColor orangeColor];
    _currentPrice.textColor = [UIColor whiteColor];
    [self.candlePriceView addSubview:self.currentPrice];
    WS(weakSelf);
    [self.currentPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(weakSelf.candlePriceView.mas_left).offset(5);
        make.right.equalTo(weakSelf.candlePriceView.mas_right);
        make.height.mas_offset(15);
    }];
    self.currentPrice.hidden = YES;
    
    _currentPriceView = [[UIView alloc]init];
    _currentPriceView.backgroundColor = [UIColor orangeColor];
    [self.candleChartView addSubview:self.currentPriceView];
   
    [self.currentPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf.candleChartView);
        make.height.equalTo(@(weakSelf.candleChartView.lineWidth));
    }];
    self.currentPriceView.hidden = YES;
}

#pragma mark 手势操作

#pragma mark 长按手势
- (void)longGesture:(UILongPressGestureRecognizer*)longPress
{
    static CGFloat oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state)
    {//长按
        CGPoint location = [longPress locationInView:self.candleChartView];
        if(ABS(oldPositionX - location.x) < (self.candleChartView.candleWidth + self.candleChartView.candleSpace)/2)
        {
            return;
        }
        
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
        //获取长按的坐标
        CGPoint point = [self.candleChartView getLongPressModelPostionWithXPostion:location.x];
        CGFloat xPositoin = point.x + (self.candleChartView.candleWidth)/2.f - self.candleChartView.candleSpace/2.f ;
        CGFloat yPositoin = point.y +_candleChartView.topMargin;
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPositoin));
        }];
        //更新十字架、价格、日期约束
        [self.leavView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(yPositoin);
        }];
        [self.priceLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(yPositoin - 7.5f);
        }];
        [self.dataLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPositoin - 35));
        }];
        //显示十字架、价格、日期
        self.verticalView.hidden = NO;
        self.leavView.hidden = NO;
        self.priceLable.hidden = NO;
        self.dataLable.hidden = NO;
    }
    //松开
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
        //设置scrollView可以滑动
        self.scrollView.scrollEnabled = YES;
        //隐藏
        self.priceLable.hidden = YES;
        self.dataLable.hidden = YES;
    }
}

float oldScale = 0;
#pragma mark 缩放手势
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


- (void)setDataArray:(NSMutableArray<__kindof AbuChartCandleModel *> *)dataArray
{
    _dataArray = dataArray;
    self.candleChartView.dataArray = dataArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.candleChartView stockFill];
    });
}

- (void)isShowOrHiddenIditionChart:(BOOL)isShow
{
    [self.candleChartView isShowOrHiddenIditionChart:isShow];
}

#pragma mark - 刷新K线
- (void)refreshFSKlineView:(AbuChartCandleModel *)model
{
    [self.candleChartView refreshKLineView:model];
    [self.candleChartView layoutIfNeeded];
}

-(void)setDisplayCount:(NSInteger)displayCount
{
    _displayCount = displayCount;
    _candleChartView.displayCount = displayCount;
}

-(void)setIsShowIndictorView:(BOOL)isShowIndictorView
{
    _isShowIndictorView = isShowIndictorView;
    if (isShowIndictorView) {
        [self initIndictorView];
    }
    [self layoutIfNeeded];
}

- (void)showIndexLineView:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count
{
    _candlePriceView.maxPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.candleChartView.maxY];
    _candlePriceView.middlePriceLabel.text = [NSString stringWithFormat:@"%.2f",(self.candleChartView.maxY - self.candleChartView.minY)/2 + self.candleChartView.minY];
    _candlePriceView.minPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.candleChartView.minY];
    
//    if (_curentIndex == 0) {
        _indictorPriceView.maxPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.candleChartView.indicatorMaxY];
        _indictorPriceView.middlePriceLabel.text = [NSString stringWithFormat:@"%.2f",(self.candleChartView.indicatorMaxY - self.candleChartView.indicatorMinY)/2 + self.candleChartView.indicatorMinY];
        _indictorPriceView.minPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.candleChartView.indicatorMinY];
}

#pragma mark AbuChartViewProtocol

/**
 当前屏幕内模型数组的开始下标以及个数
 
 @param leftPostion 当前屏幕最左边的位置
 @param index 下标
 @param count 个数
 */
- (void)displayScreenleftPostion:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count
{
    [self showIndexLineView:leftPostion startIndex:index count:count];
}

//长按时得到的K线模型
- (void)longPressCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(AbuChartCandleModel *)kLineModel
{
    self.priceLable.text = [NSString stringWithFormat:@"%.2lf",kLineModel.open];
    self.dataLable.text = kLineModel.date;
}

//刷新报价
- (void)refreshCurrentPrice:(AbuPostionModel *)kLineModel candleModel:(AbuChartCandleModel *)candleModel
{
    CGFloat open = kLineModel.openPoint.y;
    CGFloat close = kLineModel.closePoint.y;
    CGFloat y = open > close ? open : close;
    CGFloat price = candleModel.open > candleModel.close ? candleModel.close : candleModel.open;
    [self.currentPriceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(y + topDistance);
    }];
    self.currentPriceView.hidden = NO;
    [self.currentPrice mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(y + topDistance - 7.5);
    }];
    self.currentPrice.hidden = NO;
    self.currentPrice.text = [NSString stringWithFormat:@"%.2lf",price];
}

- (void)displayLastModel:(AbuChartCandleModel *)kLineModel
{

}

- (void)displayMoreData
{
    NSLog(@"1233333");
    
}

#pragma mark AbuIdictorDelegate
- (void)selectIndex:(NSInteger)index
{    
    if (index == _curentIndex) {
        return;
    }
    do {
        
        if (index == 0) {
            self.candleChartView.currentType = MACD;
            break;
        }
        
        if (index == 1) {
            self.candleChartView.currentType = KDJ;
            break;
        }
        
        if (index == 2) {
            self.candleChartView.currentType = WR;
            break;
        }
    } while(0);
    _curentIndex = index;
    [self.candleChartView drawKLine];

}

#pragma mark  布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (UIInterfaceOrientation)orientation
{
    return  [[UIApplication sharedApplication] statusBarOrientation];
}

//scrollView
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.layer.borderWidth = 1.0f;
        _scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _scrollView;
}
//K线
- (AbuCandChartView *)candleChartView
{
    if (!_candleChartView) {
        _candleChartView = [[AbuCandChartView alloc]init];
        _candleChartView.delegate = self;
        // K线蜡烛的间接
        _candleChartView.candleSpace = 2;
        //MA5 MA10 MA20线的宽度
        _candleChartView.lineWidth = 1;
        _candleChartView.currentType = MACD;
    }
    return _candleChartView;
}

- (AbuPriceView *)candlePriceView
{
    if (!_candlePriceView) {
        _candlePriceView = [[AbuPriceView alloc]init];
        _candlePriceView.layer.borderColor = [UIColor redColor].CGColor;
        _candlePriceView.layer.borderWidth = 0.5f;
    }
    return _candlePriceView;
}

- (AbuPriceView *)indictorPriceView
{
    if (!_indictorPriceView) {
        _indictorPriceView = [[AbuPriceView alloc]init];
        _indictorPriceView.layer.borderColor = [UIColor greenColor].CGColor;
        _indictorPriceView.layer.borderWidth = 0.5f;
    }
    return _indictorPriceView;
}


@end
