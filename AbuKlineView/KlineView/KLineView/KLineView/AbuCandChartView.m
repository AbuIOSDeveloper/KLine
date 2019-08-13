//
//  AbuCandChartView.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuCandChartView.h"
#import "KlineQuotaColumnLayer.h"
#import "KlineCandelLayer.h"
#import "KlineTimeLayer.h"
#import "KlineMALayer.h"

#define MINDISPLAYCOUNT 6
@interface AbuCandChartView()<UIScrollViewDelegate,AbuChartViewProtocol>
@property (nonatomic,strong) UIScrollView                     * scrollView;
@property (nonatomic, strong) FBKVOController             * KVOController;
@property (nonatomic,assign) CGFloat                            leftPostion;
@property (nonatomic,strong) NSMutableArray               * currentDisplayArray;
@property (nonatomic,assign) CGFloat                            previousOffsetX;
@property (nonatomic,assign) CGFloat                             maxAssert;
@property (nonatomic,assign) CGFloat                             minAssert;
@property (nonatomic,assign) CGFloat                             heightPerpoint;
@property (nonatomic, assign) BOOL                               isRefresh;
@property (nonatomic, strong) KlineTimeLayer                * timeLayer;
@property (nonatomic, strong) KlineCandelLayer             * candelLayer;
@property (nonatomic, strong) KlineMALayer                  * ma5LineLayer;
@property (nonatomic, strong) KlineMALayer                  * ma10LineLayer;
@property (nonatomic, strong) KlineMALayer                  * ma20LineLayer;
@property (nonatomic,assign) double                                quotaMinAssert;
@property (nonatomic,assign) double                                quotaMaxAssert;
@property (nonatomic,assign) CGFloat                               quotaHeightPerPoint;
@property (nonatomic, strong) KlineQuotaColumnLayer    *  macdLayer;
@property (nonatomic, strong) KlineMALayer                  *  deaLayer;
@property (nonatomic, strong) KlineMALayer                  *  diffLayer;
@property (nonatomic,strong) KlineMALayer                   *  kLineLayer;
@property (nonatomic,strong) KlineMALayer                   *  dLineLayer;
@property (nonatomic,strong) KlineMALayer                   * wrLineLayer;
@property (nonatomic,assign) float                                   chartSize;
@property (nonatomic,assign) BOOL                                 isShowSubView;
@property (nonatomic, assign) CGFloat                             contentHeight;
@end
@implementation AbuCandChartView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initConfig];
        [self calcuteCandleWidth];
    }
    return self;
}

-(void)initConfig
{
    self.kvoEnable = YES;
    self.isRefresh = YES;
    self.chartSize = orignChartScale;
    self.isShowSubView = YES;
}

- (void)reloadKline
{
    [self updateWidth];
    [self drawKLine];
}

#pragma mark KVO

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    _scrollView = (UIScrollView*)self.superview;
    _scrollView.delegate = self;
    [self addListener];
}

- (void)addListener
{
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.KVOController = KVOController;
    WS(weakSelf);
    [self.KVOController observe:_scrollView keyPath:ContentOffSet options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (self.kvoEnable)
        {
            weakSelf.contentOffset = weakSelf.scrollView.contentOffset.x;
            weakSelf.previousOffsetX = weakSelf.scrollView.contentSize.width  -weakSelf.scrollView.contentOffset.x;
            [weakSelf drawKLine];
        }
    }];
}
- (void)setKvoEnable:(BOOL)kvoEnable
{
    _kvoEnable = kvoEnable;
}

- (NSInteger)currentStartIndex
{
    CGFloat scrollViewOffsetX = self.leftPostion < 0 ? 0 : self.leftPostion;
    
    NSInteger leftArrCount = (scrollViewOffsetX) / (self.candleWidth+self.candleSpace);
    
    if (leftArrCount > self.dataArray.count)
    {
        _currentStartIndex = self.dataArray.count - 1;
    }
    
    else if (leftArrCount == 0)
    {
        _currentStartIndex = 0;
    }
    
    else
    {
        _currentStartIndex =  leftArrCount ;
    }
    return _currentStartIndex;
}

- (CGFloat)leftPostion
{
    CGFloat scrollViewOffsetX = _contentOffset <  0  ?  0 : _contentOffset;
    if (scrollViewOffsetX == 0) {
        scrollViewOffsetX = 10;
    }
    if (_contentOffset + self.scrollView.width >= self.scrollView.contentSize.width)
    {
        scrollViewOffsetX = self.scrollView.contentSize.width - self.scrollView.width;
    }
    return scrollViewOffsetX;
}

