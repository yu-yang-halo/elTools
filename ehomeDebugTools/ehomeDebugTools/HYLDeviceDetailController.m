//
//  HYLDeviceDetailController.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/17.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLDeviceDetailController.h"
#import <ELNetworkService/ELNetworkService.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <JSONKit/JSONKit.h>
#import "HYLClassUtils.h"
#import "HYLContextLibary.h"
#import "HYLRoutes.h"
@interface HYLDeviceDetailController (){
   
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HYLDeviceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=self.device.name;

    
    self.keyboardDelegate=self;
    
    [self.webView.scrollView setShowsHorizontalScrollIndicator:YES];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    self.webView.scrollView.delegate=self;
    
    

    NSString *filePath=[[HYLRoutes resourceRootPath] stringByAppendingPathComponent:@"device.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

    
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    [HYLContextLibary loadHylCmd:HYLCMDTYPE_SETFIELD_VALUE toContext:context handler:^(BOOL finished, NSArray *args) {
        
    }];
    __unsafe_unretained UIViewController *vc=self;
    [HYLContextLibary loadHylCmd:HYLCMDTYPE_UPDATE_DEVICE_NAME toContext:context handler:^(BOOL finished,NSArray *args) {
       
        if(finished){
            vc.title=[args[0] toString];
        }
        
    }];
    
    
    context[@"mobile_requestDeviceInfo"]=^(){
      
        NSDictionary *deviceMap=[HYLClassUtils canConvertJSONDataFromObjectInstance:_device];
        NSLog(@"==========================");
        NSLog(@"%@",[deviceMap JSONString]);
         NSLog(@"==========================");
        NSLog(@"%@",[HYLClassUtils classListData]);
        NSLog(@"==========================");
        
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadDeviceInfoToHtml(%@,%@)",[deviceMap JSONString],[HYLClassUtils classListData]]];
        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)keyBoardShow{
   // NSLog(@"keyBoardShow...");

}
/*
 webview 中界面内容上移，最优的解决方案是使用webview调用html中的dom来解决
 
 stringByEvaluatingJavaScriptFromString(document.body.scrollTop=0);
 
 
 */
-(void)keyBoardHide{
     NSLog(@"keyBoardHide...");
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollTop=%d",0]];
    
    
    
}
@end
