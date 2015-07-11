//
//  HYLDevicesController.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLDevicesController.h"
#import "HYLResourceUtil.h"
#import "HYLDeviceDetailController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <ELNetworkService/ELNetworkService.h>
#import "HYLClassUtils.h"
#import <objc/runtime.h>
#import <JSONKit/JSONKit.h>
#import "HYLCache.h"
#import "HYLContextLibary.h"
#import "HYLRoutes.h"
#import "HYLReachabilityUtils.h"
#import <UIView+Toast.h>
@interface HYLDevicesController (){
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@property (strong, nonatomic) IBOutlet UIWebView *webVIew;
@property (nonatomic,retain) NSDictionary *deviceDic;

@end

@implementation HYLDevicesController
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear..........");
    //获取web数据
    [self loadWebViewData];
    
}
-(void)toDeviceManager{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=[[[HYLCache shareHylCache].configJSON valueForKey:@"title"] valueForKey:@"devices"];

    
    [self.webVIew.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webVIew.scrollView setShowsVerticalScrollIndicator:NO];
    
    //self.webVIew.delegate=self;
    self.webVIew.scrollView.delegate=self;
    
    if(_refreshHeaderView==nil){
        _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0,0-self.webVIew.bounds.size.height,self.webVIew.bounds.size.width,self.webVIew.bounds.size.height)];
        _refreshHeaderView.delegate=self;
        [self.webVIew.scrollView addSubview:_refreshHeaderView];
      
        
        
        
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
    NSString *filePath=[[HYLRoutes uiResourcePath] stringByAppendingPathComponent:@"devices.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webVIew loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    
    JSContext *context=[self.webVIew valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"mobile_toDetailPage"]=^(){
        NSArray *args=[JSContext currentArguments];
        
        NSLog(@"%@",[args[0] toString]);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            ELDeviceObject *device=[[ElApiService shareElApiService] getObjectValue:[[args[0] toString] integerValue]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[HYLCache shareHylCache] setCurrentELDevice:device];
                [self performSegueWithIdentifier:@"deviceDetail" sender:device];

            });
        });
        
        
    };
    [HYLContextLibary loadHylCmd:HYLCMDTYPE_SETFIELD_VALUE toContext:context handler:^(BOOL finished, NSArray *args) {
        
    }];
    
    
    context[@"mobile_requestDevices"]=^(){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
           self.deviceDic=[[ElApiService shareElApiService] getObjectListAndFieldsByUser];
           //搜集对象object json数据
           NSMutableArray *allDeviceObj=[NSMutableArray new];
           //搜集类型class json数据  {classId：[fields{}] }
           NSMutableDictionary *allClassObjs=[NSMutableDictionary new];
            //搜集class icon
            NSMutableDictionary *classIcon=[NSMutableDictionary new];
            
            
           [self.deviceDic enumerateKeysAndObjectsUsingBlock:^(id key, ELDeviceObject* obj, BOOL *stop) {
               
               ELClassObject *classObj=[HYLClassUtils classObjectFromCache:obj.classId];
               
               if(classObj.icon!=nil){
                  
               }
               [classIcon setValue:classObj.icon forKey:[NSString stringWithFormat:@"%ld",classObj.classId]];
               
               
               NSMutableDictionary *objectMap=[HYLClassUtils canConvertJSONDataFromObjectInstance:obj];
               
               
               
               NSMutableArray *fields=[NSMutableArray new];
               
               for (ELClassField *classField in classObj.classFields){
                   [fields addObject:[HYLClassUtils canConvertJSONDataFromObjectInstance:classField]];
                   
                   
               }
              
               [allClassObjs setValue:fields forKey:[NSString stringWithFormat:@"%ld",(long)obj.classId]];
              
              
               
               [allDeviceObj addObject:objectMap];
               
           }];
            
           NSLog(@"%@",[allDeviceObj JSONString]);
           NSLog(@"=====================");
          // NSLog(@"%@",[allClassObjs JSONString]);
             NSLog(@"%@",[classIcon JSONString]);
            
            [HYLClassUtils cacheClasslistData:[allClassObjs JSONString]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(![HYLReachabilityUtils networkIsAvailable]){
                    [self.view makeToast:@"当前没有可用的网络~"];
                }else{
                    
                    [self.webVIew stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_loadDevicesData(%@,%@,%@)",[allDeviceObj JSONString],[allClassObjs JSONString],[classIcon JSONString]]];
                   
                }
                _reloading=NO;
                [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webVIew.scrollView];
               
            });
        });
        
        
    };
    
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *desVC=[segue destinationViewController];
    
    if([desVC isKindOfClass:[HYLDeviceDetailController class]]){
         NSLog(@"data: %@ ,viewController %@",sender,desVC);
        
        [(HYLDeviceDetailController *)desVC setDevice:sender];
    }
   
}
#pragma mark delegate
//
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    _reloading=YES;
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    
//    _reloading=NO;
//    
//    [_webVIew stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollTop=%d",0]];
//    
//}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    NSLog(@"%@",[error description]);
//    _reloading=NO;
//    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webVIew.scrollView];
//}

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
-(void)loadWebViewData{
     [_webVIew stringByEvaluatingJavaScriptFromString:@"hyl_requestDevicesCmd()"];
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

@end
