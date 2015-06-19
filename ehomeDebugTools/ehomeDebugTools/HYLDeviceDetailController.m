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
@interface HYLDeviceDetailController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HYLDeviceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=self.device.name;
    
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    
    NSString *htmlString=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"device.html" ofType:@""] encoding:NSUTF8StringEncoding error:nil];
    
    [self.webView loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
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


@end
