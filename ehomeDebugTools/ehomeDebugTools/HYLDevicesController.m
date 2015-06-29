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
@interface HYLDevicesController ()
@property (strong, nonatomic) IBOutlet UIWebView *webVIew;
@property (nonatomic,retain) NSDictionary *deviceDic;

@end

@implementation HYLDevicesController
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear..........");
    //获取web数据
    [_webVIew stringByEvaluatingJavaScriptFromString:@"hyl_requestDevicesCmd()"];
    
}
-(void)toDeviceManager{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设备列表";

    
    [self.webVIew.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webVIew.scrollView setShowsVerticalScrollIndicator:NO];
    
    self.webVIew.delegate=self;
    
    NSString *htmlString=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"devices.html" ofType:@""] encoding:NSUTF8StringEncoding error:nil];
    
    [self.webVIew loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
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
            
           [self.deviceDic enumerateKeysAndObjectsUsingBlock:^(id key, ELDeviceObject* obj, BOOL *stop) {
               
               ELClassObject *classObj=[HYLClassUtils classObjectFromCache:obj.classId];
               
               
               
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
           NSLog(@"%@",[allClassObjs JSONString]);
            [HYLClassUtils cacheClasslistData:[allClassObjs JSONString]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webVIew stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_loadDevicesData(%@,%@)",[allDeviceObj JSONString],[allClassObjs JSONString]]];
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

- (void)webViewDidStartLoad:(UIWebView *)webView{
   
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webVIew stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webVIew stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
}


@end
