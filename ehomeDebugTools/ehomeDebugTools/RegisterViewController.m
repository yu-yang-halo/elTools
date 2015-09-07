//
//  RegisterViewController.m
//  ehomeDebugTools
//
//  Created by admin on 15/9/6.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "RegisterViewController.h"
#import <ELNetworkService/ELNetworkService.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "HYLRoutes.h"
#import "RegUtil.h"
#import <Toast/UIView+Toast.h>
@interface RegisterViewController (){
     MBProgressHUD *hud;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadHtmlContent];
}


-(void)loadHtmlContent{
    
    self.webView.delegate=self;
    self.webView.scrollView.scrollEnabled=NO;
    
    [self requestIndexHtml];
    
    
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"mobile_registerUserInfo"]=^(){
       
        NSArray *arguments=[JSContext currentArguments];
        NSString *username=[arguments[0] toString];
        NSString *password=[arguments[1] toString];
        NSString *repassword=[arguments[2] toString];
        NSString *email=[arguments[3] toString];
        NSString *telephone=[arguments[4] toString];
        NSString *realname=[arguments[5] toString];
        
        
        
        NSString *errorMsg=nil;
        
        if([@"" isEqualToString:[RegUtil trim:username]]){
            errorMsg=@"用户名不能为空";
        }else if(![password isEqualToString:repassword]){
            errorMsg=@"两次输入密码不一致";
        }else if(![RegUtil isEmail:email]){
            errorMsg=@"邮箱格式不正确";
        }else if(![RegUtil isMobileNumber:telephone]){
            errorMsg=@"手机格式不正确";
        }else{
            [self registerUser:username password:password email:email phone:telephone realname:realname];
        }
        
        if(errorMsg!=nil){
            [[[UIApplication sharedApplication] keyWindow] makeToast:errorMsg];
        }

    };
    
    
}
-(void)registerUser:(NSString *)username password:(NSString *)password email:(NSString *)email phone:(NSString *)telephone realname:(NSString *)realname{
    
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        
        BOOL isAddSuccess=[[ElApiService shareElApiService] createUser:username password:password email:email];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *errorMsg=nil;
            if(isAddSuccess){
                errorMsg=@"注册成功";
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                errorMsg=@"注册失败";
            }
            [[[UIApplication sharedApplication] keyWindow] makeToast:errorMsg];
        }];
    }];
    
    //[[NSOperationQueue currentQueue] cancelAllOperations];
    
    
    
}

-(void)requestIndexHtml{
    NSString *filePath=[[HYLRoutes uiResourcePath] stringByAppendingPathComponent:@"register.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
