//
//  EsptouchUtils.h
//  ehomeDebugTools
//
//  Created by admin on 15/8/20.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EsptouchUtils : NSObject

+(void)configWifiSSID:(NSString *)apSsid pass:(NSString *)apPassword bssid:(NSString *)apBssid;

@end
