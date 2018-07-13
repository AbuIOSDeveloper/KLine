//
//  AbuMacdView.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/9.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuMacdView.h"

static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@interface AbuMacdView()<UIScrollViewDelegate,AbuChartViewProtocol>
//MCAD
@property (nonatomic, strong) CAShapeLayer *macdLayer;
@property (nonatomic,strong) NSMutableArray *displayArray;
@property (nonatomic,strong) NSMutableArray *macdArray;
@property (nonatomic,strong) NSMutableArray *deaArray;
@property (nonatomic,strong) NSMutableArray *diffArray;



/**
 * 最大Y值
 */
@property (nonatomic,assign) CGFloat maxY;
/**
 * 最小Y值
 */
@property (nonatomic,assign) CGFloat minY;
/**
 * 最大X值
 */
@property (nonatomic,assign) CGFloat maxX;
/**
 * 最小X值
 */
@property (nonatomic,assign) CGFloat minX;
/**
 * 最大尺寸Y值
 */
@property (nonatomic,assign) CGFloat scaleY;
/**
 * 最大尺寸X值
 */
@property (nonatomic,assign) CGFloat scaleX;
/**
 * 线的范围
 */
@property (nonatomic,assign) CGFloat lineSpace;
/**
 * 左边距
 */
@property (nonatomic,assign) CGFloat leftMargin;
/**
 * 右边距
 */
@property (nonatomic,assign) CGFloat rightMargin;
/**
 * 上边距
 */
@property (nonatomic,assign) CGFloat topMargin;
/**
 * 下边距
 */
@property (nonatomic,assign) CGFloat bottomMargin;

@property (nonatomic,strong) UIScrollView    *scrollView;

@property (nonatomic, strong) FBKVOController * KVOController;

/**
 * 当前偏移量
 */
@property (nonatomic,assign) CGFloat          contentOffset;



/**
 * 当前屏幕范围内显示的k线模型数组
 */
@property (nonatomic,strong) NSMutableArray * currentDisplayArray;

@property (nonatomic,weak) id <AbuChartViewProtocol> delegate;

/**
 * 滑到最右侧的偏移量
 */
@property (nonatomic,assign) CGFloat          previousOffsetX;

@property (nonatomic,strong) CAShapeLayer   * deaLayer;
@property (nonatomic,strong) CAShapeLayer   * diffLayer;

//KDJ
/**
 * K数据线
 */
@property (nonatomic,strong) CAShapeLayer   * kLineLayer;
/**
 * D数据线
 */
@property (nonatomic,strong) CAShapeLayer   * dLineLayer;
/**
 * J数据线
 */
@property (nonatomic,strong) CAShapeLayer   * jLineLayer;
/**
 * K数据线坐标数组
 */
@property (nonatomic,strong) NSMutableArray * kPostionArray;
/**
 * D数据线坐标数组
 */
@property (nonatomic,strong) NSMutableArray * dPostionArray;
/**
 * J数据线坐标数组
 */
@property (nonatomic,strong) NSMutableArray * jPostionArray;


@end

@implementation AbuMacdView

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
            [weakSelf drawKdjLine];
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
    NSInteger needDrawKLineCount = self.displayCount;
    NSInteger currentStartIndex = self.currentStartIndex;
    NSInteger count = (currentStartIndex + needDrawKLineCount) >self.dataArray.count ? self.dataArray.count :currentStartIndex+needDrawKLineCount;
    
    [self.currentDisplayArray removeAllObjects];
    
    if (currentStartIndex < count)
    {
        for (NSInteger i = currentStartIndex; i <  count ; i++)
        {
            AbuMacdModel *model = self.dataArray[i];
            [self.currentDisplayArray addObject:model];
        }
    }
    
    [self layoutIfNeeded];
}

#pragma mark MACD

