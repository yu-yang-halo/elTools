//
//  Util.m
//  objectc_ehome
//
//  Created by admin on 14-10-15.
//  Copyright (c) 2014年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "RegUtil.h"

@implementation RegUtil

+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(BOOL)isEmail:(NSString *)_email{
    NSString *_EM=@"^([a-z0-9A-Z]+[-|._]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?.)+[a-zA-Z]{2,}$";
    //^[a-zA-Z][a-zA-Z0-9_.-]*@[0-9a-zA-Z]+(.[a-zA-Z]+)+$
    NSPredicate *regexEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _EM];
    
    if ([regexEmail evaluateWithObject:_email] == YES){
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isAgeNumber:(NSString *)_num{
    NSString *_EM=@"^[1]{0,1}[1-9][0-9]$";
    //^[a-zA-Z][a-zA-Z0-9_.-]*@[0-9a-zA-Z]+(.[a-zA-Z]+)+$
    NSPredicate *regexEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _EM];
    
    if ([regexEmail evaluateWithObject:_num] == YES){
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isIPAddress:(NSString *)ipAddr{
    //((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)
    NSString *_EM=@"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
    
    NSPredicate *regexIP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _EM];
    
    if ([regexIP evaluateWithObject:ipAddr] == YES){
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)isDeviceSN:(NSString *)SN{
    NSString *_EM=@"^[A-Z0-9]{6,}$";
    NSPredicate *regexEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _EM];
    
    if ([regexEmail evaluateWithObject:SN] == YES){
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isCharacter:(NSString *)_str rangeMin:(NSInteger)_min andMax:(NSInteger)_max{
    NSString *_CHAR=[NSString stringWithFormat:@"^\\w{%d,%d}$",_min,_max] ;
    NSPredicate *regexChar = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _CHAR];
    if ([regexChar evaluateWithObject:_str] == YES){
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isEmpty:(NSString *)_str{
    if(_str==nil){
        return YES;
    }
    return [[_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
}
+(NSString *)trim:(NSString *)_str{
    return [[_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}


+(NSString *)encodeToBase64String:(UIImage *)image format:(NSString *)PNGorJPEG{
    if([PNGorJPEG isEqualToString:@"PNG"]){
        return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else{
        return [UIImageJPEGRepresentation(image,0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
}
+(UIImage *)decodeBase64ToImage:(NSString *)strEncodeData{
    NSData *data=[[NSData alloc] initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
