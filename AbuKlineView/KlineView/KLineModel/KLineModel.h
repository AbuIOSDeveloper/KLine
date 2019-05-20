//
//  KLineModel.h
//  ABuKLineChartView
//
//  Created by jefferson on 2018/7/19.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLineModel : NSObject

/** 最高价 */
@property (assign, nonatomic) CGFloat    highPrice;
/** 最低价 */
@property (assign, nonatomic) CGFloat    lowPrice;
/** 开盘价 */
@property (assign, nonatomic) CGFloat    openPrice;
/** 收盘价 */
@property (assign, nonatomic) CGFloat    closePrice;
/** 日期 */
@property (copy,   nonatomic) NSString * date;
/** 成交量 */
@property (copy,   nonatomic) NSString * volumn;
/** 是否需要绘制日期 */
@property (assign, nonatomic) BOOL       isDrawDate;

@property (nonatomic,assign) double currentPrice;
@property (nonatomic,assign) NSInteger timestamp;


@property (nonatomic,assign) BOOL isNew;


//model中应该最后处理成坐标数据
@property (nonatomic,copy)   NSString *timeStr;

@property (nonatomic,assign) NSUInteger xPoint;
/**
 *蜡烛矩形起点
 */
@property (nonatomic,assign) CGFloat y;
/**
 *蜡烛矩形高度
 */
@property (nonatomic,assign) CGFloat h;
/**
 *蜡烛开盘点
 */
@property (nonatomic,assign) CGPoint opensPoint;
/**
 *蜡烛收盘点
 */
@property (nonatomic,assign) CGPoint closesPoint;
/**
 *蜡烛最高点
 */
@property (nonatomic,assign) CGPoint highestPoint;
/**
 *蜡烛最低点
 */
@property (nonatomic,assign) CGPoint lowestPoint;
/**
 *填充颜色
 */
@property (nonatomic,strong) UIColor *fillColor;
/**
 *边线绘制颜色
 */
@property (nonatomic,strong) UIColor *strokeColor;
/**
 *判断是否是NSTimer推送的数据
 */
@property (nonatomic,assign) BOOL isFakeData;
/**
 *当数据不足以显示一屏的时候的判断处理
 */
@property (nonatomic,assign) BOOL isPlaceHolder;




//MACD
//这里由于是使用懒加载的，所以必须声明为对象类型才能保存在模型中
//previousKlineModel
@property (nonatomic,strong) KLineModel *previousKlineModel;
@property (nonatomic,strong) NSNumber *EMA12;
@property (nonatomic,strong) NSNumber *EMA26;
@property (nonatomic,strong) NSNumber *DIF;
@property (nonatomic,strong) NSNumber *DEA;
@property (nonatomic,strong) NSNumber *MACD;
- (void)reInitData;




//KDJ
//KDJ(9,3.3),下面以该参数为例说明计算方法。
//9，3，3代表指标分析周期为9天，K值D值为3天
//RSV(9)=（今日收盘价－9日内最低价）÷（9日内最高价－9日内最低价）×100
//K(3日)=（当日RSV值+2*前一日K值）÷3
//D(3日)=（当日K值+2*前一日D值）÷3
//J=3K－2D
@property (nonatomic,strong) NSNumber *HNinePrice;
@property (nonatomic,strong) NSNumber *LNinePrice;
@property (nonatomic, copy) NSNumber *RSV_9;
@property (nonatomic, copy) NSNumber *KDJ_K;
@property (nonatomic, copy) NSNumber *KDJ_D;
@property (nonatomic, copy) NSNumber *KDJ_J;
- (void)reInitKDJData;


//BOLL
/*
 20日BOLL指标的计算过程
 　　（1）计算MA
 　　MA=N日内的收盘价之和÷N
 　　（2）计算标准差MD
 　　MD=平方根(N日的（C－MA）的两次方之和除以N)
 　　（3）计算MB、UP、DN线
 　　MB=（N－1）日的MA
 　　UP=MB＋2×MD
 　　DN=MB－2×MD
 　　在股市分析软件中，BOLL指标一共由四条线组成，即上轨线UP 、中轨线MB、下轨线DN和价格线。其中上轨线UP是UP数值的连线，用黄色线表示；中轨线MB是MB数值的连线，用白色线表示；下轨线DN是DN数值的连线，用紫色线表示；价格线是以美国线表示，颜色为浅蓝色。和其他技术指标一样，在实战中，投资者不需要进行BOLL指标的计算，主要是了解BOLL的计算方法和过程，以便更加深入地掌握BOLL指标的实质，为运用指标打下基础。
 
 */
@property (nonatomic, copy) NSNumber *BOLL_MA;
@property (nonatomic, copy) NSNumber *BOLL_MD;
@property (nonatomic, copy) NSNumber *BOLL_MB;
@property (nonatomic, copy) NSNumber *BOLL_UP;
@property (nonatomic, copy) NSNumber *BOLL_DN;

