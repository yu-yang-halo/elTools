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
@interface ViewController (){
    MBProgressHUD *hud;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self loadHtmlContent];

}
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
-(void)loadHtmlContent{
    NSString *htmlPath=[[NSBundle mainBundle] resourcePath];
    htmlPath=[htmlPath stringByAppendingPathComponent:@"index.html"];
    
    self.webView.delegate=self;
    self.webView.scrollView.scrollEnabled=NO;
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]]];
    
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"objc_login"]=^(){
        NSLog(@"objc_login....");
        
        NSArray *args=[JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"argument : %@",jsVal.toString);
        }
        JSValue *thiz=[JSContext currentThis];
        
        NSLog(@"end....%@",thiz);
        
        [self asynlogin:[args[0] toString] withPass:[args[1] toString]];
    };
}
-(void)asynlogin:(NSString *)name withPass:(NSString *)pass{
    //hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.labelText=@"登录中...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isOK=[[ElApiService shareElApiService] loginByUsername:name andPassword:[WsqMD5Util getmd5WithString:pass]];
         dispatch_async(dispatch_get_main_queue(), ^{
            //[hud hide:YES];
            
             [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loginIsOk(%d)",isOK]];
            
        });
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
