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
#import "HYLResourceUtil.h"
@interface ViewController (){
    MBProgressHUD *hud;
}
@end
static NSString *kloginUserName=@"keyLoginUserName";
static NSString *kloginPassword=@"keyLoginPassword";

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{

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
    
    
    //NSString *htmlString=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"index.html" ofType:@""] encoding:NSUTF8StringEncoding error:nil];
    
    NSString *filePath=[[HYLResourceUtil documentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"FILEPATH"],@"index.html"]];

    
    
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    //[self.webView loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
    //NSString *path=[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"index.html"];
    
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    
    NSLog(@"bundURL:%@\n ::: %@",[[NSBundle mainBundle] bundleURL],[NSURL URLWithString:[[NSBundle mainBundle] bundlePath]]);
    
    
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
        
        
                
        
        NSString *netstate=[[NSUserDefaults standardUserDefaults] objectForKey:deviceNetworkStateKey];
        
        if([netstate isEqualToString:@"1"]){
            
            [self asynlogin:[args[0] toString] withPass:[args[1] toString]];
        
        }else{
            
            [self.view makeToast:@"网络连接有问题，请检查"];
        
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
                 message=@"登录成功！";
                [HYLClassUtils removeAllClassDataCaches];
                
                [[NSUserDefaults standardUserDefaults] setObject:name forKey:kloginUserName];
                [[NSUserDefaults standardUserDefaults] setObject:pass forKey:kloginPassword];
                
                 [self performSegueWithIdentifier:@"deviceList" sender:self];
            }else{
                 message=@"用户名或密码错误！";
                 [self.view makeToast:message];
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
