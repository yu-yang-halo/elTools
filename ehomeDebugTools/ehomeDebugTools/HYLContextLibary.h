//
//  HYLContextLibary.h
//  ehomeDebugTools
//
//  Created by admin on 15/6/24.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
typedef NS_ENUM(NSInteger,HYLCMDTYPE){
    HYLCMDTYPE_SETFIELD_VALUE,
    HYLCMDTYPE_UPDATE_DEVICE_NAME,
    HYLCMDTYPE_REQUEST_ALL_DEVICES
};

typedef void (^HYLCallBackHandler)(BOOL finished,NSArray *args);

@interface HYLContextLibary : NSObject
+(void)loadHylCmd:(HYLCMDTYPE) cmdType toContext:(JSContext *)context handler:(HYLCallBackHandler)_handler;


@end
