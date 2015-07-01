//
//  HYLRoutes.m
//  ehomeDebugTools
//
//  Created by admin on 15/7/1.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLRoutes.h"
#import "HYLResourceUtil.h"
static NSString *keyfilePath=@"key_file_path";

@implementation HYLRoutes
+(BOOL)isNewVersion{
    return YES;
}
+(void)startDownload{
    [HYLResourceUtil downloadWebResource:@"http://192.168.2.111/public_cloud/upload/ui.zip" block:^(BOOL isfinished, id data) {
        
        if(isfinished){
            NSLog(@"本地沙盒路径：：%@",data);
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:keyfilePath];
        }else{
            NSLog(@"切换到本地路径");
            
        }
        [HYLResourceUtil loadConfigResource:[HYLRoutes resourceRootPath]];
        
    }];

}
+(NSString *)resourceRootPath{
    
   NSString *filePath=[[NSUserDefaults standardUserDefaults] objectForKey:keyfilePath];
    if(filePath==nil||[filePath isEqualToString:@""]){
        return @"";
    }else{
        return [[HYLResourceUtil documentPath] stringByAppendingPathComponent:filePath];
    }
    
}


@end
