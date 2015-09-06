//
//  EsptouchUtils.m
//  ehomeDebugTools
//
//  Created by admin on 15/8/20.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "EsptouchUtils.h"
#import <Esptouch/Esptouch.h>
static const int TASK_COUNT=5;
static const BOOL IS_SSID_HIDDEN=NO;

@implementation EsptouchUtils

+(void)configWifiSSID:(NSString *)apSsid pass:(NSString *)apPassword bssid:(NSString *)apBssid{
    NSLog(@"ESPViewController do confirm action...");
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"ESPViewController do the execute work...");
        
        // execute the task
        ESPTouchTask *_espTouchTask=[[ESPTouchTask alloc] initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPassword andIsSsidHiden:IS_SSID_HIDDEN];
        
        NSArray *esptouchResultArray =[_espTouchTask executeForResults:TASK_COUNT];
        
        // show the result to the user in UI Main Thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
            // check whether the task is cancelled and no results received
            if (!firstResult.isCancelled)
            {
                NSMutableString *mutableStr = [[NSMutableString alloc]init];
                NSUInteger count = 0;
                // max results to be displayed, if it is more than maxDisplayCount,
                // just show the count of redundant ones
                const int maxDisplayCount = 5;
                if ([firstResult isSuc])
                {
                    
                    for (int i = 0; i < [esptouchResultArray count]; ++i)
                    {
                        ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
                        [mutableStr appendString:[resultInArray description]];
                        [mutableStr appendString:@"\n"];
                        count++;
                        if (count >= maxDisplayCount)
                        {
                            break;
                        }
                    }
                    
                    if (count < [esptouchResultArray count])
                    {
                        [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
                    }
                    [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:mutableStr delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
                }
                
                else
                {
                    [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:@"Esptouch fail" delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
                }
            }
            
        });
    });

}
@end