- (void)reInitBOLLData;




//RSI
/*
 RSI的计算公式
 RSI=100×RS/(1+RS) 或者，RSI=100－100÷（1+RS）
 其中 RS=14天内收市价上涨数之和的平均值/14天内收市价下跌数之和的平均值
 举例说明：
 如果最近14天涨跌情形是:第一天升2元，第二天跌2元，第三至第五天各升3元；第六天跌4元 第七天升2元，第八天跌5元；第九天跌6元，第十至十二天各升1元；第十三至十四天各跌3元。
 那么，计算RSI的步骤如下：
 (一)将14天上升的数目相加，除以14，上例中总共上升16元除以14得1.143(精确到小数点后三位)；
 (二)将14天下跌的数目相加，除以14，上例中总共下跌23元除以14得1.643(精确到小数点后三位)；
 (三)求出相对强度RS，即RS=1.143/1.643=0.696(精确到小数点后三位)；
 (四)1+RS=1+0.696=1.696；
 (五)以100除以1+RS，即100/1.696=58.962；
 (六)100-58.962=41.038。    结果14天的强弱指标RS1为41.038。    不同日期的14天RSI值当然是不同的，连接不同的点，即成RSI的轨迹。
 
 */

@property (nonatomic, copy) NSNumber *RSI_6;
@property (nonatomic, copy) NSNumber *RSI_12;
@property (nonatomic, copy) NSNumber *RSI_14;
@property (nonatomic, copy) NSNumber *RSI_21;
@property (nonatomic, copy) NSNumber *RSI_24;
@property (nonatomic, assign)double  SMAMAX;
@property (nonatomic, assign)double  SMAABS;
- (void)judgeRSIIsNan;

//CGFloat UPDM = 0;
//CGFloat DNDM = 0;
//CGFloat TR = 0;
//CGFloat SUNMDX = 0;
//CGFloat ADMUP = 0;
//CGFloat ADMDN = 0;
//CGFloat ATR = 0;
//CGFloat DIUP = 0;
//CGFloat DIDN = 0;
//CGFloat DX = 0;
@property (nonatomic, assign)double  UPDM;
@property (nonatomic, assign)double  DNDM;
@property (nonatomic, assign)double  ADXTR;
@property (nonatomic, assign)double  ADMUP;
@property (nonatomic, assign)double  ADMDN;
@property (nonatomic, assign)double  ADXATR;
@property (nonatomic, assign)double  DIUP;
@property (nonatomic, assign)double  DIDN;
@property (nonatomic, assign)double  DX;
@property (nonatomic, assign)double  ADX;

//VOL
@property (nonatomic, copy) NSNumber *volumn_MA5;
@property (nonatomic, copy) NSNumber *volumn_MA10;
@property (nonatomic, copy) NSNumber *volumn_MA20;



//MA
@property (nonatomic, copy) NSNumber *MA5;
@property (nonatomic, copy) NSNumber *MA10;
@property (nonatomic, copy) NSNumber *MA14;
@property (nonatomic, copy) NSNumber *MA20;

//ARBP
@property (nonatomic, assign) NSInteger N;
@property (nonatomic, copy) NSNumber * AR;
@property (nonatomic, copy) NSNumber * BR;
- (void)reInitARBPData;

//ATR
@property (nonatomic, assign) double TR;
@property (nonatomic, assign) double ATR;

//BIAS
@property (nonatomic, assign) double BIAS1;
@property (nonatomic, assign) double BIAS2;
@property (nonatomic, assign) double BIAS3;
- (void)reInitBIASData;

//CCI
@property (nonatomic, assign) double TP;
@property (nonatomic, assign) double CCI;

//DKBY
@property (nonatomic, assign) double SMA;

@property (nonatomic, assign) double SELL;
@property (nonatomic, assign) double BUY;
@property (nonatomic, assign) double ENE1;
@property (nonatomic, assign) double ENE2;

//KD
@property (nonatomic, assign) double RSV;
@property (nonatomic, assign) double K;
@property (nonatomic, assign) double D;


//LWR
@property (nonatomic, assign) double LWR1;
@property (nonatomic, assign) double LWR2;

//WR
@property (nonatomic, assign) double WR;

//QHLSR
@property (nonatomic, assign) double DD;
@property (nonatomic, assign) double GG;

@property (nonatomic, assign) double EMA1;
@property (nonatomic, assign) double EMA2;
@property (nonatomic, assign) double EMA3;
@property (nonatomic, assign) double EMA4;
@property (nonatomic, assign) double EMA5;
@property (nonatomic, assign) double EMA6;

@property (nonatomic, assign) double PBX1;
@property (nonatomic, assign) double PBX2;
@property (nonatomic, assign) double PBX3;
@property (nonatomic, assign) double PBX4;
@property (nonatomic, assign) double PBX5;
@property (nonatomic, assign) double PBX6;

@end
