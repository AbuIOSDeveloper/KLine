//
//  AbuCandChartView.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuCandChartView.h"



#define MINDISPLAYCOUNT 6

static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@interface AbuCandChartView()<UIScrollViewDelegate,AbuChartViewProtocol>

@property (nonatomic,strong) UIScrollView    *scrollView;

@property (nonatomic, strong) FBKVOController * KVOController;

@property (nonatomic, assign) BOOL              isRefresh;

@property (nonatomic, strong) NSMutableArray  * maPostionArray;

@property (nonatomic, strong) CAShapeLayer    * lineChartLayer;
@property (nonatomic, strong) CAShapeLayer    * ma5LineLayer;
@property (nonatomic, strong) CAShapeLayer    * ma10LineLayer;
@property (nonatomic, strong) CAShapeLayer    * ma20LineLayer;
@property (nonatomic, strong) CAShapeLayer    * timeLayer;
@property (nonatomic, assign) CGFloat           timeLayerHeight;

@property (nonatomic, strong) NSMutableArray  * deaPostionArray;

@property (nonatomic, strong) NSMutableArray  * diffPostionArray;

@property (nonatomic, strong) NSMutableArray  * macdCandlePostionArray;
@property (nonatomic, strong) CAShapeLayer    * macdLayer;
@property (nonatomic, strong) CAShapeLayer    * deaLayer;
@property (nonatomic, strong) CAShapeLayer    * diffLayer;

@property (nonatomic, strong) NSMutableArray  * KPostionArray;

@property (nonatomic, strong) NSMutableArray  * DPostionArray;

@property (nonatomic, strong) NSMutableArray  * JPostionArray;

@property (nonatomic,strong) CAShapeLayer   * kLineLayer;

@property (nonatomic,strong) CAShapeLayer   * dLineLayer;

@property (nonatomic,strong) CAShapeLayer   * jLineLayer;

@property (nonatomic, strong) NSMutableArray  * wrPostionArray;

@property (nonatomic,strong) CAShapeLayer   * wrLineLayer;

@property (nonatomic,assign) UIInterfaceOrientation orientation;

@property (nonatomic,assign) float chartSize;
@property (nonatomic,assign) BOOL  isShowSubView;


@end
@implementation AbuCandChartView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark KVO

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    _scrollView = (UIScrollView*)self.superview;
    _scrollView.delegate = self;
    [self addListener];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
- (void)isShowOrHiddenIditionChart:(BOOL)isShow
{
    self.isShowSubView = isShow;
    if (isShow) {
        self.chartSize = orignScale;
 
    }
    else
    {
        self.chartSize = orignChartScale;

    }
    [self drawKLine];
}
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    self.orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
    }
    if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
       
    }
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
    self.maxY = CGFLOAT_MIN;
    self.minY  = CGFLOAT_MAX;
    NSInteger idx = 0;
    for (NSInteger i = idx; i < self.currentDisplayArray.count; i++)
    {
        KLineModel * entity = [self.currentDisplayArray objectAtIndex:i];
        self.minY = self.minY < entity.lowPrice ? self.minY : entity.lowPrice;
        self.maxY = self.maxY > entity.highPrice ? self.maxY : entity.highPrice;
        
        if (self.maxY - self.minY < 0.5)
        {
            self.maxY += 0.5;
            self.minY  -=  0.5;
        }
    }
    
    CGFloat contentHeigh = self.scrollView.height / self.chartSize - self.topMargin - self.timeLayerHeight - self.topMargin;
    self.scaleY = contentHeigh / (self.maxY-self.minY);
}

- (void)calcuteMaLinePostion
{
    [self.maPostionArray removeAllObjects];
        NSMutableArray * MA5Array = [NSMutableArray array];
        NSMutableArray * MA10Array = [NSMutableArray array];
        NSMutableArray * MA20Array = [NSMutableArray array];
        for (NSInteger i = 0;i <self.currentDisplayArray.count; i++)
            {
            KLineModel *until = self.currentDisplayArray[i];

            CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * i) + self.candleWidth/2;
            
                if ([until.MA5 floatValue] > 0) {
                    CGFloat yPositionMA5 = ((self.maxY - [until.MA5 floatValue]) * self.scaleY) + topDistance;
                    AbuKlineModel *model = [AbuKlineModel  initxPositon:xPosition yPosition:yPositionMA5 color:[UIColor greenColor]];
                    [MA5Array addObject:model];
                }
                if ([until.MA10 floatValue] > 0) {
                    CGFloat yPositionMA10 = ((self.maxY - [until.MA10 floatValue]) * self.scaleY) + topDistance;
                    AbuKlineModel *model = [AbuKlineModel  initxPositon:xPosition yPosition:yPositionMA10 color:[UIColor redColor]];
                    [MA10Array addObject:model];
                }
               if ([until.MA20 floatValue] > 0) {
                    CGFloat yPositionMA20 = ((self.maxY - [until.MA20 floatValue]) * self.scaleY) + topDistance;
                    AbuKlineModel *model = [AbuKlineModel  initxPositon:xPosition yPosition:yPositionMA20 color:[UIColor purpleColor]];
                    [MA20Array addObject:model];
                }
                [self.maPostionArray addObject:MA5Array];
                [self.maPostionArray addObject:MA10Array];
                [self.maPostionArray addObject:MA20Array];
        }
}

