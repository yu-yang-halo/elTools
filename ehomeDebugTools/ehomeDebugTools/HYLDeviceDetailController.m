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
#import "UIView+Toast.h"
#import "HYLDeviceConfigController.h"
#import "HYLCache.h"
@interface HYLDeviceDetailController (){
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation HYLDeviceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=self.device.name;
    
    
    [self.webView.scrollView setShowsHorizontalScrollIndicator:YES];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    self.webView.scrollView.delegate=self;
    
    if(_refreshHeaderView==nil){
        _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0,0-self.webView.bounds.size.height,self.webView.bounds.size.width,self.webView.bounds.size.height)];
        _refreshHeaderView.delegate=self;
        [self.webView.scrollView addSubview:_refreshHeaderView];
        
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    

    NSString *filePath=[[HYLRoutes uiResourcePath] stringByAppendingPathComponent:@"device.html"];
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

    
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    [HYLContextLibary loadHylCmd:HYLCMDTYPE_SETFIELD_VALUE toContext:context handler:^(BOOL finished, NSArray *args) {
        
        [self loadWebViewData];
        
    }];
    
//    context[@"mobile_requestDeviceInfo"]=^(){
//      
//        [self callJSMethodUpdateUI:_device];
//        
//    };
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *desVC=[segue destinationViewController];
    
    if([desVC isKindOfClass:[HYLDeviceConfigController class]]){
         NSLog(@"data: %@ ,viewController %@",sender,desVC);
        
        [(HYLDeviceConfigController *)desVC setDevice:_device];
    }
}


#pragma mark scrollviewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

-(void)callJSMethodUpdateUI:(ELDeviceObject *)eldevice{
    NSDictionary *deviceMap=[HYLClassUtils canConvertJSONDataFromObjectInstance:eldevice];
    NSLog(@"==========================");
    NSLog(@"%@",[deviceMap JSONString]);
    NSLog(@"==========================");
    NSLog(@"%@",[HYLClassUtils classListData]);
    NSLog(@"==========================");

    
    dispatch_async(dispatch_get_main_queue(), ^{
         self.title=self.device.name;
         [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadDeviceInfoToHtml(%@,%@)",[deviceMap JSONString],[HYLClassUtils classListData]]];
        
        _reloading=NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webView.scrollView];
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollTop=%d",0]];
        
    });
}

-(void)loadWebViewData{
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
       ELDeviceObject *eldevice=[[ElApiService shareElApiService] getObjectValue:self.device.objectId];
       
       if(eldevice!=nil){
            self.device=eldevice;
           [[HYLCache shareHylCache] setCurrentELDevice:eldevice];
           [self callJSMethodUpdateUI:eldevice];
       }
      
   });
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadWebViewData];
}

#pragma mark EGORefreshTableHeaderDelegate
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    _reloading=YES;
    [self loadWebViewData];
}
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return _reloading;
}
-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    return [NSDate date];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
