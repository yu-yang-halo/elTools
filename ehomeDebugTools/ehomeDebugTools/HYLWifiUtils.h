//
//  HYLWifiUtils.h
//  ehomeDebugTools
//
//  Created by admin on 15/7/7.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

//负责wifi的设置
//负责wifi列表的获取

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HYLWifiUtils : NSObject
+(id)fetchSSIDInfo;

+(void)reqConfigWifiSSID:(NSString *)ssid password:(NSString *)pass;
+(void)reqConfigServer;
+(void)reqWIFIInformation;

@end