- (void)initModelPositoin
{
    [self.currentPostionArray removeAllObjects];
    for (NSInteger i = 0 ; i < self.currentDisplayArray.count; i++)
    {
        KLineModel *entity  = [self.currentDisplayArray objectAtIndex:i];
        CGFloat open = ((self.maxY - entity.openPrice) * self.scaleY);
        CGFloat close = ((self.maxY - entity.closePrice) * self.scaleY);
        CGFloat high = ((self.maxY - entity.highPrice) * self.scaleY);
        CGFloat low = ((self.maxY - entity.lowPrice) * self.scaleY);
        CGFloat left = self.leftPostion+ ((self.candleWidth + self.candleSpace) * i);

        if (left >= self.scrollView.contentSize.width)
        {
            left = self.scrollView.contentSize.width - self.candleWidth/2.f;
        }
        
        
        AbuPostionModel *positionModel = [AbuPostionModel itemWithOpen:CGPointMake(left, open) close:CGPointMake(left, close) high:CGPointMake(left, high) low:CGPointMake(left,low) date:entity.timeStr];
        positionModel.isDrawDate = entity.isDrawDate;
        [self.currentPostionArray addObject:positionModel];
    }
}

- (void)removeAllSubLayers
{
    for (NSInteger i = 0 ; i < self.lineChartLayer.sublayers.count; i++)
    {
        CAShapeLayer *layer = (CAShapeLayer*)self.lineChartLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
    
    for (NSInteger i = 0 ; i < self.timeLayer.sublayers.count; i++)
    {
        id layer = self.timeLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
    for (NSInteger i = 0 ; i < self.macdLayer.sublayers.count; i++)
    {
        id layer = self.macdLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
}

- (void)initLayer
{
    if (self.timeLayer)
    {
        [self.timeLayer removeFromSuperlayer];
        self.timeLayer = nil;
    }
    
    if (!self.timeLayer)
    {
        self.timeLayer = [CAShapeLayer layer];
        self.timeLayer.contentsScale = [UIScreen mainScreen].scale;
        self.timeLayer.strokeColor = [UIColor clearColor].CGColor;
        self.timeLayer.fillColor = [UIColor clearColor].CGColor;
    }
    [self.layer addSublayer:self.timeLayer];
    
    if (self.lineChartLayer)
    {
        [self.lineChartLayer removeFromSuperlayer];
        self.lineChartLayer = nil;
    }
    
    if (!self.lineChartLayer)
    {
        self.lineChartLayer = [CAShapeLayer layer];
        self.lineChartLayer.strokeColor = [UIColor clearColor].CGColor;
        self.lineChartLayer.fillColor = [UIColor clearColor].CGColor;
    }
    [self.layer addSublayer:self.lineChartLayer];
    
    //ma5
    if (self.ma5LineLayer)
    {
        [self.ma5LineLayer removeFromSuperlayer];
    }
    
    if (!self.ma5LineLayer)
    {
        self.ma5LineLayer = [CAShapeLayer layer];
        self.ma5LineLayer.lineWidth = self.lineWidth;
        self.ma5LineLayer.lineCap = kCALineCapRound;
        self.ma5LineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.ma5LineLayer];
    
    //ma10
    if (self.ma10LineLayer)
    {
        [self.ma10LineLayer removeFromSuperlayer];
    }
    
    if (!self.ma10LineLayer)
    {
        self.ma10LineLayer = [CAShapeLayer layer];
        self.ma10LineLayer.lineWidth = self.lineWidth;
        self.ma10LineLayer.lineCap = kCALineCapRound;
        self.ma10LineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.ma10LineLayer];
    
    //ma20
    if (self.ma20LineLayer)
    {
        [self.ma20LineLayer removeFromSuperlayer];
    }
    
    if (!self.ma20LineLayer)
    {
        self.ma20LineLayer = [CAShapeLayer layer];
        self.ma20LineLayer.lineWidth = self.lineWidth;
        self.ma20LineLayer.lineCap = kCALineCapRound;
        self.ma20LineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.ma20LineLayer];

    //KLayer
    if (self.kLineLayer)
    {
        [self.kLineLayer removeFromSuperlayer];
    }
    if (!self.kLineLayer)
    {
        self.kLineLayer = [CAShapeLayer layer];
        self.kLineLayer.lineWidth = self.lineWidth;
        self.kLineLayer.lineCap = kCALineCapRound;
        self.kLineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.kLineLayer];
    
    //dLayer
    if (self.dLineLayer)
    {
        [self.dLineLayer removeFromSuperlayer];
    }
    
    if (!self.dLineLayer)
    {
        self.dLineLayer = [CAShapeLayer layer];
        self.dLineLayer.lineWidth = self.lineWidth;
        self.dLineLayer.lineCap = kCALineCapRound;
        self.dLineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.dLineLayer];
    
    //jLayer
    if (self.jLineLayer)
    {
        [self.jLineLayer removeFromSuperlayer];
    }
    
    if (!self.jLineLayer)
    {
        self.jLineLayer = [CAShapeLayer layer];
        self.jLineLayer.lineWidth = self.lineWidth;
        self.jLineLayer.lineCap = kCALineCapRound;
        self.jLineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.jLineLayer];
    
    //wrLayer
    if (self.wrLineLayer)
    {
        [self.wrLineLayer removeFromSuperlayer];
    }
    
    if (!self.wrLineLayer)
    {
        self.wrLineLayer = [CAShapeLayer layer];
        self.wrLineLayer.lineWidth = self.lineWidth;
        self.wrLineLayer.lineCap = kCALineCapRound;
        self.wrLineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.wrLineLayer];
}

- (CAShapeLayer*)getShaperLayer:(AbuPostionModel*)postion
{
    CGFloat openPrice = postion.openPoint.y + self.topMargin;
    CGFloat closePrice = postion.closePoint.y + self.topMargin;
    CGFloat hightPrice = postion.highPoint.y + self.topMargin;
    CGFloat lowPrice = postion.lowPoint.y + self.topMargin;
    CGFloat x = postion.openPoint.x;
    UIBezierPath *path = [UIBezierPath drawKLine:openPrice close:closePrice high:hightPrice low:lowPrice candleWidth:self.candleWidth xPostion:x lineWidth:self.lineWidth];
    
    CAShapeLayer *subLayer = [CAShapeLayer layer];
    subLayer.fillColor = [UIColor clearColor].CGColor;
    if (postion.openPoint.y >= postion.closePoint.y)
    {
        subLayer.strokeColor = RISECOLOR.CGColor;
//        subLayer.fillColor = RISECOLOR.CGColor;
    }
    else
    {
        subLayer.strokeColor = DROPCOLOR.CGColor;
//        subLayer.fillColor = DROPCOLOR.CGColor;
    }
    subLayer.path = path.CGPath;
    [path removeAllPoints];
    return subLayer;
}

- (void)drawCandleSublayers
{
    WS(weakSelf);
    [_currentPostionArray enumerateObjectsUsingBlock:^(AbuPostionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *subLayer = [weakSelf getShaperLayer:obj];
        [weakSelf.lineChartLayer addSublayer:subLayer];
    }];
}
- (void)drawMALineLayer
{

    UIBezierPath *ma5Path = [UIBezierPath drawLine:self.maPostionArray[0]];
    self.ma5LineLayer.path = ma5Path.CGPath;
    self.ma5LineLayer.strokeColor = [UIColor blueColor].CGColor;
    self.ma5LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma5LineLayer.contentsScale = [UIScreen mainScreen].scale;

    UIBezierPath *ma10Path =  [UIBezierPath drawLine:self.maPostionArray[1]];

    self.ma10LineLayer.path = ma10Path.CGPath;
    self.ma10LineLayer.strokeColor = [UIColor redColor].CGColor;
    self.ma10LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma10LineLayer.contentsScale = [UIScreen mainScreen].scale;

    UIBezierPath *ma25Path = [UIBezierPath drawLine:self.maPostionArray[2]];
    self.ma20LineLayer.path = ma25Path.CGPath;
    self.ma20LineLayer.strokeColor = [UIColor purpleColor].CGColor;
    self.ma20LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma20LineLayer.contentsScale = [UIScreen mainScreen].scale;
}
- (void)drawMALayer
{
    [self calcuteMaLinePostion];
    [self drawMALineLayer];
}

- (void)drawTimeLayer
{
    [self.currentPostionArray enumerateObjectsUsingBlock:^(AbuPostionModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.isDrawDate)
        {
            CATextLayer *layer = [self getTextLayer];
            layer.string = model.date;
            if (isEqualZero(model.highPoint.x))
            {
                layer.frame =  CGRectMake(0, self.scrollView.height / self.chartSize - self.timeLayerHeight, 80, self.timeLayerHeight);
                
            }
            
            else
            {
                layer.position = CGPointMake(model.highPoint.x + self.candleWidth, self.scrollView.height / self.chartSize - self.timeLayerHeight/2 - self.bottomMargin);
                layer.bounds = CGRectMake(0, 0, 80, self.timeLayerHeight);
                
            }
            [self.timeLayer addSublayer:layer];

            CAShapeLayer *lineLayer = [self getAxispLayer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            path.lineWidth = self.lineWidth;
            lineLayer.lineWidth = self.lineWidth;
            
            [path moveToPoint:CGPointMake(model.highPoint.x + self.candleWidth/2 - self.lineWidth/2, 1*heightradio)];
            [path addLineToPoint:CGPointMake(model.highPoint.x + self.candleWidth/2 - self.lineWidth/2 ,self.scrollView.height / self.chartSize - self.timeLayerHeight - self.bottomMargin)];
            lineLayer.path = path.CGPath;
            lineLayer.lineDashPattern = @[@6,@10];
            [self.timeLayer addSublayer:lineLayer];
        }
    }];
}

- (void)drawAxisLine
{
    CGFloat klineWidth = (self.dataArray.count)*self.candleWidth+self.candleSpace*(self.dataArray.count);
    CAShapeLayer *bottomLayer = [self getAxispLayer];
    bottomLayer.lineWidth = self.lineWidth;
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    [bpath moveToPoint:CGPointMake(0, self.scrollView.height / self.chartSize - self.timeLayerHeight - self.bottomMargin)];
    [bpath addLineToPoint:CGPointMake(self.width, self.scrollView.height / self.chartSize - self.timeLayerHeight - self.bottomMargin)];
    bottomLayer.path = bpath.CGPath;
    [self.timeLayer addSublayer:bottomLayer];
    CAShapeLayer *centXLayer = [self getAxispLayer];
    UIBezierPath *xPath = [UIBezierPath bezierPath];
    [xPath moveToPoint:CGPointMake(0,(self.centerY  - self.timeLayerHeight - self.bottomMargin) / self.chartSize)];
    [xPath addLineToPoint:CGPointMake(klineWidth,(self.centerY  - self.timeLayerHeight - self.bottomMargin) / self.chartSize)];
    centXLayer.path = xPath.CGPath;
    centXLayer.lineDashPattern = @[@6,@10];
    centXLayer.lineWidth = self.lineWidth;
    [self.timeLayer addSublayer:centXLayer];
}

- (void)stockFill
{
    [self initConfig];
    [self initLayer];
    [self calcuteCandleWidth];
    [self updateWidth];
    [self drawKLine];
}

- (void)refreshKLineView:(KLineModel *)model
{
       if (self.previousOffsetX <= self.scrollView.width + 5) {
           self.isRefresh = YES;
          }
        else
         {
           self.isRefresh = NO;
        }

    [self updateWidth];
}

- (CATextLayer*)getTextLayer
{
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.fontSize = 12.f;
    layer.alignmentMode = kCAAlignmentLeft;
    layer.foregroundColor =
    [UIColor grayColor].CGColor;
    return layer;
}

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
    [self removeAllSubLayers];
    [self initCurrentDisplayModels];
    if (self.delegate && [self.delegate respondsToSelector: @selector(displayScreenleftPostion:startIndex:count:)])
    {
        [_delegate displayScreenleftPostion:self.leftPostion startIndex:self.currentStartIndex count:self.displayCount];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(displayLastModel:)])
    {
        KLineModel *lastModel = self.currentDisplayArray.lastObject;
        [_delegate displayLastModel:lastModel];
    }
    
    [self calcuteMaxAndMinValue];
    [self initLayer];
    [self initModelPositoin];
    [self drawCandleSublayers];
    [self drawMALayer];
    [self drawMacdLine];
    [self drawKDJLine];
    [self drawWrLine];
    [self drawTimeLayer];
    [self drawAxisLine];
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCurrentPrice:candleModel:)]) {
        AbuPostionModel * model = self.currentPostionArray.lastObject;
        KLineModel *candelModel = self.currentDisplayArray.lastObject;
        [self.delegate refreshCurrentPrice:model candleModel:candelModel];
    }
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

