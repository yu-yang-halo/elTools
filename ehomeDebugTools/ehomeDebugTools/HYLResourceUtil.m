//
//  HYLResourceUtil.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLResourceUtil.h"
#import "ZipArchive.h"
#import <JSONKit/JSONKit.h>
#import "HYLCache.h"

NSString *uiPathName=@"ui";
@interface HYLResourceUtil()

+(void)downloadWebResource:(NSString *)webPath tofile:(NSString *)fileName block:(HYLResourceUtilBlock)_block;

@end

@implementation HYLResourceUtil

+ (BOOL)OpenZip:(NSString*)zipPath  unzipto:(NSString*)_unzipto
{
    ZipArchive* zip = [[ZipArchive alloc] init];
    if( [zip UnzipOpenFile:zipPath] )
    {
        BOOL ret = [zip UnzipFileTo:_unzipto overWrite:YES];
        if( YES==ret )
        {
            NSLog(@"解压成功");
            return ret;
        }
        [zip UnzipCloseFile];
    }
    return NO;
}

+(void)downloadWebResource:(NSString *)webPath block:(HYLResourceUtilBlock)_block{
    
   
    [self downloadWebResource:webPath tofile:webPath.lastPathComponent block:_block];
    
}

+(void)downloadWebResource:(NSString *)webPath tofile:(NSString *)fileName block:(HYLResourceUtilBlock)_block{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSString *ourDocumentPath =[HYLResourceUtil documentPath];
        
        //NSString *sandboxPath = NSHomeDirectory();
        NSString *saveFilePath=[ourDocumentPath stringByAppendingPathComponent:fileName];//fileName就是保存文件的文件名
        
        NSLog(@"saveFilePath : %@",saveFilePath);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // Copy the database sql file from the resourcepath to the documentpath
        if ([fileManager fileExistsAtPath:saveFilePath])
        {
            BOOL isDeleteFile=[fileManager removeItemAtPath:saveFilePath error:nil];
            if(isDeleteFile){
                NSLog(@"%@ 文件已删除...",saveFilePath);
            }
        }
        
        NSURL *url = [NSURL URLWithString:webPath];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        BOOL isWriteToFile=[fileManager createFileAtPath:saveFilePath contents:data attributes:nil];
        
//        BOOL isWriteToFile=[data writeToFile:FileName atomically:NO];//将NSData类型对象data写入文件，文件名为FileName
        BOOL isUnZipSuc=NO;
        
        BOOL isUnzipUIFile=NO;
        NSString *unzipSaveFilePath=[saveFilePath stringByDeletingPathExtension];
        
        if(isWriteToFile){
            NSLog(@"%@ 文件写入成功",saveFilePath);
            
            //解压文件后，去掉文件后缀 x.zip-->x
            isUnZipSuc=[self OpenZip:saveFilePath unzipto:unzipSaveFilePath];
            
            
            
            NSString *uiPathZipFile=[unzipSaveFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",uiPathName]];
            
            NSString *unzipUIPathFile=[uiPathZipFile stringByDeletingPathExtension];
            
            if(isUnZipSuc&&[[NSFileManager defaultManager] fileExistsAtPath:uiPathZipFile]){
                isUnzipUIFile=[self OpenZip:uiPathZipFile unzipto:unzipUIPathFile];
                
                if(isUnzipUIFile){
                    NSLog(@"%@解压成功",uiPathZipFile);
                    
                    [self movefile:[unzipSaveFilePath stringByAppendingPathComponent:@"config.json"] toTarget:[unzipUIPathFile stringByAppendingPathComponent:@"config/config.json"]];
                    [self movefile:[unzipSaveFilePath stringByAppendingPathComponent:@"launchLogo.png"] toTarget:[unzipUIPathFile stringByAppendingPathComponent:@"img/launchLogo.png"]];
                    [self movefile:[unzipSaveFilePath stringByAppendingPathComponent:@"field.json"] toTarget:[unzipUIPathFile stringByAppendingPathComponent:@"config/field.json"]];
                    
                }else{
                    NSLog(@"%@解压失败",uiPathZipFile);
                }
                
            }else{
                NSLog(@"不存在文件%@",uiPathZipFile);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            _block(isWriteToFile&&isUnZipSuc&&isUnZipSuc,[fileName stringByDeletingPathExtension]);
            
        });
        
    });
   
    
    
}
+(void)movefile:(NSString *)srcfile toTarget:(NSString *)dstfile{
    NSFileManager *manager=[NSFileManager defaultManager];
    NSError *err;
    
    if([manager fileExistsAtPath:srcfile]){
        BOOL isDeleteDstFile=YES;
        if([manager fileExistsAtPath:dstfile]){
            
            isDeleteDstFile=[manager removeItemAtPath:dstfile error:nil];
            
        }
        if(isDeleteDstFile){
            BOOL moveSuc=[manager moveItemAtPath:srcfile toPath:dstfile error:&err];
            if(moveSuc){
                NSLog(@"移动成功");
            }else{
                NSLog(@"移动失败%@",err);
            }
        }
       
    }else{
        NSLog(@"%@文件不存在",srcfile);
    }
    
}