- (void)initCurrentDisplayModels
{
    NSInteger needDrawKLineCount = self.scrollView.width / self.candleWidth;
    NSInteger currentStartIndex = self.currentStartIndex;
    NSInteger count = (currentStartIndex + needDrawKLineCount) >self.dataArray.count ? self.dataArray.count :currentStartIndex+needDrawKLineCount;
    [self.currentDisplayArray removeAllObjects];
    
    if (currentStartIndex < count)
    {
        for (NSInteger i = currentStartIndex; i <  count ; i++)
        {
            KLineModel *model = self.dataArray[i];
            [self.currentDisplayArray addObject:model];
        }
    }
}

- (void)calcuteMaxAndMinValue
{
    self.maxAssert = CGFLOAT_MIN;
    self.minAssert  = CGFLOAT_MAX;
    NSInteger idx = 0;
    for (NSInteger i = idx; i < self.currentDisplayArray.count; i++)
    {
        KLineModel * entity = [self.currentDisplayArray objectAtIndex:i];
        self.minAssert = self.minAssert < entity.lowPrice ? self.minAssert : entity.lowPrice;
        self.maxAssert = self.maxAssert > entity.highPrice ? self.maxAssert : entity.highPrice;
        
        if (self.maxAssert - self.minAssert < 0.5)
        {
            self.maxAssert += 0.5;
            self.minAssert  -=  0.5;
        }
    }
    CGFloat contentHeigh = self.scrollView.height / self.chartSize - topDistance - timeheight- topDistance;
    self.contentHeight = contentHeigh;
    self.heightPerpoint = contentHeigh / (self.maxAssert-self.minAssert);
}

- (void)drawMALineLayer
{
    if (IsArrayNull(self.currentDisplayArray)) {
        return;
    }
    if (self.ma5LineLayer)
    {
        [self.ma5LineLayer removeFromSuperlayer];
    }
    self.ma5LineLayer = [[KlineMALayer alloc] initQuotaDataArr:self.currentDisplayArray candleWidth:self.candleWidth candleSpace:self.candleSpace startIndex:self.leftPostion maxValue:self.maxAssert heightPerpoint:self.heightPerpoint totalHeight:0 lineWidth:1 lineColor:[UIColor greenColor] wireType:MA5TYPE klineSubOrMain:Main];
    [self.layer addSublayer:self.ma5LineLayer];
    

    if (self.ma10LineLayer)
    {
        [self.ma10LineLayer removeFromSuperlayer];
    }
    self.ma10LineLayer = [[KlineMALayer alloc] initQuotaDataArr:self.currentDisplayArray candleWidth:self.candleWidth candleSpace:self.candleSpace startIndex:self.leftPostion maxValue:self.maxAssert heightPerpoint:self.heightPerpoint totalHeight:0 lineWidth:1 lineColor:[UIColor redColor] wireType:MA10TYPE  klineSubOrMain:Main];
    [self.layer addSublayer:self.ma10LineLayer];
    
    if (self.ma20LineLayer)
    {
        [self.ma20LineLayer removeFromSuperlayer];
    }
    self.ma20LineLayer = [[KlineMALayer alloc] initQuotaDataArr:self.currentDisplayArray candleWidth:self.candleWidth candleSpace:self.candleSpace startIndex:self.leftPostion maxValue:self.maxAssert heightPerpoint:self.heightPerpoint totalHeight:0 lineWidth:1 lineColor:[UIColor blueColor] wireType:MA20TYPE  klineSubOrMain:Main];
    [self.layer addSublayer:self.ma20LineLayer];
    
}



#pragma mark publicMethod

- (CAShapeLayer*)getAxispLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithHexString:@"#ededed"].CGColor;
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

- (void)calcuteCandleWidth
{
    self.candleWidth = minCandelWith;
}

- (void)drawKLine
{
    [self drawMainKline];
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadPriceViewWithPriceArr:)]) {
        NSArray * priceArray = [self calculatePrcieArrWhenScroll];
        [self.delegate reloadPriceViewWithPriceArr:priceArray];
    }
    [self drawPresetQuota:KlineSubKPITypeMACD];
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCurrentPrice:candleModel:)]) {
        KLineModel * model = self.currentDisplayArray.lastObject;
        KLineModel *candelModel = self.currentDisplayArray.lastObject;
        [self.delegate refreshCurrentPrice:model candleModel:candelModel];
    }
}

