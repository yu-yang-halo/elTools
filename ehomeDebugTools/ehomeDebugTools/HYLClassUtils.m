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

@implementation HYLClassUtils
+(id)canConvertJSONDataFromObjectInstance:(id)objInstance{
    unsigned int outCount ,i;
    NSMutableDictionary *canConvertJSONInstance=[NSMutableDictionary new];
    objc_property_t *props= class_copyPropertyList([objInstance class],&outCount);
    for (i=0; i<outCount; i++) {
        
        objc_property_t prop=*(props+i);
        NSString *propertyName=[[NSString alloc] initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propertyValue=[objInstance valueForKey:propertyName];
     
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
        binaryclassObj=[NSKeyedArchiver archivedDataWithRootObject:classObj];
        [[NSUserDefaults standardUserDefaults] setObject:binaryclassObj forKey:classIdKey];
        
    }else{
       classObj=[NSKeyedUnarchiver unarchiveObjectWithData:binaryclassObj];
        NSLog(@"缓存数据 %@",classObj);
    }
    return classObj;
}
@end
