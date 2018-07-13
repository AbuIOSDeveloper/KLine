//
//  FHHFPSIndicator.m
//  FHHFPSIndicator
//
//  Created by 002 on 16/6/27.
//  Copyright © 2016年 002. All rights reserved.
//

#import "FHHFPSIndicator.h"

#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define SIZE_fpsLabel CGSizeMake(44, 15)
#define FONT_SIZE_fpsLabel (12)
#define TAG_fpsLabel (110213)
#define TEXTCOLOR_fpsLabel ([UIColor colorWithRed:85 / 255.0 green:214 / 255.0 blue:110 / 255.0 alpha:1.00])
#define PADDING_TOP_fpsLabel (15)

#if TARGET_IPHONE_SIMULATOR // SIMULATOR
#define PADDING_LEFT_fpsLabel (47)
#define PADDING_RIGHT_fpsLabel (9)
#define PADDING_CENTER_fpsLabel (1)
#elif TARGET_OS_IPHONE  // iPhone
#define PADDING_LEFT_fpsLabel (36)
#define PADDING_RIGHT_fpsLabel (-3)
#define PADDING_CENTER_fpsLabel (3)
#endif

@interface FHHFPSIndicator ()

{
    CADisplayLink *_displayLink;
    NSTimeInterval _lastTime;
    NSUInteger _count;
}

@property (nonatomic,strong)UILabel *fpsLabel;

@end

@implementation FHHFPSIndicator

+ (FHHFPSIndicator *)sharedFPSIndicator {
    static dispatch_once_t onceToken;
    static FHHFPSIndicator *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[FHHFPSIndicator alloc] init];
    });
    return _instance;
}

- (id)init {
    if (self = [super init]) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
        [_displayLink setPaused:YES];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        // create fpsLabel
        _fpsLabel = [[UILabel alloc] init];
        self.fpsLabelPosition = FPSIndicatorPositionBottomCenter;
        _fpsLabel.tag = TAG_fpsLabel;
        
        // set style for fpsLabel
        [self configFPSLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationDidBecomeActiveNotification)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationWillResignActiveNotification)
                                                     name: UIApplicationWillResignActiveNotification
                                                   object: nil];
        
        
    }
    return self;
}

/**
 you can change the fpsLabel style for your app in this function
 */
- (void)configFPSLabel {
    _fpsLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_fpsLabel];
    _fpsLabel.backgroundColor = [UIColor clearColor];
    _fpsLabel.textColor = TEXTCOLOR_fpsLabel;
    _fpsLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)displayLinkTick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) {
        return;
    }
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    NSString *text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    [_fpsLabel setText: text];
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *label in keyWindow.subviews) {
        if ([label isKindOfClass:[UILabel class]]&& label.tag == TAG_fpsLabel) {
            return;
        }
    }
    [_displayLink setPaused:NO];
    [keyWindow addSubview:_fpsLabel];
}

- (void)hide {
    [_displayLink setPaused:YES];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *label in keyWindow.subviews) {
        if ([label isKindOfClass:[UILabel class]]&& label.tag == TAG_fpsLabel) {
            [label removeFromSuperview];
            return;
        }
    }
}

#pragma mark - notification
- (void)applicationDidBecomeActiveNotification {
    [_displayLink setPaused:NO];
}

- (void)applicationWillResignActiveNotification {
    [_displayLink setPaused:YES];
}

#pragma mark - setter
- (void)setFpsLabelPosition:(FPSIndicatorPosition)fpsLabelPosition {
    _fpsLabelPosition = fpsLabelPosition;
    switch (_fpsLabelPosition) {
        case FPSIndicatorPositionTopLeft:
            _fpsLabel.frame = CGRectMake((kScreenWidth - SIZE_fpsLabel.width) / 2 - PADDING_LEFT_fpsLabel - 1, 2.5, SIZE_fpsLabel.width, SIZE_fpsLabel.height);
            break;
        case FPSIndicatorPositionTopRight:
            _fpsLabel.frame = CGRectMake((kScreenWidth + SIZE_fpsLabel.width) / 2 + (PADDING_RIGHT_fpsLabel) , 2.5, SIZE_fpsLabel.width, SIZE_fpsLabel.height);
            break;
        case FPSIndicatorPositionBottomCenter:
            _fpsLabel.frame = CGRectMake((kScreenWidth - SIZE_fpsLabel.width) / 2 + PADDING_CENTER_fpsLabel, PADDING_TOP_fpsLabel, SIZE_fpsLabel.width, SIZE_fpsLabel.height);
            break;
        default:
            break;
    }
}

- (void)fpsLabelColor:(UIColor *)color {
    if (color == nil) {
        _fpsLabel.textColor = TEXTCOLOR_fpsLabel;
    } else {
        _fpsLabel.textColor = color;
    }    
}

@end
