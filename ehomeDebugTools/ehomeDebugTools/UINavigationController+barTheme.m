//
//  UINav.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "UINavigationController+barTheme.h"
#import <objc/runtime.h>

@implementation UIViewController (barTheme)

+(void)load{
    NSLog(@"UIViewController (nibLoading)");
    // Inject "-pushViewController:animated:"
    Method originalMethod = class_getInstanceMethod(self, @selector(awakeFromNib));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(hyl_awakeFromNib));
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
}
- (void)hyl_awakeFromNib{
    [self hyl_awakeFromNib];
   
    if([self isKindOfClass:[UINavigationController class]]){
         NSLog(@"UINavigationController hyl_awakeFromNib  init");
        
        
        [((UINavigationController *)self).navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navigation2"] forBarMetrics:UIBarMetricsDefault];
        [((UINavigationController *)self).navigationBar setTintColor:[UIColor whiteColor]];
        if([[[UIDevice currentDevice] systemVersion] floatValue]<7.0){
            [((UINavigationController *)self).navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, [UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
            
        }else{
            [((UINavigationController *)self).navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:18],NSFontAttributeName,nil]];
        }
    }else{
         NSLog(@"UIViewController hyl_awakeFromNib  init");
    }
    
    
}

@end