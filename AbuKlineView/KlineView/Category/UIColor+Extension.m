//
//  UIColor+Extension.m
//  AbuKlineView
//
//  Created by 阿布 on 17/9/6.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+(UIColor *)colorWithHexString:(NSString *)color
{
    NSString *str1 = [NSString stringWithFormat:@"0x%@",[color substringWithRange:NSMakeRange(1, 2)]];
    NSString *str2 = [NSString stringWithFormat:@"0x%@",[color substringWithRange:NSMakeRange(3, 2)]];
    NSString *str3 = [NSString stringWithFormat:@"0x%@",[color substringWithRange:NSMakeRange(5, 2)]];
    
    unsigned long f1 = strtoul([str1 UTF8String],0,16);
    unsigned long f2 = strtoul([str2 UTF8String],0,16);
    unsigned long f3 = strtoul([str3 UTF8String],0,16);
    
    return [UIColor colorWithRed:f1/255.0 green:f2/255.0 blue:f3/255.0 alpha:1.0];
}

@end
