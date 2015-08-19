//
//  HYLRoutes.m
//  ehomeDebugTools
//
//  Created by admin on 15/7/1.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLRoutes.h"
#import "HYLResourceUtil.h"
#import "ViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIView+Toast.h>
#import <objc/runtime.h>
#import <ELNetworkService/ELNetworkService.h>
#import "UINavigationController+barTheme.h"
#import "HYLReachabilityUtils.h"
static NSString *keyfilePath=@"key_file_path";
static BOOL systemResYN=YES;

@interface HYLRoutes()
+(void)startDownload:(NSString *)fileName;
@end

@implementation HYLRoutes
+(void)startDownload:(NSString *)fileName{
    if(fileName==nil||[fileName isEqualToString:@""]){
        [[[UIApplication sharedApplication] keyWindow] makeToast:@"系统无法找到资源，请先登录"];
    }else{
        
        if([self isAllowDownload]&&[HYLReachabilityUtils networkIsAvailable]){
            NSString *filePath=[NSString stringWithFormat:@"http://%@/public_cloud/upload/%@.zip",[ElApiService currentIPAddress],fileName];
            NSLog(@"资源下载地址：%@",filePath);
            
            MBProgressHUD *progressHUD=[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [progressHUD setLabelText:@"下载中..."];
            [HYLResourceUtil downloadWebResource:filePath block:^(BOOL isfinished, id data) {
                
                [progressHUD hide:YES];
                
                if(isfinished){
                    NSLog(@"本地沙盒路径存储：：%@",data);
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:keyfilePath];
                    
                    [self disableDownload];
                    [[[UIApplication sharedApplication] keyWindow] makeToast:@"更新完成"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateUI object:nil];
                    
                }else{
                    NSLog(@"%@用户文件下载失败，切换到bundle路径读取",data);
                    [[[UIApplication sharedApplication] keyWindow] makeToast:@"您还没有自定义资源"];
                }
            }];
        }else{
            [[[UIApplication sharedApplication] keyWindow] makeToast:@"文件无法下载，请检查网络"];
        }

    
    }
    
    
    

}

+(void)downloadUserResources:(NSString *)fileName{
    NSLog(@"开始下载用户资源 %@.zip ~~~",fileName);
    [self startDownload:fileName];
}


+(NSString *)resourceRootPath{
    
    NSString *filePath=[[NSUserDefaults standardUserDefaults] objectForKey:keyfilePath];
    if(filePath==nil||[filePath isEqualToString:@""]){
         systemResYN=YES;
        return [[NSBundle mainBundle] bundlePath];
    }else{
         systemResYN=NO;

        return [[HYLResourceUtil documentPath] stringByAppendingPathComponent:filePath];
    }
}

+(BOOL)isSystemResouces{
    [self resourceRootPath];
    
    return systemResYN;
}
+(void)resetToSystemResource{
     [[NSUserDefaults standardUserDefaults] setObject:nil forKey:keyfilePath];
    
}

+(NSString *)uiResourcePath{
    NSString *uifilePath=[[self resourceRootPath] stringByAppendingPathComponent:uiPathName];
    NSArray *arr=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:uifilePath error:nil];
   
    
    
    if(arr!=nil&&[arr count]>0){
       NSLog(@"用户自定义的ui路径 %@",uifilePath);
       
    }else{
        NSLog(@"没有用户自定义的ui，切换到bundle ui");
        uifilePath=[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:uiPathName];
    }
    return uifilePath;
}
+(void)loadUserConfig{
    NSLog(@"加载配置文件~~~");
    [HYLResourceUtil loadConfigResource:[HYLRoutes uiResourcePath]];
    [HYLResourceUtil loadFieldConfigResource:[HYLRoutes uiResourcePath]];
}

@end
static NSString * kAllowDownload=@"key_allow_download";
@implementation HYLRoutes (downloadlock)

+(BOOL)isAllowDownload{
    if([[NSUserDefaults standardUserDefaults] boolForKey:kAllowDownload]){
        return NO;
    }else{
        return YES;
    }
}
+(void)enableDownload{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kAllowDownload];
    
    NSString *loginName=[[NSUserDefaults standardUserDefaults] objectForKey:kloginUserName];
    NSLog(@"enable 下载.... :%@.zip ",loginName);
    
    [self startDownload:loginName];
}
+(void)disableDownload{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAllowDownload];
}
@end