-(void)initConfig
{
    self.topMargin = topDistance;
    self.bottomMargin = 0;
    self.minHeight = 3;
    self.kvoEnable = YES;
    self.isRefresh = YES;
    self.timeLayerHeight = 15;
    self.chartSize = orignChartScale;
    self.isShowSubView = YES;
}

-(CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion
{
    CGFloat localPostion = xPostion;
    NSInteger startIndex = (NSInteger)((localPostion - self.leftPostion) / (self.candleSpace + self.candleWidth));
    NSInteger arrCount = self.currentPostionArray.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        AbuPostionModel *kLinePositionModel = self.currentPostionArray[index];
        CGFloat minX = kLinePositionModel.highPoint.x - (self.candleSpace + self.candleWidth/2);
        CGFloat maxX = kLinePositionModel.highPoint.x + (self.candleSpace + self.candleWidth/2);
        //判断临界点，不超过临界点的用代理传回当前的长按显示的第几个数及数据模型
        if(localPostion > minX && localPostion < maxX)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(longPressCandleViewWithIndex:kLineModel:)])
            {
                [self.delegate longPressCandleViewWithIndex:index kLineModel:self.currentDisplayArray[index]];
            }
            return CGPointMake(kLinePositionModel.highPoint.x, kLinePositionModel.openPoint.y);
        }
    }
    
    AbuPostionModel *lastPositionModel = self.currentPostionArray.lastObject;
    
    if (localPostion >= lastPositionModel.closePoint.x)
    {
        return CGPointMake(lastPositionModel.highPoint.x, lastPositionModel.openPoint.y);
    }
    AbuPostionModel *firstPositionModel = self.currentPostionArray.firstObject;
    if (firstPositionModel.closePoint.x >= localPostion)
    {
        return CGPointMake(firstPositionModel.highPoint.x, firstPositionModel.openPoint.y);
    }
    
    return CGPointZero;
}

