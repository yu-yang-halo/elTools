//
//  HYLCache.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/24.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLCache.h"

static HYLCache *instance=nil;
@implementation HYLCache

+(instancetype)shareHylCache{
    @synchronized(self){
        if(instance==nil){
            instance=[[HYLCache alloc] init];
        }
        return instance;
    }
}
@end