- (void)drawMainKline
{
    [self drawCandelLayer];
    [self drawMALineLayer];
     [self drawTimeLayer];
}

- (void)drawCandelLayer
{
  
    [self initCurrentDisplayModels];
    [self calcuteMaxAndMinValue];
    if (self.delegate && [self.delegate respondsToSelector: @selector(displayScreenleftPostion:startIndex:count:)])
    {
        [_delegate displayScreenleftPostion:self.leftPostion startIndex:self.currentStartIndex count:self.currentDisplayArray.count];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(displayLastModel:)])
    {
        KLineModel *lastModel = self.currentDisplayArray.lastObject;
        [_delegate displayLastModel:lastModel];
    }
    if (self.candelLayer)
    {
        [self.candelLayer removeFromSuperlayer];
    }
    self.candelLayer = [[KlineCandelLayer alloc] initQuotaDataArr:self.currentDisplayArray candleWidth:self.candleWidth candleSpace:self.candleSpace startIndex:self.leftPostion maxValue:self.maxAssert heightPerpoint:self.heightPerpoint scrollViewContentWidth:self.scrollView.contentSize.width];
    [self.layer addSublayer:self.candelLayer];
}

- (void)drawTimeLayer
{
    if (self.timeLayer)
    {
        [self.timeLayer removeFromSuperlayer];
        self.timeLayer = nil;
    }
    self.timeLayer = [[KlineTimeLayer alloc] initQuotaDataArr:self.currentDisplayArray candleWidth:self.candleWidth height:self.scrollView.height / self.chartSize timeHight:timeheight bottomMargin:0 lineWidth:0];
    [self.layer addSublayer:self.timeLayer];
}

- (NSArray *)calculatePrcieArrWhenScroll
{
    NSMutableArray *priceArr = [NSMutableArray array];
    
    for (int i = 5; i>=0; i--) {
        
        if (i==5) {
            
            [priceArr addObject:@(self.maxAssert)];
            continue;
        }
        if (i==0) {
            
            [priceArr addObject:@(self.minAssert)];
            continue;
        }
        [priceArr addObject:@((self.minAssert + ((self.contentHeight/5)*i/self.heightPerpoint)))];
    }
    return [priceArr copy];
}

- (void)updateWidth
{
    CGFloat klineWidth = self.dataArray.count * (self.candleWidth + self.candleSpace) + 5;
    
    if(klineWidth < self.scrollView.width)
    {
        klineWidth = self.scrollView.width;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(klineWidth));
    }];
    
    self.scrollView.contentSize = CGSizeMake(klineWidth,0);
    if (self.isRefresh) {
       self.scrollView.contentOffset = CGPointMake(klineWidth - self.scrollView.width, 0);
    }
    
}



-(CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion
{
    CGFloat localPostion = xPostion;
    NSInteger startIndex = (NSInteger)((localPostion - self.leftPostion) / (self.candleSpace + self.candleWidth));
    NSInteger arrCount = self.currentDisplayArray.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        KLineModel *kLinePositionModel = self.currentDisplayArray[index];
        CGFloat minX = kLinePositionModel.highestPoint.x - (self.candleSpace + self.candleWidth/2);
        CGFloat maxX = kLinePositionModel.highestPoint.x + (self.candleSpace + self.candleWidth/2);
        if(localPostion > minX && localPostion < maxX)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(longPressCandleViewWithIndex:kLineModel:)])
            {
                [self.delegate longPressCandleViewWithIndex:index kLineModel:self.currentDisplayArray[index]];
            }
            return CGPointMake(kLinePositionModel.highestPoint.x, kLinePositionModel.opensPoint.y);
        }
    }
    
    KLineModel *lastPositionModel = self.currentDisplayArray.lastObject;
    
    if (localPostion >= lastPositionModel.closesPoint.x)
    {
        return CGPointMake(lastPositionModel.highestPoint.x, lastPositionModel.opensPoint.y);
    }
    KLineModel *firstPositionModel = self.currentDisplayArray.firstObject;
    if (firstPositionModel.closesPoint.x >= localPostion)
    {
        return CGPointMake(firstPositionModel.highestPoint.x, firstPositionModel.opensPoint.y);
    }
    return CGPointZero;
}