- (void)removeMacdSubLayers
{
    for (NSInteger i = 0 ; i < self.macdLayer.sublayers.count; i++)
    {
        id layer = self.macdLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
    if (self.deaLayer) {
        [self.deaLayer removeFromSuperlayer];
    }
    if (self.diffLayer) {
        [self.diffLayer removeFromSuperlayer];
    }
}

- (void)initMacdSubLayers
{
    if (self.macdLayer)
    {
        [self.macdLayer removeFromSuperlayer];
        self.macdLayer = nil;
    }
    if (!self.macdLayer)
    {
        self.macdLayer = [CAShapeLayer layer];
        self.macdLayer.contentsScale = [UIScreen mainScreen].scale;
        self.macdLayer.strokeColor = [UIColor clearColor].CGColor;
        self.macdLayer.fillColor = [UIColor redColor].CGColor;
    }
    [self.layer addSublayer:self.macdLayer];
    
    if (self.diffLayer)
    {
        [self.diffLayer removeFromSuperlayer];
    }
    
    if (!self.diffLayer)
    {
        self.diffLayer = [CAShapeLayer layer];
        self.diffLayer.lineWidth = self.lineWidth;
        self.diffLayer.lineCap = kCALineCapRound;
        self.diffLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.diffLayer];
    
    if (self.deaLayer)
    {
        [self.deaLayer removeFromSuperlayer];
    }
    
    if (!self.deaLayer)
    {
        self.deaLayer = [CAShapeLayer layer];
        self.deaLayer.lineWidth = self.lineWidth;
        self.deaLayer.lineCap = kCALineCapRound;
        self.deaLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.deaLayer];
}

- (void)drawMacdLine
{
    [self removeMacdSubLayers];
    [self initMacdSubLayers];
    if (self.currentType == MACD) {
        [self removeKdjSubLayers];
        [self initMacdMaxAndMinValue];
        [self initMacdLinePostions];
        [self drawMacdCandleLine];
        [self drawDeaLine];
        [self drawDiffLine];
    }
    else
    {
        [self removeMacdSubLayers];
    }
}

- (void)initMacdMaxAndMinValue
{
    NSMutableArray * DEAArray = [NSMutableArray array];
    NSMutableArray * DIFArray = [NSMutableArray array];
    NSMutableArray * MACDArray = [NSMutableArray array];
    for (NSInteger i = 0;i<self.currentDisplayArray.count;i++)
    {
        KLineModel *macdData = [self.currentDisplayArray objectAtIndex:i];
        [DEAArray addObject:[NSNumber numberWithFloat:[macdData.DEA floatValue]]];
        [DIFArray addObject:[NSNumber numberWithFloat:[macdData.DIF floatValue]]];
        [MACDArray addObject:[NSNumber numberWithFloat:[macdData.MACD floatValue]]];
    }
    NSDictionary *resultDic = [[KLineCalculate sharedInstance] calculateMaxAndMinValueWithDataArr:@[DEAArray,MACDArray,DIFArray]];
    self.indicatorMaxY = [resultDic[kMaxValue] floatValue];
    self.indicatorMinY = [resultDic[kMinValue] floatValue];
    CGFloat contentHeigh = self.scrollView.height * orignIndicatorScale - midDistance - bottomDistance;
    self.indicatorScaleY = (self.indicatorMaxY - self.indicatorMinY) / contentHeigh;
}

- (void)initMacdLinePostions
{
    [self.macdCandlePostionArray removeAllObjects];
    [self.deaPostionArray removeAllObjects];
    [self.diffPostionArray removeAllObjects];
    for (int i = 0; i < self.currentDisplayArray.count; ++i) {
        KLineModel *lineData = [self.currentDisplayArray objectAtIndex:i];
        CGFloat xPosition = self.leftPostion + ((self.candleSpace+self.candleWidth) * i);
        CGFloat yPosition = ABS((self.indicatorMaxY - [lineData.MACD floatValue])/self.indicatorScaleY) + self.topMargin + bottomDistance + midDistance;
        //macd
        AbuMacadPostionModel *model = [[AbuMacadPostionModel alloc] init];
        model.endPoint = CGPointMake(xPosition, yPosition);
        model.startPoint = CGPointMake(xPosition,self.indicatorMaxY/self.indicatorScaleY + self.topMargin + midDistance + bottomDistance);
        
        float x = model.startPoint.y - model.endPoint.y;
        if (isEqualZero(x))
        {
            model.endPoint = CGPointMake(xPosition,self.indicatorMaxY/self.indicatorScaleY+1);
        }
        
        [self.macdCandlePostionArray addObject:model];
       // diff
        CGFloat diffPostion = ABS((self.indicatorMaxY - [lineData.DIF floatValue])/self.indicatorScaleY) +  self.scrollView.height * orignIndicatorOrignY + midDistance;
        AbuKlineModel *difModel = [AbuKlineModel initxPositon:xPosition+self.candleWidth/2 yPosition:diffPostion color:[UIColor redColor]];
        [self.diffPostionArray addObject:difModel];
        //dea
        CGFloat deayPostion = ABS((self.indicatorMaxY - [lineData.DEA floatValue])/self.indicatorScaleY) + self.scrollView.height * orignIndicatorOrignY + midDistance;
        AbuKlineModel *deaModel = [AbuKlineModel initxPositon:xPosition+self.candleWidth/2 yPosition:deayPostion color:[UIColor redColor]];
        [self.deaPostionArray addObject:deaModel];
    }
}
- (void)drawMacdCandleLine
{
    WS(weakSelf);
    [self.macdCandlePostionArray enumerateObjectsUsingBlock:^(AbuMacadPostionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *layer = [weakSelf drawMacdLayer:obj];
        [weakSelf.macdLayer addSublayer:layer];
    }];
}
- (CAShapeLayer*)drawMacdLayer:(AbuMacadPostionModel*)model
{
    CGRect rect;
       rect = CGRectMake(model.startPoint.x, model.startPoint.y - self.topMargin - self.timeLayerHeight +self.scrollView.height * orignIndicatorOrignY - self.bottomMargin, self.candleWidth, model.endPoint.y - model.startPoint.y);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    CAShapeLayer *subLayer = [CAShapeLayer layer];
    subLayer.path = path.CGPath;
    
    if (model.endPoint.y > model.startPoint.y)
    {
        subLayer.strokeColor = DROPCOLOR.CGColor;
        
        subLayer.fillColor = DROPCOLOR.CGColor;
    }
    else
    {
        subLayer.strokeColor = RISECOLOR.CGColor;
        subLayer.fillColor = RISECOLOR.CGColor;
    }
    return subLayer;
}
- (void)drawDiffLine
{
    UIBezierPath *diffPath = [UIBezierPath drawLine:self.diffPostionArray];
    _diffLayer.path = diffPath.CGPath;
    _diffLayer.strokeColor = [UIColor redColor].CGColor;
    _diffLayer.fillColor = [[UIColor clearColor] CGColor];
    _diffLayer.contentsScale = [UIScreen mainScreen].scale;
}

- (void)drawDeaLine
{
    UIBezierPath *deaPath = [UIBezierPath drawLine:self.deaPostionArray];
    _deaLayer.path = deaPath.CGPath;
    _deaLayer.strokeColor = [UIColor greenColor].CGColor;
    _deaLayer.fillColor = [[UIColor clearColor] CGColor];
    _deaLayer.contentsScale = [UIScreen mainScreen].scale;
}

- (void)removeKdjSubLayers
{
    if (self.kLineLayer) {
        [self.kLineLayer removeFromSuperlayer];
    }
    if (self.dLineLayer) {
        [self.dLineLayer removeFromSuperlayer];
    }
    if (self.jLineLayer) {
        [self.jLineLayer removeFromSuperlayer];
    }
}

- (void)drawKDJLine
{
    if (self.currentType == KDJ) {
        [self removeMacdSubLayers];
        [self initKdjMaxAndMinValue];
        [self initKdjLinePostions];
        [self drawKdjKline];
        [self drawKdjDline];
        [self drawKdjJline];
    }
    else
    {
        [self removeKdjSubLayers];
    }
}
- (void)initKdjMaxAndMinValue
{
    self.indicatorMaxY = CGFLOAT_MIN;
    self.indicatorMinY  = CGFLOAT_MAX;
    for (KLineModel *model in self.currentDisplayArray)
    {
            self.indicatorMinY = MIN([model.KDJ_K floatValue], MIN([model.KDJ_D floatValue], [model.KDJ_J floatValue]));
            self.indicatorMaxY = MAX([model.KDJ_K floatValue], MAX([model.KDJ_D floatValue], [model.KDJ_J floatValue]));
    }
    
    if (self.indicatorMaxY - self.indicatorMinY < 0.5)
    {
        self.indicatorMaxY += 0.5;
        self.indicatorMinY  += 0.5;
    }
    CGFloat contentHeigh = self.scrollView.height * orignIndicatorScale - midDistance - bottomDistance;
    self.indicatorScaleY = contentHeigh/(self.indicatorMaxY-self.indicatorMinY);
}
- (void)initKdjLinePostions
{
    [self.KPostionArray removeAllObjects];
    [self.DPostionArray removeAllObjects];
    [self.JPostionArray removeAllObjects];

    for (int i = 0; i < self.currentDisplayArray.count; i++)
    {
        KLineModel * model = _currentDisplayArray[i];
        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * i) + self.candleWidth/2;
        CGFloat yPositionK = ((self.indicatorMaxY - [model.KDJ_K floatValue]) *self.indicatorScaleY)  + self.scrollView.height * orignIndicatorOrignY + midDistance;
            AbuKlineModel *Kmodel = [AbuKlineModel  initxPositon:xPosition yPosition:yPositionK color:[UIColor redColor]];
        [self.KPostionArray addObject:Kmodel];
        
        CGFloat yPositionD = ((self.indicatorMaxY - [model.KDJ_D floatValue]) *self.indicatorScaleY)  + self.scrollView.height * orignIndicatorOrignY + midDistance;
        AbuKlineModel *Dmodel = [AbuKlineModel  initxPositon:xPosition yPosition:yPositionD color:[UIColor greenColor]];
        [self.DPostionArray addObject:Dmodel];
        
        CGFloat yPositionJ = ((self.indicatorMaxY - [model.KDJ_J floatValue]) *self.indicatorScaleY)  + self.scrollView.height * orignIndicatorOrignY + midDistance;
        AbuKlineModel *Jmodel = [AbuKlineModel  initxPositon:xPosition yPosition:yPositionJ color:[UIColor purpleColor]];
        [self.JPostionArray addObject:Jmodel];
        }
}

