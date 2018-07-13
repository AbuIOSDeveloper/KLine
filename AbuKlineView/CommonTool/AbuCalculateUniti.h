//
//  AbuCalculateUniti.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MACDParameter) {
    MACDParameterDIFF,
    MACDParameterMACD,
    MACDParameterDEA,
};

void NSArrayToCArray(NSArray *array, double outCArray[]);

NSArray *CArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement);

NSArray *CArrayToNSArrayWithParameter(const double inCArray[], int length, int outBegIdx, int outNBElement, double parmeter);

//  KDJ
NSArray *KDJCArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement);

//  MACD类型
NSArray *MACDCArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement, NSArray *items, MACDParameter parameter);

NSArray *MDCArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement, NSArray *items);

void freeAndSetNULL(void *ptr);

CGFloat customComputeMA(NSArray *items, NSInteger days);

