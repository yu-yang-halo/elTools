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
static NSString *isHasCommonRes=@"key_is_has_common_res";

static NSString *commonFileName=@"ui";

@interface HYLRoutes()
+(void)startDownload:(NSString *)fileName isCommon:(BOOL)isCommon;
@end

@implementation HYLRoutes
+(BOOL)isHasCommonRes{
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:isHasCommonRes];
    
}
+(void)startDownload:(NSString *)fileName isCommon:(BOOL)isCommon{
    NSString *filePath=[NSString stringWithFormat:@"http://192.168.2.111/public_cloud/upload/%@.zip",fileName];
    
    
    [HYLResourceUtil downloadWebResource:filePath block:^(BOOL isfinished, id data) {
        
        if(isfinished){
            NSLog(@"本地沙盒路径：：%@",data);
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:keyfilePath];
            if(isCommon){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isHasCommonRes];
            }
            
            
        }else{
            if(isCommon){
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:keyfilePath];
                 NSLog(@"common文件下载失败，切换到bundle路径读取");
            }else{
                 NSLog(@"%@用户文件下载失败，切换到common路径读取",data);
            }
            
        }
    }];

}
+(void)downloadCommonResources{
     NSLog(@"开始下载公共资源 ui.zip ~~~");
    [self startDownload:commonFileName isCommon:YES];
}
+(void)downloadUserResources:(NSString *)fileName{
    NSLog(@"开始下载用户资源 %@.zip ~~~",fileName);
    [self startDownload:fileName isCommon:NO];
}


+(NSString *)resourceRootPath{
    
   NSString *filePath=[[NSUserDefaults standardUserDefaults] objectForKey:keyfilePath];
    if(filePath==nil||[filePath isEqualToString:@""]){
        return [[NSBundle mainBundle] bundlePath];
    }else{
        return [[HYLResourceUtil documentPath] stringByAppendingPathComponent:filePath];
    }
    
}
+(void)loadUserConfig{
    NSLog(@"加载配置文件~~~");
    [HYLResourceUtil loadConfigResource:[HYLRoutes resourceRootPath]];
}

@end