- (void)drawKdjKline
{
    UIBezierPath *diffPath = [UIBezierPath drawLine:self.KPostionArray];
    _kLineLayer.path = diffPath.CGPath;
    _kLineLayer.strokeColor = [UIColor redColor].CGColor;
    _kLineLayer.fillColor = [[UIColor clearColor] CGColor];
    _kLineLayer.contentsScale = [UIScreen mainScreen].scale;
}
- (void)drawKdjDline
{
    UIBezierPath *diffPath = [UIBezierPath drawLine:self.DPostionArray];
    _dLineLayer.path = diffPath.CGPath;
    _dLineLayer.strokeColor = [UIColor greenColor].CGColor;
    _dLineLayer.fillColor = [[UIColor clearColor] CGColor];
    _dLineLayer.contentsScale = [UIScreen mainScreen].scale;
}
- (void)drawKdjJline
{
    UIBezierPath *diffPath = [UIBezierPath drawLine:self.JPostionArray];
    _jLineLayer.path = diffPath.CGPath;
    _jLineLayer.strokeColor = [UIColor blueColor].CGColor;
    _jLineLayer.fillColor = [[UIColor clearColor] CGColor];
    _jLineLayer.contentsScale = [UIScreen mainScreen].scale;
}


-(void)drawWrLine
{
    if (self.currentType == WR) {
        [self initWrMaxAndMinValue];
        [self initWrPostionModels];
        [self drawWrKlineLayer];
    }
    else
    {
        [self.wrLineLayer removeFromSuperlayer];
    }
}

