//
//  HYLWifiUtils.m
//  ehomeDebugTools
//
//  Created by admin on 15/7/7.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLWifiUtils.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <UIView+Toast.h>
#import <SIAlertView/SIAlertView.h>
@implementation HYLWifiUtils
+(id)fetchSSIDInfo{
    NSArray *ifs=(__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"%s:support interfaces :%@",__func__,ifs);
    id info=nil;
    
    for (NSString *ifnam in ifs) {
        info=(__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@==>%@",ifnam,info);
        break;
        
    }
    
    NSString *ssid=[info objectForKey:@"SSID"];
    
    
    
    return ssid;
    
    
}
+(void)reqConfigWifiSSID:(NSString *)ssid password:(NSString *)pass{
  //JSON 数据 {Request:{Station:{Connect_Station:{ssid:'lztech-host',password:'cell7894'}}}}
  //http://192.168.4.1/config?command=wifi
    
    NSString *jsonDataStr=[NSString stringWithFormat:@"{\"Request\":{\"Station\":{\"Connect_Station\":{\"ssid\":\"%@\",\"password\":\"%@\"}}}}",ssid,pass];
    NSLog(@"%@",jsonDataStr);
    
    NSString *commandAddr=@"http://192.168.4.1/config?command=wifi";
    
    [self requestAddr:commandAddr jsonParam:[jsonDataStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    
}

+(void)reqConfigServer{
    //JSON 数据 {\"Request\":{\"Server\":{\"ip\":\"ns3.elnet.cn\",\"tcpport\":\"2050\",\"udpport\":\"3050\",\"type\":\"1\",\"encryption\":\"1\"}}}
    //http://192.168.4.1/config?command=server
    NSString *jsonDataStr=@"{\"Request\":{\"Server\":{\"ip\":\"ns3.elnet.cn\",\"tcpport\":\"2050\",\"udpport\":\"3050\",\"type\":\"1\",\"encryption\":\"1\"}}}";
    NSLog(@"%@",jsonDataStr);
    
    NSString *commandAddr=@"http://192.168.4.1/config?command=server";
    
    [self requestAddr:commandAddr jsonParam:[jsonDataStr dataUsingEncoding:NSUTF8StringEncoding]];
    
}
+(void)reqWIFIInformation{
    //http://192.168.4.1/client?command=info
    
    NSString *commandAddr=@"http://192.168.4.1/client?command=info";
    
    [self requestAddr:commandAddr jsonParam:nil];
}

+(void)requestAddr:(NSString *)addr jsonParam:(NSData *)jsonData{
     NSURL *url=[NSURL URLWithString:addr];
    
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    if(jsonData==nil){
        [request setHTTPMethod:@"GET"];
    }else{
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
    }
    
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if(data){
            NSString *dataStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"data  ### %@ ###\n",dataStr);
            if([[dataStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
               // message=@"执行成功";
                SIAlertView *alertView=[[SIAlertView alloc] initWithTitle:@"配置成功" andMessage:@"您现在的网络已断开，是否重新联网？"];
                
                [alertView addButtonWithTitle:@"否" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
                    
                }];
                [alertView addButtonWithTitle:@"是" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
                }];
                alertView.transitionStyle=SIAlertViewTransitionStyleFade;
                
                [alertView show];

            }else{
                [[[UIApplication sharedApplication] keyWindow] makeToast:dataStr];
            }
            
            
        }else{
            NSLog(@"error ### %@ ###\n",connectionError);
            [[[UIApplication sharedApplication] keyWindow] makeToast:[connectionError description]];
        }
        
    }];

}

@end
