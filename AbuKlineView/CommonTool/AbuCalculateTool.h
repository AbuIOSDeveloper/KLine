//
//  AbuCalculateTool.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/7.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <Foundation/Foundation.h>


AbuKilneData * computeMAData(NSArray *items,int period);
NSMutableArray* computeMACDData(NSArray *items);
NSMutableArray *computeKDJData(NSArray *items);
NSMutableArray *computeWRData(NSArray *items,int period);
