//
//  ViewController.m
//  ehomeDebugTools
//
//  Created by admin on 15/5/4.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import <ELNetworkService/ELNetworkService.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "HYLClassUtils.h"
#import "HYLCache.h"
#import "HYLRoutes.h"
#import "HYLReachabilityUtils.h"
@interface ViewController (){
    MBProgressHUD *hud;
}
@end
NSString *kloginUserName=@"keyLoginUserName";
static NSString *kloginPassword=@"keyLoginPassword";

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
}
-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[[[HYLCache shareHylCache].configJSON valueForKey:@"title"] valueForKey:@"login"];
    
    
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc] init];
    [backButton setTitle:@"返回"];
    self.navigationItem.backBarButtonItem=backButton;
    [self loadHtmlContent];
    
    
}

-(void)loadHtmlContent{
    
    self.webView.delegate=self;
    self.webView.scrollView.scrollEnabled=NO;
    
    
    NSString *filePath=[[HYLRoutes uiResourcePath] stringByAppendingPathComponent:@"index.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

    
   // NSLog(@"bundURL:%@\n ::: %@",[[NSBundle mainBundle] bundleURL],[NSURL URLWithString:[[NSBundle mainBundle] bundlePath]]);
    
    
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"mobile_loadDefaultUsernamePass"]=^(){
    
       NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:kloginUserName];
        
       NSString *password=[[NSUserDefaults standardUserDefaults] objectForKey:kloginPassword];
        
       if(username!=nil&&password!=nil){
           [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_setUsernamePassToView('%@','%@')",username,password]];
        }
       
        
    };
    
    context[@"mobile_login"]=^(){
        NSLog(@"objc_login....");
        
        NSArray *args=[JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"argument : %@",jsVal.toString);
        }
        JSValue *thiz=[JSContext currentThis];
        
        NSLog(@"end....%@",thiz);
        
        
                
        if(![HYLReachabilityUtils networkIsAvailable]){
            [self.view makeToast:@"当前没有可用的网络~"];
        }else{
            [self asynlogin:[args[0] toString] withPass:[args[1] toString]];
        }
    };
}
-(void)asynlogin:(NSString *)name withPass:(NSString *)pass{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"登录中...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isOK=[[ElApiService shareElApiService] loginByUsername:name andPassword:pass];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
             NSString *message=nil;
            if(isOK){
                // message=@"登录成功！";
                [HYLRoutes downloadUserResources:name];
                
                [HYLClassUtils removeAllClassDataCaches];
                
                [[NSUserDefaults standardUserDefaults] setObject:name forKey:kloginUserName];
                [[NSUserDefaults standardUserDefaults] setObject:pass forKey:kloginPassword];
                
                 [self performSegueWithIdentifier:@"deviceList" sender:self];
                
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }else{
                 //message=@"用户名或密码错误！";
                
            }
            
            
           
        });
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *send=segue.destinationViewController;
    
    if([send respondsToSelector:@selector(setData:)]){
        [send performSelector:@selector(setData:) withObject:@"news"];
    }
}

#pragma mark delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.labelText=@"加载中。。。";
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud hide:YES];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    [hud hide:YES];
}


@end
