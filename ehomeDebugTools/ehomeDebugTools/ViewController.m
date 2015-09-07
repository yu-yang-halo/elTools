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
#import "UINavigationController+barTheme.h"
@interface ViewController (){
    MBProgressHUD *hud;
}
@end
const  NSString *kloginUserName=@"keyLoginUserName";
const  NSString *kloginPassword=@"keyLoginPassword";
@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
   
    
    self.title=[[[HYLCache shareHylCache].configJSON valueForKey:@"title"] valueForKey:@"login"];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self initHtmlUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadHtmlContent];
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc] init];
    [backButton setTitle:@"返回"];
    self.navigationItem.backBarButtonItem=backButton;
    
}


-(void)initHtmlUserInfo{
    
    NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:kloginUserName];
    
    NSString *password=[[NSUserDefaults standardUserDefaults] objectForKey:kloginPassword];
    
    if(username!=nil&&password!=nil){
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_setUsernamePassToView('%@','%@')",username,password]];
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"initCheckBox(%@)",@"true"]];
    }else{
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_setUsernamePassToView('%@','%@')",@"",@""]];
        
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"initCheckBox(%@)",@"false"]];
    }

}

-(void)requestIndexHtml{
    NSString *filePath=[[HYLRoutes uiResourcePath] stringByAppendingPathComponent:@"index.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)loadHtmlContent{
    
    self.webView.delegate=self;
    self.webView.scrollView.scrollEnabled=NO;
    
    [self requestIndexHtml];
    
    
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"mobile_loadDefaultUsernamePass"]=^(){
        
        
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
            [self asynlogin:[args[0] toString] withPass:[args[1] toString] isRemember:[args[2] toBool]];
        }
    };
}

-(void)saveUsername:(NSString *)name AndPassword:(NSString *)pass{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kloginUserName];
    [[NSUserDefaults standardUserDefaults] setObject:pass forKey:kloginPassword];
}
-(void)clearUsernameAndPassword{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kloginUserName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kloginPassword];
    
}


-(void)asynlogin:(NSString *)name withPass:(NSString *)pass isRemember:(BOOL)isRem{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"登录中...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isOK=[[ElApiService shareElApiService] loginByUsername:name andPassword:pass];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            if(isOK){
                
                 if(isRem){
                    [self saveUsername:name AndPassword:pass];
                 }else{
                    [self clearUsernameAndPassword];
                 }
                 [HYLClassUtils removeAllClassDataCaches];
                
               
                 [self performSegueWithIdentifier:@"deviceList" sender:self];
                
                 //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
            
            
           
        });
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //UIViewController *send=segue.destinationViewController;
}

#pragma mark delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud hide:YES];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    [self initHtmlUserInfo];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    [hud hide:YES];
}


@end
