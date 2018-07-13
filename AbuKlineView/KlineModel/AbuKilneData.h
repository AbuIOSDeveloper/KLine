//
//  AbuKilneData.h
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AbuKilneData : NSObject

@property (nonatomic,copy) NSArray *data;
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,strong) UIColor *color;

- (id)initWithData:(NSMutableArray *)data color:(UIColor *)color title:(NSString *)title;

@end
