//
//  PrefixHeader.pch
//  ABuKLineChartView
//
//  Created by jefferson on 2018/7/18.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

#ifdef __OBJC__

#import "KlineTitleView.h"
#import "AbuCharViewProtocol.h"
#import "AbuKlineView.h"

/** ********************数据模型******************** */
#import "KLineModel.h"



/** ********************单例******************** */
#import "WebSocket.h"
#import "KLineCalculate.h"
#import "KLineSubCalculate.h"
#import "KLineSocketDataRefersh.h"

/** ********************扩展类******************** */




/** ********************宏定义******************** */

#define ContentOffSet @"contentOffset"

#define ContentOffSetMacd @"contentOffsetMacd"

#define IsDictionaryNull(dict) (nil == dict || ![dict isKindOfClass:[NSDictionary class]]\
|| [dict isKindOfClass:[NSNull class]] || [dict allKeys].count <= 0)
#define IsArrayNull(array) ((nil == array || ![array isKindOfClass:[NSArray class]]\
|| [array isKindOfClass:[NSNull class]] || array.count <= 0))
#define IsStringNull(string) (nil == string || [string isKindOfClass:[NSNull class]] \
|| string.length <= 0)
#define IsObjectNull(object) (nil == object || [object isKindOfClass:[NSNull class]])

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define widthradio  SCREENWIDTH/375
#define heightradio SCREENHEIGHT/667

#define midDistance 40
#define topDistance 10
#define leftDistance 10
#define rightDistance 10
#define bottomDistance 10

#define timeheight 15

#define MinCount 10
#define MaxCount 30

#define KlineCount 88

#define maxCandelWith 20

#define minCandelWith 4

#define ChartViewHigh 400

#define LandscapeChartViewHigh 300

#define orignScale 1.0
#define orignChartScale 3.0f/2.0f
#define orignIndicatorScale  1.0f / 3.0f
#define orignIndicatorOrignY 2.0f * orignIndicatorScale

#define priceWidth 60

#define RISECOLOR [UIColor colorWithHexString:@"#fb463e"]
#define DROPCOLOR [UIColor colorWithHexString:@"#30b840"]
#define Orientation [[UIApplication sharedApplication] statusBarOrientation]
#define Portrait (Orientation==UIDeviceOrientationPortrait||Orientation==UIDeviceOrientationPortraitUpsideDown)
#define LandscapeLeft (Orientation == UIDeviceOrientationLandscapeLeft)
#define TotalWidth      (Portrait ? (PortraitTotalWidth) : (LanscapeTotalWidth))

#define PortraitTotalWidth    KSCREEN_WIDTH
#define LanscapeTotalWidth    KSCREEN_HEIGHT
#define KSCREEN_WIDTH    MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)
#define KSCREEN_HEIGHT   MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)

typedef enum
{
    MACD = 1,
    KDJ,
    WR
}DataLineType;

typedef NS_ENUM(NSUInteger, ColumnWidthType) {
    ColumnWidthTypeEqualCandle = 0,
    ColumnWidthTypeEqualLine,
};

typedef NS_ENUM(NSUInteger, KlineWireSubOrMain) {
    Main = 0,
    Sub,
};

typedef NS_ENUM(NSUInteger, WIRETYPE) {
    MA5TYPE = 0,
    MA10TYPE,
    MA20TYPE,
    MACDDIFF,
    MACDDEA,
    KDJ_K,
    KDJ_D,
    KDJ_J,
    KLINE_WR,
};

typedef NS_ENUM(NSInteger, KlineSubKPIType) {
    KlineSubKPITypeATR = 0,
    KlineSubKPITypeBIAS = 1,
    KlineSubKPITypeCCI = 2,
    KlineSubKPITypeKD = 3,
    KlineSubKPITypeMACD = 4,
    KlineSubKPITypeRSI = 5,
    KlineSubKPITypeW_R = 6,
    KlineSubKPITypeARBR = 7,
    KlineSubKPITypeDKBY = 8,
    KlineSubKPITypeKDJ = 9,
    KlineSubKPITypeLW_R = 10, ///< _ -> &
    KlineSubKPITypeQHLSR = 11,
    KlineSubKPITypeKD5 = 12,
    KlineSubKPITypeMACD24 = 13,
};

#endif

#endif /* PrefixHeader_h */
