//
//  HYLContextLibary.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/24.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLContextLibary.h"
#import <ELNetworkService/ELNetworkService.h>
#import "HYLCache.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>
@implementation HYLContextLibary
+(void)loadHylCmd:(HYLCMDTYPE) cmdType toContext:(JSContext *)context handler:(HYLCallBackHandler)_handler{
    switch (cmdType) {
        case HYLCMDTYPE_SETFIELD_VALUE:
        {
            context[@"mobile_setFieldCmd"]=^(){
                NSArray *args=[JSContext currentArguments];
                for (JSValue *jsVal in args) {
                    NSLog(@"argument : %@",jsVal.toString);
                }
                JSValue *thiz=[JSContext currentThis];
                
                NSLog(@"end....%@",thiz);
                
                
               
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    BOOL isOK=[[ElApiService shareElApiService] setFieldValue:[args[0] toString] forFieldId:[args[1] toInt32] toDevice:[args[2] toInt32] withYN:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _handler(isOK,args);
                        if(isOK){
                            [JDStatusBarNotification showWithStatus:@"执行成功" dismissAfter:2 styleName:JDStatusBarStyleDark];
                        }
                        
                    });
                    
                });
                
            };
        }
            break;
        case HYLCMDTYPE_REQUEST_ALL_DEVICES:
        {
            
        }
            break;

        case HYLCMDTYPE_UPDATE_DEVICE_NAME:
        {
            context[@"mobile_updateDeviceName"]=^(){
                NSArray *args=[JSContext currentArguments];
                for (JSValue *jsVal in args) {
                    NSLog(@"argument : %@",jsVal.toString);
                }
                JSValue *thiz=[JSContext currentThis];
                
                NSLog(@"end....%@",thiz);
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    ELDeviceObject *elDevice=[HYLCache shareHylCache].currentELDevice;
                    if(elDevice!=nil&&elDevice.objectId==[[args[1] toString] intValue]){
                        elDevice.name=[args[0] toString];
                    }
                    BOOL isOK=[[ElApiService shareElApiService] updateObject:elDevice];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                         _handler(isOK,nil);
                        
                    });
                });
                
            };
        }
            break;
            
        default:
            break;
    }
}
@end
