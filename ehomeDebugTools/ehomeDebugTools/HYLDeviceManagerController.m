//
//  HYLDeviceManagerController.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/26.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLDeviceManagerController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "HYLRoutes.h"
@interface HYLDeviceManagerController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)switchPage:(id)sender;

@end

@implementation HYLDeviceManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    self.webView.scrollView.delegate=self;
   
    NSString *filePath=[[HYLRoutes resourceRootPath] stringByAppendingPathComponent:@"manager.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)switchPage:(id)sender {
    
}
@end
