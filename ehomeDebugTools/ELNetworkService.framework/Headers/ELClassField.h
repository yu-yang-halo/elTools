//
//  ELClassField.h
//  ELNetworkService
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 LZTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELClassField : NSObject

@property(nonatomic,assign) NSInteger  fieldId;
@property(nonatomic,retain) NSString  *fieldName;
@property(nonatomic,retain) NSString  *displayName;
@property(nonatomic,assign) NSInteger  dataType;
@property(nonatomic,assign) BOOL       deviceStateYN;
@property(nonatomic,assign) BOOL       deviceCmdYN;
@property(nonatomic,assign) BOOL       tsYN;//历史数据
@property(nonatomic,assign) BOOL       presistYN;
@property(nonatomic,retain) NSString  *defaultValue;
@property(nonatomic,assign) NSInteger  aggrMethod;


@end
