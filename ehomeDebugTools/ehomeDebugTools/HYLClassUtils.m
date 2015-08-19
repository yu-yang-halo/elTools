//
//  HYLClassUtils.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/16.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLClassUtils.h"
#import <objc/runtime.h>
#import <ELNetworkService/ELNetworkService.h>
#import "HYLCache.h"

static NSString *kCacheListDataKey=@"KEY_CACHELISTDATA";

@implementation HYLClassUtils

+(id)canConvertJSONDataFromObjectInstance:(id)objInstance{
    unsigned int outCount ,i;
    NSMutableDictionary *canConvertJSONInstance=[NSMutableDictionary new];
    objc_property_t *props= class_copyPropertyList([objInstance class],&outCount);
    for (i=0; i<outCount; i++) {
        
        objc_property_t prop=*(props+i);
        NSString *propertyName=[[NSString alloc] initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propertyValue=[objInstance valueForKey:propertyName];
        NSLog(@"----propertyName %@ propertyValue :%@",propertyName,propertyValue);
        
        
        [canConvertJSONInstance setValue:propertyValue forKey:propertyName];
    }
    free(props);
    return canConvertJSONInstance;
}
+(id)classObjectFromCache:(NSInteger)classId{
    NSString *classIdKey=[NSString stringWithFormat:@"%d",classId];
    
    
    id binaryclassObj=[[NSUserDefaults standardUserDefaults] objectForKey:classIdKey];
    
    ELClassObject *classObj=nil;
    
    if(binaryclassObj==nil){
        classObj=[[ElApiService shareElApiService] getClassById:classId];
        
        [self addFieldDisableYNProperties:classObj];
        
        
        
        binaryclassObj=[NSKeyedArchiver archivedDataWithRootObject:classObj];
        [[NSUserDefaults standardUserDefaults] setObject:binaryclassObj forKey:classIdKey];
        
        
    }else{
         classObj=[NSKeyedUnarchiver unarchiveObjectWithData:binaryclassObj];
        NSLog(@"缓存数据 %@",classObj);
    }
    return classObj;
}

+(void)addFieldDisableYNProperties:(ELClassObject *)classObj{
    if([HYLCache shareHylCache].fieldList==nil||[[HYLCache shareHylCache].fieldList count]==0){
        return;
    }
    for (ELClassField *clsField in classObj.classFields) {
        for (NSDictionary *fieldDic in [HYLCache shareHylCache].fieldList) {
            
            if([[fieldDic valueForKey:@"fieldId"] isEqualToNumber:[NSNumber numberWithLong:clsField.fieldId]]){
                BOOL disableYN=NO;
                
                if([[NSString stringWithFormat:@"%@",[fieldDic valueForKey:@"disableYN"]] isEqualToString:@"0"]){
                    disableYN=YES;
                }
                [clsField setValue:[NSNumber numberWithBool:disableYN] forKey:@"disableYN"];
                
            }
            
            
        }

    }
    
}


+(void)cacheClasslistData:(id)classlistData{
   
    [[NSUserDefaults standardUserDefaults] setObject:classlistData forKey:kCacheListDataKey];
    
}

+(id)classListData{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCacheListDataKey];
}
+(void)removeAllClassDataCaches{
    NSUserDefaults *defs=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defs dictionaryRepresentation];
    NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc] init];
    for (NSString* key in dic){
        if([numberFormatter numberFromString:key]){
            //NSLog(@"移除classId is %@",key);
            [defs removeObjectForKey:key];
        }
    }
    
    [defs synchronize];
    
    
}

@end