- (void)initWrMaxAndMinValue
{
    [self layoutIfNeeded];
    self.indicatorMaxY = CGFLOAT_MIN;
    self.indicatorMinY  = CGFLOAT_MAX;
    for (NSInteger i = 0;i<self.currentDisplayArray.count;i++)
    {
        self.indicatorMinY = 100;
        self.indicatorMaxY = 0;
    }
    
    if (self.indicatorMaxY - self.indicatorMinY < 0.5)
    {
        self.indicatorMaxY += 0.5;
        self.indicatorMinY += 0.5;
    }
    CGFloat contentHeigh = self.scrollView.height * orignIndicatorScale - midDistance - bottomDistance;
    self.indicatorScaleY = contentHeigh/(self.indicatorMaxY-self.indicatorMinY);
}

- (void)initWrPostionModels
{
    [self.wrPostionArray removeAllObjects];
    for (int i = 0; i < self.currentDisplayArray.count; ++i) {
        KLineModel * until = self.currentDisplayArray[i];
        CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * i) + self.candleWidth/2;
        CGFloat yPosition = ((self.indicatorMaxY - until.WR)*self.indicatorScaleY)  + self.scrollView.height * orignIndicatorOrignY + midDistance;
        AbuKlineModel *model = [AbuKlineModel  initxPositon:xPosition yPosition:yPosition color:[UIColor purpleColor]];
        [self.wrPostionArray addObject:model];
    }
}