- (void)drawPresetQuota:(KlineSubKPIType)presetQuotaName;
{
    if (self.isShowSubView) {
        [self calcuteQuotaMaxAssertAndMinAssert:presetQuotaName];
        switch (presetQuotaName) {
            case KlineSubKPITypeMACD:
                [self drawPresetMACD];
                break;
            case KlineSubKPITypeKD:
                [self drawPresetKD];
                break;
            case KlineSubKPITypeW_R:
                [self drawPresetWR];
                break;
            default:
                break;
        }
    }
    else
    {
        [self removeSubSubLayers];
    }
    
}

- (void)drawPresetMACD
{
    if (self.macdLayer) {
        [self.macdLayer removeFromSuperlayer];
    }
    self.macdLayer = [[KlineQuotaColumnLayer alloc] initQuotaDataArr:self.currentDisplayArray candleWidth:self.candleWidth candleSpace:self.candleSpace startIndex:self.leftPostion maxValue:self.quotaMaxAssert heightPerpoint:self.quotaHeightPerPoint qutoaHeight:self.scrollView.height * orignIndicatorOrignY];
    [self.layer addSublayer:self.macdLayer];
    if (self.diffLayer) {
        [self.diffLayer removeFromSuperlayer];
    }
    self.diffLayer = [[KlineMALayer alloc] initQuotaDataArr:self.currentDisplayArray candleWidth:self.candleWidth candleSpace:self.candleSpace startIndex:self.leftPostion maxValue:self.quotaMaxAssert heightPerpoint:self.quotaHeightPerPoint totalHeight:self.scrollView.height *orignIndicatorOrignY lineWidth:1 lineColor:[UIColor yellowColor] wireType:MACDDIFF klineSubOrMain:Sub];
    [self.layer addSublayer:self.diffLayer];
    if (self.deaLayer) {
        [self.deaLayer removeFromSuperlayer];
    }
    self.deaLayer = [[KlineMALayer alloc] initQuotaDataArr:self.currentDisplayArray candleWidth:self.candleWidth candleSpace:self.candleSpace startIndex:self.leftPostion maxValue:self.quotaMaxAssert heightPerpoint:self.quotaHeightPerPoint totalHeight:self.scrollView.height *orignIndicatorOrignY lineWidth:1 lineColor:[UIColor purpleColor] wireType:MACDDEA klineSubOrMain:Sub];
    [self.layer addSublayer:self.deaLayer];
}
- (void)drawPresetKD
{
    if (self.kLineLayer) {
        [self.kLineLayer removeFromSuperlayer];
    }
    self.kLineLayer = [[KlineMALayer alloc] initQuotaDataArr:self.currentDisplayArray candleWidth:self.candleWidth candleSpace:self.candleSpace startIndex:self.leftPostion maxValue:self.quotaMaxAssert heightPerpoint:self.quotaHeightPerPoint totalHeight:self.scrollView.height *orignIndicatorOrignY  lineWidth:1 lineColor:[UIColor yellowColor] wireType:KDJ_K klineSubOrMain:Sub];
    [self.layer addSublayer:self.kLineLayer];
    if (self.dLineLayer) {
        [self.dLineLayer removeFromSuperlayer];
    }
    self.dLineLayer = [[KlineMALayer alloc] initQuotaDataArr:self.currentDisplayArray candleWidth:self.candleWidth candleSpace:self.candleSpace startIndex:self.leftPostion maxValue:self.quotaMaxAssert heightPerpoint:self.quotaHeightPerPoint totalHeight:self.scrollView.height *orignIndicatorOrignY lineWidth:1 lineColor:[UIColor orangeColor] wireType:KDJ_D klineSubOrMain:Sub];
    [self.layer addSublayer:self.dLineLayer];
}
- (void)drawPresetWR
{
    if (self.wrLineLayer) {
        [self.wrLineLayer removeFromSuperlayer];
    }
    self.wrLineLayer = [[KlineMALayer alloc] initQuotaDataArr:self.currentDisplayArray candleWidth:self.candleWidth candleSpace:self.candleSpace startIndex:self.leftPostion maxValue:self.quotaMaxAssert heightPerpoint:self.quotaHeightPerPoint totalHeight:self.scrollView.height *orignIndicatorOrignY  lineWidth:1 lineColor:[UIColor orangeColor] wireType:KLINE_WR klineSubOrMain:Sub];
    [self.layer addSublayer:self.wrLineLayer];
}
- (void)calcuteQuotaMaxAssertAndMinAssert:(KlineSubKPIType)subType
{
    NSDictionary *resultDic;
    CGFloat contentHeigh = self.scrollView.height * orignIndicatorOrignY - midDistance;
    if (subType == KlineSubKPITypeMACD) {
        NSMutableArray * DEAArray = [NSMutableArray array];
        NSMutableArray * DIFArray = [NSMutableArray array];
        NSMutableArray * MACDArray = [NSMutableArray array];
        for (NSInteger i = 0;i<self.currentDisplayArray.count;i++)
        {
            KLineModel *macdData = [self.currentDisplayArray objectAtIndex:i];
            [DIFArray addObject:[NSNumber numberWithFloat:[macdData.DEA floatValue]]];
            [DIFArray addObject:[NSNumber numberWithFloat:[macdData.DIF floatValue]]];
            [MACDArray addObject:[NSNumber numberWithFloat:[macdData.MACD floatValue]]];
        }
        resultDic = [[KLineCalculate sharedInstance] calculateMaxAndMinValueWithDataArr:@[DEAArray,MACDArray,DIFArray]];
        self.quotaMaxAssert = [resultDic[kMaxValue] floatValue];
        self.quotaMinAssert = [resultDic[kMinValue] floatValue];
        contentHeigh = self.scrollView.height * orignIndicatorScale - midDistance;
         self.quotaHeightPerPoint = (self.quotaMaxAssert - self.quotaMinAssert) / contentHeigh;
    }
    if (subType == KlineSubKPITypeKD) {
        NSMutableArray * KArray = [NSMutableArray array];
        NSMutableArray * DArray = [NSMutableArray array];
        for (NSInteger i = 0;i<self.currentDisplayArray.count;i++)
        {
            KLineModel *macdData = [self.currentDisplayArray objectAtIndex:i];
            [KArray addObject:@(macdData.K)];
            [DArray addObject:@(macdData.D)];
        }
        resultDic = [[KLineCalculate sharedInstance] calculateMaxAndMinValueWithDataArr:@[KArray,DArray]];
        self.quotaMaxAssert = [resultDic[kMaxValue] floatValue];
        self.quotaMinAssert = [resultDic[kMinValue] floatValue];
        self.quotaHeightPerPoint = contentHeigh/(self.quotaMaxAssert-self.quotaMinAssert);
    }
    if (subType == KlineSubKPITypeW_R) {
        NSMutableArray * WRArray = [NSMutableArray array];
        for (NSInteger i = 0;i<self.currentDisplayArray.count;i++)
        {
            KLineModel *model = [self.currentDisplayArray objectAtIndex:i];
            [WRArray addObject:@(model.WR)];
        }
        resultDic = [[KLineCalculate sharedInstance] calculateMaxAndMinValueWithDataArr:@[WRArray]];
        self.quotaMaxAssert = [resultDic[kMaxValue] floatValue];
        self.quotaMinAssert = [resultDic[kMinValue] floatValue];
        self.quotaHeightPerPoint = contentHeigh/(self.quotaMaxAssert-self.quotaMinAssert);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadPriceViewWithQuotaMaxValue:MinValue:)]) {
        [self.delegate reloadPriceViewWithQuotaMaxValue:self.quotaMaxAssert MinValue:self.quotaMinAssert];
    }
    
}

- (void)removeSubSubLayers
{
    if (self.macdLayer) {
        [self.macdLayer removeFromSuperlayer];
        self.macdLayer = nil;
    }
    if (self.deaLayer) {
        [self.deaLayer removeFromSuperlayer];
        self.deaLayer = nil;
    }
    if (self.diffLayer) {
        [self.diffLayer removeFromSuperlayer];
        self.diffLayer = nil;
    }
    if (self.kLineLayer) {
        [self.kLineLayer removeFromSuperlayer];
        self.kLineLayer = nil;
    }
    if (self.dLineLayer) {
        [self.dLineLayer removeFromSuperlayer];
        self.dLineLayer = nil;
    }
    if (self.wrLineLayer) {
        [self.wrLineLayer removeFromSuperlayer];
        self.wrLineLayer = nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x<0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(displayMoreData)])
        {
            self.previousOffsetX = _scrollView.contentSize.width  -_scrollView.contentOffset.x;
            [_delegate displayMoreData];
            
        }
    }
}

- (NSMutableArray *)currentDisplayArray
{
    if (!_currentDisplayArray) {
        _currentDisplayArray = [NSMutableArray array];
    }
    return _currentDisplayArray;
}

@end
