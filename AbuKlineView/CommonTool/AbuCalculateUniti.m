//
//  AbuCalculateUniti.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuCalculateUniti.h"

void NSArrayToCArray(NSArray *array, double outCArray[])
{
    if (NULL == outCArray)
    {
        return;
    }
    
    NSInteger index = 0;
    for (NSString *str in array)
    {
        outCArray[index] = [str doubleValue];
        index++;
    }
}

NSArray *CArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement)
{
    if (NULL == inCArray)
    {
        return nil;
    }
    
    NSMutableArray *outNSArray = [[NSMutableArray alloc] initWithCapacity:length];
    
    for (NSInteger index = 0; index < length; index++)
    {
        if (index >= outBegIdx && index < outBegIdx + outNBElement)
        {
            [outNSArray addObject:[NSString stringWithFormat:@"%f", inCArray[index - outBegIdx]]];
        } else{
            
            [outNSArray addObject:[NSString stringWithFormat:@"%f", 0.0f]];
        }
    }
    return outNSArray;
}

//  KDJ
NSArray *KDJCArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement) {
    if (NULL == inCArray) {
        return nil;
    }
    
    NSMutableArray *outNSArray = [[NSMutableArray alloc] initWithCapacity:length];
    for (NSInteger index = 0; index < length; index++) {
        if (index >= outBegIdx && index < outBegIdx + outNBElement) {
            [outNSArray addObject:[NSString stringWithFormat:@"%f", inCArray[index - outBegIdx]]];
        } else {
            
            [outNSArray addObject:[NSString stringWithFormat:@"%f", 0.1f]];
        }
    }
    return outNSArray;
}

//  MACD
NSArray *MACDCArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement, NSArray *items, MACDParameter parameter){
    if (NULL == inCArray) {
        return nil;
    }
    
    NSMutableArray *outNSArray = [[NSMutableArray alloc] initWithCapacity:length];
    //  EMA
    CGFloat EMA12Value = 0.0f;
    CGFloat EMA26Value = 0.0f;
    //  DIFF
    CGFloat DIFFValue = 0.0f;
    //  DEA
    CGFloat DEAValue = 0.0f;
    //  MACD
    CGFloat MACDValue = 0.0f;
    
    for (NSInteger index = 0; index < length; index++) {
        if (index >= outBegIdx && index < outBegIdx + outNBElement) {
            [outNSArray addObject:[NSString stringWithFormat:@"%f", inCArray[index - outBegIdx]]];
            if (parameter == MACDParameterMACD) {
            }
            
        } else {
            //  当前天数
            NSUInteger nowIndex = length - index - 1;
            //  当前蜡烛图数据
            AbuChartCandleModel *item = items[nowIndex];
            //  前一日数据
            AbuChartCandleModel *lastItem = items[nowIndex - 1];
            //  第一天
            if (index == 0) {
                [outNSArray addObject:[NSString stringWithFormat:@"%.2f", 0.0f]];
                continue;
            }
            
            //  第二天
            else if (index == 1) {
                [outNSArray addObject:[NSString stringWithFormat:@"%.2f", 0.0f]];
                
                EMA12Value = lastItem.close + (item.close  - lastItem.close ) * 2.0 / 13;
                EMA26Value = lastItem.close  + (item.close  - lastItem.close ) * 2.0 / 27;
                DIFFValue = EMA12Value - EMA26Value;
                DEAValue = DEAValue * 8.0 / 10 + DIFFValue * 2.0 / 10;
                MACDValue = (DIFFValue - DEAValue);
                continue;
            }
            
            else{
                EMA12Value = (EMA12Value * 11.0 / 13 + item.close  * 2.0 / 13);
                EMA26Value = (EMA26Value * 25.0 / 27 + item.close  * 2.0 / 27);
                DIFFValue = EMA12Value - EMA26Value;
                DEAValue = DEAValue * 8.0 / 10 + DIFFValue * 2.0 / 10;
                MACDValue = (DIFFValue - DEAValue);
            }
            
            switch (parameter) {
                case MACDParameterMACD:
                    [outNSArray addObject:[NSString stringWithFormat:@"%.2f",MACDValue]];
                    break;
                case MACDParameterDIFF:
                    [outNSArray addObject:[NSString stringWithFormat:@"%.2f",DIFFValue]];
                    break;
                case MACDParameterDEA:
                    [outNSArray addObject:[NSString stringWithFormat:@"%.2f",DEAValue]];
                    break;
                default:
                    [outNSArray addObject:[NSString stringWithFormat:@"%f", 0.0f]];
                    break;
            }
        }
    }
    return outNSArray;
}

//  MD5,10,20计算
NSArray *MDCArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement, NSArray *items){
    if (NULL == inCArray) {
        return nil;
    }
    NSMutableArray *outNSArray = [[NSMutableArray alloc] initWithCapacity:length];
    for (NSInteger index = 0; index < length; index++) {
        if (index >= outBegIdx && index < outBegIdx + outNBElement) {
            [outNSArray addObject:[NSString stringWithFormat:@"%f", inCArray[index - outBegIdx]]];
        } else {
            //  当前天数
            NSUInteger nowIndex = length - index - 1;
            //  当前蜡烛图数据
            AbuChartCandleModel *item = items[nowIndex];
            //  添加5,10,20均线下md5数据
            if (index == 0) {
                [outNSArray addObject:[NSString stringWithFormat:@"%.6f",item.close ]];
            }
            else{
                [outNSArray addObject:[NSString stringWithFormat:@"%.2f",customComputeMA(items, index + 1)]];
            }
        }
    }
    return outNSArray;
}

CGFloat customComputeMA(NSArray *items, NSInteger days)
{
    CGFloat totalPrice = 0.0;
    for (int i = 0; i < days; i ++ ) {
        AbuChartCandleModel *item = items[items.count - i - 1];
        totalPrice = totalPrice + item.close;
    }
    return totalPrice/days;
}

NSArray *CArrayToNSArrayWithParameter(const double inCArray[], int length, int outBegIdx, int outNBElement, double parmeter) {
    if (NULL == inCArray) {
        return nil;
    }
    
    NSMutableArray *outNSArray = [[NSMutableArray alloc] initWithCapacity:length];
    
    for (NSInteger index = 0; index < length; index++) {
        if (index >= outBegIdx && index < outBegIdx + outNBElement) {
            [outNSArray addObject:[NSString stringWithFormat:@"%f", inCArray[index - outBegIdx]]];
        } else {
            [outNSArray addObject:[NSString stringWithFormat:@"%f", 0.1]];
        }
    }
    return outNSArray;
}

void freeAndSetNULL(void *ptr) {
    free(ptr);
    ptr = NULL;
}

