//
//  FHHFPSIndicator.h
//  FHHFPSIndicator:https://github.com/jvjishou/FHHFPSIndicator
//
//  Created by 002 on 16/6/27.
//  Copyright © 2016年 002. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIWindow+FHH.h"


// FpsLabel's position. Default is FPSIndicatorPositionBottomCenter
// If your device is iPhone4's or iPhone5's series,use FPSIndicatorPositionBottomCenter to make the fpsLabel show completed.
typedef enum {
    FPSIndicatorPositionTopLeft,        ///<left-center on statusBar
    FPSIndicatorPositionTopRight,       ///<right-center on statusBar
    FPSIndicatorPositionBottomCenter    ///<under the statusBar
} FPSIndicatorPosition;


@interface FHHFPSIndicator : NSObject

#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================
@property(nonatomic,assign) FPSIndicatorPosition fpsLabelPosition;


#pragma mark - Initializer
///=============================================================================
/// @name Initializer
///=============================================================================
/**
 Returns global shared FHHFPSIndicator instance.
 @return  The singleton FHHFPSIndicator instance.
 */
+ (FHHFPSIndicator *)sharedFPSIndicator;


#pragma mark - Access Methods
///=============================================================================
/// @name Access Methods
///=============================================================================

/**
 Set fpsLabel.textColor
 
 @param color The color to be setted for fpsLabel.textColor. If nil,the default Color will be setted.
 */
- (void)fpsLabelColor:(UIColor *)color;

/**
 Show fpsLabel at the top of keyWindow
 Note:If you change the keyWindow,you shoud call this function again after the new keyWindw becomes keyAndVisible.
 */
- (void)show;

/**
 Hide fpsLabel
 Note:If you call this function in the code,the fpsLabel will always be hided in the keyWindow until you call 'show' function again.
 */
- (void)hide;

@end