+(NSString *)documentPath{
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];
    NSLog(@"documentPath %@",documentPath);
    return documentPath;
}

+(void)loadFieldConfigResource:(NSString *)configResPath{
    NSString *configJSONResPath=[configResPath stringByAppendingPathComponent:@"config/field.json"];
    NSData *configData=[[NSData alloc] initWithContentsOfFile:configJSONResPath];
    if(configData!=nil){
        NSMutableDictionary *fieldConfigDic=[[NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil] mutableCopy];
        NSArray *fieldList=[fieldConfigDic valueForKey:@"fileList"];
        [[HYLCache shareHylCache] setFieldList:fieldList];
    }else{
        [[HYLCache shareHylCache] setFieldList:nil];
    }
}

+(void)loadConfigResource:(NSString *)configResPath{
   /*
    ','多余的逗号讲无法解析
    第二种方式更优
    
    NSString *configJson=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config/config.json" ofType:@""] encoding:NSUTF8StringEncoding error:nil];
   NSDictionary *configDic=[configJson objectFromJSONString];
    NSLog(@"%@,%@",configDic,[[configDic valueForKey:@"title"] valueForKey:@"login"]);
    */
   
    
    
    
    
    NSString *configJSONResPath=[configResPath stringByAppendingPathComponent:@"config/config.json"];
    
    
    NSData *configData=[[NSData alloc] initWithContentsOfFile:configJSONResPath];
    
    
    
    NSMutableDictionary *configDic=[[NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil] mutableCopy];
    
    if (configDic==nil) {
        NSString* configDefaultJSONResPath=[configResPath stringByAppendingPathComponent:@"config/configdefault.json"];
        configData=[NSData dataWithContentsOfFile:configDefaultJSONResPath options:NSUTF8StringEncoding error:nil];
        configDic=[[NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil] mutableCopy];
    }
    
    
    NSArray *barColorRGBArr=[HYLResourceUtil reverseHtmlColorToRGBS:[configDic valueForKey:@"barColor"]];
    
    [configDic setValue:barColorRGBArr forKey:@"barColor"];

    NSArray *fontColorRGBArr=[HYLResourceUtil reverseHtmlColorToRGBS:[configDic valueForKey:@"fontColor"]];
    
    
    [configDic setValue:fontColorRGBArr forKey:@"fontColor"];
    
    
    [[HYLCache shareHylCache] setConfigJSON:configDic];
    
    
}
+(NSArray *)reverseHtmlColorToRGBS:(NSString *)colorString{
    //#ff00aa
    NSArray *defaultRGBArr= [NSArray arrayWithObjects:@0,@233,@0,nil];
    
    if([colorString hasPrefix:@"#"]&&[colorString length]==7)
    {
        NSString *tempColor=[colorString substringFromIndex:1];
        if ([tempColor length]==6) {
            NSString *redString=[NSString stringWithFormat:@"0x%@",[tempColor substringWithRange:NSMakeRange(0,2)]];
            
            
            unsigned long red=strtoul([redString UTF8String],0,16);
            NSString *greenString=[NSString stringWithFormat:@"0x%@",[tempColor substringWithRange:NSMakeRange(2,2)]];
            unsigned long green=strtoul([greenString UTF8String],0,16);
            NSString *blueString=[NSString stringWithFormat:@"0x%@",[tempColor substringWithRange:NSMakeRange(4,2)]];
            unsigned long blue=strtoul([blueString UTF8String],0,16);
            
            NSLog(@"%@ ,%@ ,%@",redString,greenString,blueString);
            NSLog(@"%ld ,%ld ,%ld",red,green,blue);
            
            return [NSArray arrayWithObjects:@(red),@(green),@(blue),nil];
        }else{
            return defaultRGBArr;
        }
        
    }else{
        return defaultRGBArr;
    }
}
@end