- (void)drawWrKlineLayer
{
    UIBezierPath *wrPath = [UIBezierPath drawLine:self.wrPostionArray];
    self.wrLineLayer.path = wrPath.CGPath;
    self.wrLineLayer.strokeColor = [UIColor purpleColor].CGColor;
    self.wrLineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.wrLineLayer.contentsScale = [UIScreen mainScreen].scale;
}

#pragma mark scrollViewDelegate

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


#pragma mark  lazy懒加载

- (NSMutableArray *)currentDisplayArray
{
    if (!_currentDisplayArray) {
        _currentDisplayArray = [NSMutableArray array];
    }
    return _currentDisplayArray;
}

-(NSMutableArray *)currentPostionArray
{
    if (!_currentPostionArray) {
        _currentPostionArray = [NSMutableArray array];
    }
    return _currentPostionArray;
}

- (NSMutableArray *)maPostionArray
{
    if (!_maPostionArray) {
        _maPostionArray = [NSMutableArray array];
    }
    return _maPostionArray;
}

- (NSMutableArray *)macdCandlePostionArray
{
    if (!_macdCandlePostionArray) {
        _macdCandlePostionArray = [NSMutableArray array];
    }
    return _macdCandlePostionArray;
}

- (NSMutableArray *)deaPostionArray
{
    if (!_deaPostionArray) {
        _deaPostionArray = [NSMutableArray array];
    }
    return _deaPostionArray;
}

- (NSMutableArray *)diffPostionArray
{
    if (!_diffPostionArray) {
        _diffPostionArray = [NSMutableArray array];
    }
    return _diffPostionArray;
}

- (NSMutableArray *)KPostionArray
{
    if (!_KPostionArray) {
        _KPostionArray = [NSMutableArray array];
    }
    return _KPostionArray;
}

- (NSMutableArray *)DPostionArray
{
    if (!_DPostionArray) {
        _DPostionArray = [NSMutableArray array];
    }
    return _DPostionArray;
}

- (NSMutableArray *)JPostionArray
{
    if (!_JPostionArray) {
        _JPostionArray = [NSMutableArray array];
    }
    return _JPostionArray;
}

- (NSMutableArray *)wrPostionArray
{
    if (!_wrPostionArray) {
        _wrPostionArray = [NSMutableArray array];
    }
    return _wrPostionArray;
}

@end
