//
//  AppDelegate.m
//  ehomeDebugTools
//
//  Created by admin on 15/5/4.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import <ELNetworkService/ELNetworkService.h>
#import "HYLResourceUtil.h"
#import "HYLRoutes.h"
#import "HYLReachabilityUtils.h"
#import "HYLWIFITableViewController.h"
#import "UIImageView+WebCache.h"
#import "HYLSysConfigViewController.h"
#import "HYLWifiUtils.h"

@interface AppDelegate ()
@property (strong, nonatomic) UIView *lunchView;
@end

@implementation AppDelegate

@synthesize lunchView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"didFinishLaunchingWithOptions...");
    
    [self.window makeKeyAndVisible];
    
    [HYLReachabilityUtils startNetChecking];
    
    
    
    
    
    //[HYLWifiUtils reqConfigWifiSSID:@"lztech-host" password:@"cell7894"];
    
    
    NSString *store_IPAddress=[[NSUserDefaults standardUserDefaults] objectForKey:key_storeIPAddress];
    
    if(store_IPAddress!=nil){
        [ElApiService setCurrentIPAddress:store_IPAddress];
    }
    
    
    if(![HYLRoutes isSystemResouces]){
        
        lunchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
        lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width,
                                     self.window.screen.bounds.size.height);
        [self.window addSubview:lunchView];
        
        
        UIImage *launchImage=[[UIImage alloc] initWithContentsOfFile:[[HYLRoutes uiResourcePath] stringByAppendingPathComponent:@"img/launchLogo.png"]];
        
        if(launchImage==nil){
            launchImage=[UIImage imageNamed:@"launchLogo"];
        }
        
        lunchView.layer.contents=(__bridge id)launchImage.CGImage;
        lunchView.layer.contentsScale=launchImage.scale;
        lunchView.layer.contentsGravity=kCAGravityResizeAspectFill;
        
        
        
        [self.window bringSubviewToFront:lunchView];
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
    }
   

    
    return YES;
}
-(void)removeLun {
    [lunchView removeFromSuperview];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive...");
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
    NSLog(@"applicationDidEnterBackground...");
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground...");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWIFIPageLogic object:nil];

    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     NSLog(@"applicationDidBecomeActive...");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate...");
}

@end


