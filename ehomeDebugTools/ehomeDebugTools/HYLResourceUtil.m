//
//  HYLResourceUtil.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLResourceUtil.h"
#import "ZipArchive.h"


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
       
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);//使用C函数NSSearchPathForDirectoriesInDomains来获得沙盒中目录的全路径。
        NSString *ourDocumentPath =documentPaths[0];
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
        NSString *unzipSaveFilePath=[saveFilePath stringByDeletingPathExtension];
        
        if(isWriteToFile){
            NSLog(@"%@ 文件写入成功",saveFilePath);
            
            //解压文件后，去掉文件后缀 x.zip-->x
            isUnZipSuc=[self OpenZip:saveFilePath unzipto:unzipSaveFilePath];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            _block(isWriteToFile&&isUnZipSuc,unzipSaveFilePath);
            
        });
        
    });
   
    
    
}
@end
