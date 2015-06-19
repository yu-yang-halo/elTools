//
//  HYLClassUtils.h
//  ehomeDebugTools
//
//  Created by admin on 15/6/16.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYLClassUtils : NSObject

#pragma mark 将普通类转化为map类型（该类型才可使用jsonkit转化为string）
+(id)canConvertJSONDataFromObjectInstance:(id)objInstance;

#pragma mark 从缓存中获取classobject，没有再发送网络请求，节省网络流量，提高加载速度
+(id)classObjectFromCache:(NSInteger)classId;

+(void)cacheClasslistData:(id)classlistData;
+(id)classListData;

@end
