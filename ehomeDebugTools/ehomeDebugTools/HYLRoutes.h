//
//  HYLRoutes.h
//  ehomeDebugTools
//
//  Created by admin on 15/7/1.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 负责ui资源版本的判断
 负责ui资源下载读取任务
 
 */
@interface HYLRoutes : NSObject
+(BOOL)isNewVersion;
+(void)startDownload;
+(NSString *)resourceRootPath;

@end
