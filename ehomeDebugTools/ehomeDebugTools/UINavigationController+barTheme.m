//
//  UINav.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "UINavigationController+barTheme.h"
#import <objc/runtime.h>
#import "HYLCache.h"
#import "HYLResourceUtil.h"
@implementation UIViewController (barTheme)

+(void)load{
    NSLog(@"UIViewController (nibLoading)");
    // Inject "-pushViewController:animated:"
    Method originalMethod = class_getInstanceMethod(self, @selector(awakeFromNib));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(hyl_awakeFromNib));
    method_exchangeImplementations(originalMethod, swizzledMethod);
      
  
    
//
//    NSString *uiPath=[[NSUserDefaults standardUserDefaults] objectForKey:@"FILEPATH"];
//    
//    [HYLResourceUtil loadConfigResource:[[HYLResourceUtil documentPath] stringByAppendingPathComponent:uiPath]];
    
    
   
}
- (void)hyl_awakeFromNib{
    [self hyl_awakeFromNib];
   
    if([self isKindOfClass:[UINavigationController class]]){
         NSLog(@"UINavigationController hyl_awakeFromNib  init");
        
        
//        [((UINavigationController *)self).navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navigation2"] forBarMetrics:UIBarMetricsDefault];
        NSArray *barColorRGBArr=[[HYLCache shareHylCache].configJSON valueForKey:@"barColor"];
        ;
        NSArray *fontColorRGBArr=[[HYLCache shareHylCache].configJSON valueForKey:@"fontColor"];
        
        float fontSize=[[[HYLCache shareHylCache].configJSON valueForKey:@"fontSize"] floatValue];
        
        [((UINavigationController *)self).navigationBar setBarTintColor:[UIColor colorWithRed:[[barColorRGBArr objectAtIndex:0] intValue] green:[[barColorRGBArr objectAtIndex:1] intValue] blue:[[barColorRGBArr objectAtIndex:2] intValue] alpha:1]];
        
        
        [((UINavigationController *)self).navigationBar setTintColor:[UIColor whiteColor]];
        
        UIColor *fontColor=[UIColor colorWithRed:[[fontColorRGBArr objectAtIndex:0] intValue] green:[[fontColorRGBArr objectAtIndex:1] intValue] blue:[[fontColorRGBArr objectAtIndex:2] intValue] alpha:1];
        
        
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]<7.0){
            [((UINavigationController *)self).navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fontColor,UITextAttributeTextColor, [UIFont systemFontOfSize:fontSize],UITextAttributeFont,nil]];
            
        }else{
            [((UINavigationController *)self).navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fontColor,NSForegroundColorAttributeName, [UIFont systemFontOfSize:fontSize],NSFontAttributeName,nil]];
        }
    }else{
         //NSLog(@"UIViewController hyl_awakeFromNib  init");
    }
    
    
}

@end