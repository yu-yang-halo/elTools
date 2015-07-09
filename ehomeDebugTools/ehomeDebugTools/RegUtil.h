//
//  Util.h
//  objectc_ehome
//
//  Created by admin on 14-10-15.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RegUtil : NSObject
+(BOOL)isMobileNumber:(NSString *)mobileNum;
+(BOOL)isEmail:(NSString *)_email;
+(BOOL)isCharacter:(NSString *)_str rangeMin:(NSInteger)_min andMax:(NSInteger)_max;
+(BOOL)isAgeNumber:(NSString *)_num;
+(BOOL)isDeviceSN:(NSString *)SN;
+(BOOL)isCharacter:(NSString *)_str rangeMin:(NSInteger)_min andMax:(NSInteger)_max;
+(BOOL)isEmpty:(NSString *)_str;
+(NSString *)trim:(NSString *)_str;
+(NSString *)encodeToBase64String:(UIImage *)image format:(NSString *)PNGorJPEG;
+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
+(BOOL)isIPAddress:(NSString *)ipAddr;

@end
