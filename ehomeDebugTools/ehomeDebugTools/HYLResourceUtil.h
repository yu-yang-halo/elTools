//
//  HYLResourceUtil.h
//  ehomeDebugTools
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *uiPathName;

typedef void(^HYLResourceUtilBlock)(BOOL isfinished,id data);



//@"uiPackage"

@interface HYLResourceUtil : NSObject



+(void)downloadWebResource:(NSString *)webPath block:(HYLResourceUtilBlock)_block;

+(void)loadFieldConfigResource:(NSString *)configResPath;
+(void)loadConfigResource:(NSString *)configResPath;

+(NSString *)documentPath;
@end
