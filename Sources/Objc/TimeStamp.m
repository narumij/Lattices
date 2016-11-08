//
//  TimeStamp.m
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/01.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

#import "TimeStamp.h"

NSString *CompileTimeStamp()
{
    NSString *str = [NSString stringWithUTF8String:__DATE__ "_" __TIME__];
    str = [str stringByReplacingOccurrencesOfString:@"[ ]+" withString:@"_" options:NSRegularExpressionSearch range:NSMakeRange(0, str.length)];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    str = [@"CompileTimeStamp_" stringByAppendingString:str];
    return str;
}
