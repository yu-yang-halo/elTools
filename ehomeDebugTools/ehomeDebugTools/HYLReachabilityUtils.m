//
//  HYLReachabilityUtils.m
//  ehomeDebugTools
//
//  Created by admin on 15/7/8.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLReachabilityUtils.h"
#import <Reachability/Reachability.h>
#import "HYLCache.h"
#import "HYLWifiUtils.h"

static Reachability *reachability=nil;

@implementation HYLReachabilityUtils

+(BOOL)networkIsAvailable{
    if(reachability==nil){
        reachability=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    }
    if(reachability.isReachable){
         NSLog(@"已经连接上Internet。。。");
    }
   
    return reachability.isReachable;
}

+(void)startNetChecking{
    if(reachability==nil){
        reachability=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    }
    if([reachability isReachableViaWiFi]){
        NSLog(@"网络可用，当前状态：%@",reachability.currentReachabilityString);
        [[HYLCache shareHylCache] setAvailableWIFISSID: [HYLWifiUtils fetchSSIDInfo]];
        
    }
    
    reachability.reachableBlock=^(Reachability * reachability){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([reachability isReachableViaWiFi]){
                NSLog(@"wifi网络可用");
                [[HYLCache shareHylCache] setAvailableWIFISSID: [HYLWifiUtils fetchSSIDInfo]];
            }else{
                NSLog(@"wwan网络可用");
            }
            
        });
    };
    reachability.unreachableBlock=^(Reachability * reachability){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"网络不可用 %@",reachability.currentReachabilityString);
        });
    };
    
    
    [reachability startNotifier];
}

@end
