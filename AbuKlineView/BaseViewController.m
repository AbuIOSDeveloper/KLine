//
//  BaseViewController.m
//  AbuKline
//
//  Created by jefferson on 2018/8/27.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self supportRotion:UIInterfaceOrientationPortrait];
}
- (void)supportRotion:(int)rotion
{
    NSNumber *value = [NSNumber numberWithInt:rotion];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation = NO;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}



- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