//移除Mcad所有layer
- (void)removeMcadLayerFromSubLayer
{
    for (NSInteger i = 0 ; i < self.macdLayer.sublayers.count; i++)
    {
        CAShapeLayer *layer = (CAShapeLayer*)self.macdLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
    
    for (NSInteger i = 0; i < self.diffLayer.sublayers.count; i++) {
        CAShapeLayer * layer = (CAShapeLayer *)self.diffLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
    for (NSInteger i = 0; i < self.deaLayer.sublayers.count; i++) {
        CAShapeLayer * layer = (CAShapeLayer *)self.deaLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
}

//移除当前所有数组
- (void)removeMcadAllObjectFromArray
{
        [self.macdArray removeAllObjects];
        [self.deaArray removeAllObjects];
        [self.diffArray removeAllObjects];
}
//创建layer
- (void)initLayer
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

    if (self.deaLayer)
    {
        [self.deaLayer removeFromSuperlayer];
        self.deaLayer = nil;
    }
    
    if (!self.deaLayer)
    {
        self.deaLayer = [CAShapeLayer layer];
        self.deaLayer.contentsScale = [UIScreen mainScreen].scale;
        self.deaLayer.strokeColor = [UIColor clearColor].CGColor;
        self.deaLayer.fillColor = [UIColor redColor].CGColor;
    }
    [self.layer addSublayer:self.deaLayer];
    
    if (self.diffLayer)
    {
        [self.diffLayer removeFromSuperlayer];
        self.diffLayer = nil;
    }
    
    if (!self.diffLayer)
    {
        self.diffLayer = [CAShapeLayer layer];
        self.diffLayer.contentsScale = [UIScreen mainScreen].scale;
        self.diffLayer.strokeColor = [UIColor clearColor].CGColor;
        self.diffLayer.fillColor = [UIColor redColor].CGColor;
    }
    [self.layer addSublayer:self.diffLayer];
}

#pragma mark 计算Macd的displayArray


#pragma mark 当前屏幕显示的价格最大值与最小值
- (void)initMacdMaxAndMinValue
{
    CGFloat maxPrice = 0;
    CGFloat minPrice = 0;
    
    for (NSInteger i = 0;i<self.currentDisplayArray.count;i++)
    {
        AbuMacdModel *macdData = [self.currentDisplayArray objectAtIndex:i];
        maxPrice = MAX(maxPrice, MAX(macdData.dea, MAX(macdData.diff, macdData.macd)));
        minPrice = MIN(minPrice, MIN(macdData.dea, MIN(macdData.diff, macdData.macd)));
    }
    self.maxY = maxPrice;
    self.minY = minPrice;
    if (self.maxY - self.minY < 0.5)
    {
        self.maxY += 0.5;
        self.minY += 0.5;
    }
    self.topMargin = 0;
    self.bottomMargin = 5;
    self.scaleY = (self.maxY - self.minY) / (self.height - self.topMargin - self.bottomMargin);
}

#pragma mark 当前屏幕内MACD坐标模型
//计算MA数据坐标
- (void)initMaModelPosition
{
    [self.macdArray removeAllObjects];
    [self.deaArray removeAllObjects];
    [self.diffArray removeAllObjects];
    for (NSInteger i = 0;i < self.currentDisplayArray.count;i++)
    {
        AbuMacdModel *lineData = [self.currentDisplayArray objectAtIndex:i];
        CGFloat xPosition = self.leftPostion + ((self.candleSpace+self.candleWidth) * i) ;
        CGFloat yPosition = ABS((self.maxY - lineData.macd)/self.scaleY) + self.topMargin ;
        //macd
        AbuMacadPostionModel *model = [[AbuMacadPostionModel alloc] init];
        model.endPoint = CGPointMake(xPosition, yPosition);
        model.startPoint = CGPointMake(xPosition,self.maxY/self.scaleY);
        
        float x = model.startPoint.y - model.endPoint.y;
        if (isEqualZero(x))
        {
            //柱线的最小高度
            model.endPoint = CGPointMake(xPosition,self.maxY/self.scaleY+1);
        }
        
        [self.macdArray addObject:model];
        
//        diff
        CGFloat diffPostion = ABS((self.maxY - lineData.diff)/self.scaleY) +self.topMargin;
        AbuKlineModel *difModel = [AbuKlineModel initxPositon:xPosition+self.candleWidth/2 yPosition:diffPostion color:[UIColor redColor]];
        [self.diffArray addObject:difModel];
//
//        //dea
        CGFloat deayPostion = ABS((self.maxY - lineData.dea)/self.scaleY) + self.topMargin;
        AbuKlineModel *deaModel = [AbuKlineModel initxPositon:xPosition+self.candleWidth/2 yPosition:deayPostion color:[UIColor redColor]];
        [self.deaArray addObject:deaModel];
    }
}

#pragma mark MacdLine

- (void)drawMacdKline
{
    WS(weakSelf);
    [_macdArray enumerateObjectsUsingBlock:^(AbuMacadPostionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AbuMacdModel *model = weakSelf.currentDisplayArray[idx];
        
        CAShapeLayer *layer = [weakSelf drawMacdLayer:obj macdModel:model];
        [weakSelf.macdLayer addSublayer:layer];
    }];
    //deaPath线
    UIBezierPath *deaPath = [UIBezierPath drawLine:self.deaArray];
    _deaLayer.path = deaPath.CGPath;
    _deaLayer.strokeColor = [UIColor greenColor].CGColor;
    _deaLayer.fillColor = [[UIColor clearColor] CGColor];
    _deaLayer.contentsScale = [UIScreen mainScreen].scale;
    //diffPath线
    UIBezierPath *diffPath = [UIBezierPath drawLine:self.diffArray];
    _diffLayer.path = diffPath.CGPath;
    _diffLayer.strokeColor = [UIColor redColor].CGColor;
    _diffLayer.fillColor = [[UIColor clearColor] CGColor];
    _diffLayer.contentsScale = [UIScreen mainScreen].scale;
}

//柱状图
- (CAShapeLayer*)drawMacdLayer:(AbuMacadPostionModel*)model macdModel:(AbuMacdModel *)macdModel
{
    CGRect rect;
    if (model.startPoint.y<=0)
    {
        rect = CGRectMake(model.startPoint.x,self.topMargin, self.candleWidth, model.endPoint.y - model.startPoint.y);
    }
    
    else
    {
        rect = CGRectMake(model.startPoint.x,model.startPoint.y, self.candleWidth, model.endPoint.y - model.startPoint.y);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    CAShapeLayer *subLayer = [CAShapeLayer layer];
    subLayer.path = path.CGPath;
    
    if (macdModel.macd < 0)
    {
        subLayer.strokeColor = [UIColor colorWithRed:(31/255.0f) green:(185/255.0f) blue:(63.0f/255.0f) alpha:1.0].CGColor;
        
        subLayer.fillColor = [UIColor colorWithRed:(31/255.0f) green:(185/255.0f) blue:(63.0f/255.0f) alpha:1.0].CGColor;
    }
    else
    {
        subLayer.strokeColor = [UIColor colorWithRed:(232/255.0f) green:(50.0f/255.0f) blue:(52.0f/255.0f) alpha:1.0].CGColor;
        subLayer.fillColor = [UIColor colorWithRed:(232/255.0f) green:(50.0f/255.0f) blue:(52.0f/255.0f) alpha:1.0].CGColor;
    }
    return subLayer;
}

- (void)stockFillMacd
{
    [self drawLine];
}

- (void)drawLine{
    
    [self removeMcadLayerFromSubLayer];
    [self initLayer];
    [self initCurrentDisplayModels];
    [self initMacdMaxAndMinValue];
    [self initMaModelPosition];
    [self drawMacdKline];
}

#pragma mark lazyLoad

- (NSMutableArray*)macdArray
{
    if (!_macdArray)
    {
        _macdArray = [NSMutableArray array];
    }
    return _macdArray;
}

- (NSMutableArray*)deaArray
{
    if (!_deaArray)
    {
        _deaArray = [NSMutableArray array];
    }
    return _deaArray;
}

- (NSMutableArray*)diffArray
{
    if (!_diffArray)
    {
        _diffArray = [NSMutableArray array];
    }
    return _diffArray;
}

- (NSMutableArray*)displayArray
{
    if (!_displayArray)
    {
        _displayArray = [NSMutableArray array];
    }
    return _displayArray;
}

- (NSMutableArray *)currentDisplayArray
{
    if (!_currentDisplayArray) {
        _currentDisplayArray = [NSMutableArray array];
    }
    return _currentDisplayArray;
}


#pragma mark WR


#pragma mark KDJ

- (void)removeKdjLayerFromSubLayer
{
    for (NSInteger i = 0 ; i < self.kLineLayer.sublayers.count; i++)
    {
        CAShapeLayer *layer = (CAShapeLayer*)self.kLineLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
    
    for (NSInteger i = 0; i < self.dLineLayer.sublayers.count; i++) {
        CAShapeLayer * layer = (CAShapeLayer *)self.dLineLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
    for (NSInteger i = 0; i < self.jLineLayer.sublayers.count; i++) {
        CAShapeLayer * layer = (CAShapeLayer *)self.jLineLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
}

- (void)initKdjLayer
{
    if (self.kLineLayer)
    {
        [self.kLineLayer removeFromSuperlayer];
        self.kLineLayer = nil;
    }
    
    if (!self.kLineLayer)
    {
        self.kLineLayer = [CAShapeLayer layer];
        self.kLineLayer.contentsScale = [UIScreen mainScreen].scale;
        self.kLineLayer.strokeColor = [UIColor clearColor].CGColor;
        self.kLineLayer.fillColor = [UIColor redColor].CGColor;
    }
    [self.layer addSublayer:self.kLineLayer];
    
    if (self.dLineLayer)
    {
        [self.dLineLayer removeFromSuperlayer];
        self.dLineLayer = nil;
    }
    
    if (!self.dLineLayer)
    {
        self.dLineLayer = [CAShapeLayer layer];
        self.dLineLayer.contentsScale = [UIScreen mainScreen].scale;
        self.dLineLayer.strokeColor = [UIColor clearColor].CGColor;
        self.dLineLayer.fillColor = [UIColor redColor].CGColor;
    }
    [self.layer addSublayer:self.dLineLayer];
    
    if (self.jLineLayer)
    {
        [self.jLineLayer removeFromSuperlayer];
        self.jLineLayer = nil;
    }
    
    if (!self.jLineLayer)
    {
        self.jLineLayer = [CAShapeLayer layer];
        self.jLineLayer.contentsScale = [UIScreen mainScreen].scale;
        self.jLineLayer.strokeColor = [UIColor clearColor].CGColor;
        self.jLineLayer.fillColor = [UIColor redColor].CGColor;
    }
    [self.layer addSublayer:self.jLineLayer];
}

//- (void)initKdjCurrentDisPlayModels
//{
//    NSInteger needDrawKLineCount = self.displayCount;
//    NSInteger currentStartIndex = self.currentStartIndex;
//    NSInteger count = (currentStartIndex + needDrawKLineCount) >self.KDJDataArray.count ? self.KDJDataArray.count :currentStartIndex+needDrawKLineCount;
//    
//    [self.currentDisplayArray removeAllObjects];
//    
//    if (currentStartIndex < count)
//    {
//        for (NSInteger i = currentStartIndex; i <  count ; i++)
//        {
//            AbuKilneData *model = self.KDJDataArray[i];
//            
//            [self.currentDisplayArray addObject:model];
//        }
//    }
//    
//}

- (void)initKDJMaxAndMinValue
{
    
    self.maxY = CGFLOAT_MIN;
    self.minY  = CGFLOAT_MAX;
    
    for (AbuKilneData *lineData in self.KDJDataArray)
    {
        NSArray *array = [lineData.data subarrayWithRange:NSMakeRange(_startIndex,_displayCount)];
        for (NSInteger j = 0;j<array.count;j++)
        {
            AbuKlineUniti *until = array[j];
            self.minY = self.minY < until.value ? self.minY : until.value;
            self.maxY = self.maxY > until.value ? self.maxY : until.value;
        }
    }
    
    if (self.maxY - self.minY < 0.5)
    {
        self.maxY += 0.5;
        self.minY  += 0.5;
    }
    
    self.topMargin = 0;
    self.bottomMargin = 5;
    self.scaleY = (self.height - self.topMargin - self.bottomMargin)/(self.maxY-self.minY);
}

- (void)initKDJLinesModelPosition
{
    [self.kPostionArray removeAllObjects];
    [self.dPostionArray removeAllObjects];
    [self.jPostionArray removeAllObjects];
    
    for (AbuKilneData *lineData in self.KDJDataArray)
    {
        NSArray *array = [lineData.data subarrayWithRange:NSMakeRange(_startIndex,_displayCount)];
        
        for (NSInteger j = 0;j<array.count;j++)
        {
            AbuKlineUniti *until = array[j];
            CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * j) + self.candleWidth/2;
            CGFloat yPosition = ((self.maxY - until.value) *self.scaleY) + self.topMargin;
            AbuKlineModel *model = [AbuKlineModel  initxPositon:xPosition yPosition:yPosition color:lineData.color];
            if ([lineData.title isEqualToString:@"K"])
            {
                [self.kPostionArray addObject:model];
            }
            
            else if ([lineData.title isEqualToString:@"D"])
            {
                [self.dPostionArray addObject:model];
            }
            
            else if ([lineData.title isEqualToString:@"J"])
            {
                [self.jPostionArray addObject:model];
            }
        }
    }
}

- (void)drawKdjLineLayer
{
    [self layoutIfNeeded];
    AbuKilneData *kData = self.KDJDataArray[0];
    UIBezierPath *kPath = [UIBezierPath drawLine:self.kPostionArray];
    self.kLineLayer.path = kPath.CGPath;
    self.kLineLayer.strokeColor = kData.color.CGColor;
    self.kLineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.kLineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    AbuKilneData *dData = self.KDJDataArray[1];
    UIBezierPath *dPath = [UIBezierPath drawLine:self.dPostionArray];
    self.dLineLayer.path = dPath.CGPath;
    self.dLineLayer.strokeColor = dData.color.CGColor;
    self.dLineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.dLineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    AbuKilneData *jData = self.KDJDataArray[2];
    UIBezierPath *jPath = [UIBezierPath drawLine:self.jPostionArray];
    self.jLineLayer.path = jPath.CGPath;
    self.jLineLayer.strokeColor = jData.color.CGColor;
    self.jLineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.jLineLayer.contentsScale = [UIScreen mainScreen].scale;
}

- (void)drawKdjLine
{
    [self removeKdjLayerFromSubLayer];
    [self initKdjLayer];
//    [self initKdjCurrentDisPlayModels];
    [self initKDJMaxAndMinValue];
    [self initKDJLinesModelPosition];
    [self drawKdjLineLayer];
}

#pragma mark lazyMethod

- (NSMutableArray*)kPostionArray
{
    if (!_kPostionArray)
    {
        _kPostionArray = [NSMutableArray array];
    }
    return _kPostionArray;
}

- (NSMutableArray*)dPostionArray
{
    if (!_dPostionArray)
    {
        _dPostionArray = [NSMutableArray array];
    }
    return _dPostionArray;
}

- (NSMutableArray*)jPostionArray
{
    if (!_jPostionArray)
    {
        _jPostionArray = [NSMutableArray array];
    }
    return _jPostionArray;
}


- (void)stockFill
{
    [self drawKdjLine];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x<0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(displayMoreData)])
        {
            //记录上一次的偏移量
            self.previousOffsetX = _scrollView.contentSize.width  -_scrollView.contentOffset.x;
            [_delegate displayMoreData];
        }
    }
}

@end
