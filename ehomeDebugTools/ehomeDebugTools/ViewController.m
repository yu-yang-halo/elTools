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
    hud.labelText=@"加载中。。。";
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
    static int count=0;
    context[@"sayHello"]=^(){
        NSLog(@"begin....");
        
        NSArray *args=[JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"argument : %@",jsVal);
        }
        JSValue *thiz=[JSContext currentThis];
        
        NSLog(@"end....%@",thiz);
        count++;
        
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"addWebData(%d)",count]];
        
        
        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
