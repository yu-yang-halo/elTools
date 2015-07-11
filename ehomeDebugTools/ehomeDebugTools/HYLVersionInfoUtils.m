//
//  HYLVersionInfoUtils.m
//  ehomeDebugTools
//
//  Created by admin on 15/7/10.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLVersionInfoUtils.h"

@implementation HYLVersionInfoUtils

+(NSString *)appVersion{
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    
    NSString *appVersion=[infoDic objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}
+(NSString *)appBuildVersion{
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    
    NSString *appBuild=[infoDic objectForKey:@"CFBundleVersion"];
    return appBuild;
}


@end
