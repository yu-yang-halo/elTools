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
#import "HYLRoutes.h"
#import "ViewController.h"
NSString *const kNotificationUpdateUI=@"kNotificationUpdateUI";
NSString *const keyAsso=@"keyAsso";
@implementation UIViewController (barTheme)

+(void)load{
    NSLog(@"UIViewController (nibLoading)");
    // Inject "-pushViewController:animated:"
    Method originalMethod = class_getInstanceMethod(self, @selector(awakeFromNib));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(hyl_awakeFromNib));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)hyl_awakeFromNib{
    [self hyl_awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNavigationBar) name:kNotificationUpdateUI object:nil];
   
    UINavigationController *tagNavigationVC=nil;
    if([self isKindOfClass:[UINavigationController class]]){
         NSLog(@"UINavigationController hyl_awakeFromNib  init");
        tagNavigationVC=(UINavigationController *)self;
    }else if([self isKindOfClass:[UIViewController class]]){
         //NSLog(@"UIViewController hyl_awakeFromNib  init");
        tagNavigationVC=self.navigationController;
    }
    objc_setAssociatedObject(self, &keyAsso,tagNavigationVC, OBJC_ASSOCIATION_RETAIN);
    
    [self updateNavigationBar];
    
}

-(void)updateNavigationBar{
    UINavigationController *_naVC=objc_getAssociatedObject(self, &keyAsso);
    
    
    [HYLRoutes loadUserConfig];
    NSArray *barColorRGBArr=[[HYLCache shareHylCache].configJSON valueForKey:@"barColor"];
    ;
    NSArray *fontColorRGBArr=[[HYLCache shareHylCache].configJSON valueForKey:@"fontColor"];
    
    float fontSize=[[[HYLCache shareHylCache].configJSON valueForKey:@"fontSize"] floatValue];
    
    [_naVC.navigationBar setBarTintColor:[UIColor colorWithRed:[[barColorRGBArr objectAtIndex:0] intValue] green:[[barColorRGBArr objectAtIndex:1] intValue] blue:[[barColorRGBArr objectAtIndex:2] intValue] alpha:1]];
    
    
    [_naVC.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIColor *fontColor=[UIColor colorWithRed:[[fontColorRGBArr objectAtIndex:0] intValue] green:[[fontColorRGBArr objectAtIndex:1] intValue] blue:[[fontColorRGBArr objectAtIndex:2] intValue] alpha:1];
    
    
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]<7.0){
        [_naVC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fontColor,UITextAttributeTextColor, [UIFont systemFontOfSize:fontSize],UITextAttributeFont,nil]];
        
    }else{
        [_naVC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fontColor,NSForegroundColorAttributeName, [UIFont systemFontOfSize:fontSize],NSFontAttributeName,nil]];
    }
    

}

@end
@implementation UINavigationController (statusBar)

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end