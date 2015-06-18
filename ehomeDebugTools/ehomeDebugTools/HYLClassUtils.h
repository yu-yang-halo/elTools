//
//  HYLClassUtils.h
//  ehomeDebugTools
//
//  Created by admin on 15/6/16.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYLClassUtils : NSObject

+(id)canConvertJSONDataFromObjectInstance:(id)objInstance;
+(id)classObjectFromCache:(NSInteger)classId;
@end
