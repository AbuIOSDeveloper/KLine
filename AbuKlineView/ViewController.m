//
//  ViewController.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) AbuKlineView        * kLineView;

@property (nonatomic,strong)  AbuChartCandleModel * model; //K线模型

@property (nonatomic,strong)  NSMutableArray      * dataSource;

@property (nonatomic, strong) NSTimer             * time;

/**
 *横竖屏方向
 */
@property (nonatomic,assign) UIInterfaceOrientation orientation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton * btn = [[UIButton alloc]init];
//    btn.frame = CGRectMake(10, 30, 200, 30);
//    btn.backgroundColor = [UIColor redColor];
//    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setTitle:@"隐藏幅图按钮，暂时还不是很完善" forState:UIControlStateNormal];//这个功能没有全部完善
//    [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:btn];
    [self.view addSubview:self.kLineView];
    
    [self addSubView];
    [self loadStockData];
//    [self startRefresh];//开启刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
}

#pragma mark - 旋转事件
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    self.orientation = [[UIApplication sharedApplication] statusBarOrientation];
    WS(weakSelf);
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        [self.kLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(70);
            make.height.mas_offset(ChartViewHigh);
        }];
        
    }
    if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        [self.kLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(70);
            make.height.mas_offset(LandscapeChartViewHigh);
        }];
    }
}

- (void)addSubView
{
    WS(weakSelf);
    self.orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        [self.kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(100);
            make.right.equalTo(weakSelf.view.mas_right);
            make.left.equalTo(weakSelf.view.mas_left);
            make.height.mas_offset(ChartViewHigh);
        }];
    }
    if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        [self.kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(70);
            make.right.equalTo(weakSelf.view.mas_right);
            make.left.equalTo(weakSelf.view.mas_left);
            make.height.mas_offset(LandscapeChartViewHigh);
        }];
    }
}

- (void)btnClick:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        [self.kLineView isShowOrHiddenIditionChart:YES];
   
    }else{
        [self.kLineView isShowOrHiddenIditionChart:NO];
    }
}

- (void)loadStockData
{
    // 获取文件路径
    NSString *Path = [[NSBundle mainBundle] pathForResource:@"stock" ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:Path];
    
    NSDictionary * stockDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSArray * stockData = stockDict[@"d"][@"p"];
    for (int i = 0; i < stockData.count; i++)
    {
        NSDictionary * dic = stockData[i];
        AbuChartCandleModel * model = [[AbuChartCandleModel alloc]init];
        model.close = [dic[@"c"] floatValue];
        model.open = [dic[@"o"] floatValue];
        model.high = [dic[@"h"] floatValue];
        model.low = [dic[@"l"] floatValue];
        model.date = [self changeDtaForMatMmDd:dic[@"t"] range:NSMakeRange(14, 2)];
        model.volumn = dic[@"v"];
        if (i % 16 == 0)
        {
            model.isDrawDate = YES;
        }
        [self.dataSource addObject:model];
    }
    self.dataSource = [[[AbuSubCalculate sharedInstance] initializeQuotaDataWithArray:self.dataSource KPIType:4] mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.kLineView.dataArray = self.dataSource;
    });
}
#pragma mark 模拟刷新
- (void)startRefresh

{
    self.time =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
}

- (void)function:(NSTimer *)Time
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    float close  = 1241 +  (arc4random() % 5);
    dict[@"close"] = [NSString stringWithFormat:@"%.2f",close];
    float max  = 1241  +  (arc4random() % 5);
    dict[@"max"] = [NSString stringWithFormat:@"%.2f",max];
    float min  = 1241  +  (arc4random() % 5);
    dict[@"min"] = [NSString stringWithFormat:@"%.2f",min];
    float open  = 1241  +  (arc4random() % 5);
    dict[@"open"] = [NSString stringWithFormat:@"%.2f",open];
    if ((close < 1242) || (open < 1242) || (max < 1242) || (min < 1242)) {
        return;
    }
    /**
     *  改变日期  可以刷新一个日期  否则指刷新当日报价
     */
    int time  = 20170809 + (arc4random() % 10);
    dict[@"time"] = [NSString stringWithFormat:@"%d",time];
    int volumn  = 460  +  (arc4random() % 10);
    dict[@"volumn"] = [NSString stringWithFormat:@"%d",volumn];
    AbuChartCandleModel * model = [[AbuChartCandleModel alloc] init];
    model.close = close;
    model.open = open;
    model.high = max;
    model.low = min;
    model.volumn = [NSString stringWithFormat:@"%d",volumn];
    model.date = [NSString stringWithFormat:@"%d",time];
    [self.kLineView refreshFSKlineView:model];
}

- (NSString *)changeDtaForMatMmDd:(NSString *)data range:(NSRange)range
{
    NSArray * timeArray = [data componentsSeparatedByString:@"T"];
    NSString * time = [timeArray.firstObject stringByAppendingString:[NSString stringWithFormat:@" %@",timeArray.lastObject]];
    return time;
}

- (long)changeTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *lastDate = [formatter dateFromString:time];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
    long firstStamp = [lastDate timeIntervalSince1970];
    return firstStamp;
}

//-(NSString*)updateTime:(NSString*)time{
//
//    NSString *format = nil;
//    //日周
//    if ([self.currentRequestType containsString:@"D"]||[self.currentRequestType containsString:@"W"]||[self.currentRequestType isEqualToString:@"MN"]) {
//
//        format = @"MM-dd";
//        //分钟
//    }else if ([self.currentRequestType containsString:@"M"]||[self.currentRequestType containsString:@"H"])
//    {
//        format = @"MM-dd HH:mm";
//    }
//    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:format];
//    int timeval = [time intValue];
//    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeval];
//    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//    return confromTimespStr;
//}

- (UIInterfaceOrientation)orientation
{
 return [[UIApplication sharedApplication] statusBarOrientation];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (AbuKlineView *)kLineView
{
    if (!_kLineView) {
        _kLineView = [[AbuKlineView alloc]init];
        _kLineView.isShowIndictorView = YES;
        _kLineView.displayCount = 50;
//        _kLineView.backgroundColor = [UIColor redColor];
    }
    return _kLineView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
