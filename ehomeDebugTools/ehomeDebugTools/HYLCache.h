//
//  HYLCache.h
//  ehomeDebugTools
//
//  Created by admin on 15/6/24.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ELNetworkService/ELNetworkService.h>

@interface HYLCache : NSObject

+(instancetype)shareHylCache;


@property(nonatomic,retain) ELDeviceObject *currentELDevice;

@property(nonatomic,retain) NSDictionary *configJSON;
@property(nonatomic,retain) NSArray      *fieldList;
@property(nonatomic,retain) NSArray      *tagList;
@property(nonatomic,retain) NSString *availableWIFISSID;

@end
