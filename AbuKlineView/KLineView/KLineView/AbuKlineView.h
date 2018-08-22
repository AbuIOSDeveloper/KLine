//
//  AbuKlineView.h
//  AbuKlineView
//
//  Created by Jefferson.zhang on 2017/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AbuKlineView : UIView


@property (nonatomic,strong) NSMutableArray<__kindof KLineModel*> *dataArray;

@property (nonatomic,assign) NSInteger displayCount;

@property (nonatomic,assign) BOOL isShowIndictorView;

- (void)refreshFSKlineView:(KLineModel *)model;

- (void)isShowOrHiddenIditionChart:(BOOL)isShow;
@end
