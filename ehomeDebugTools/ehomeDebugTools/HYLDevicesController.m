//
//  HYLDevicesController.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLDevicesController.h"
#import "HYLResourceUtil.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <ELNetworkService/ELNetworkService.h>
#import <objc/runtime.h>
#import <JSONKit/JSONKit.h>
@interface HYLDevicesController ()
@property (strong, nonatomic) IBOutlet UIWebView *webVIew;

@end

@implementation HYLDevicesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设备列表";
    // Do any additional setup after loading the view.
     NSLog(@"...viewDidLoad  %@",self.data);
    
    self.webVIew.scrollView.scrollEnabled=YES;
    NSString *htmlString=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"devices.html" ofType:@""] encoding:NSUTF8StringEncoding error:nil];
    
    [self.webVIew loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
    JSContext *context=[self.webVIew valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"mobile_requestDevices"]=^(){
      
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
           NSDictionary *deviceDic=[[ElApiService shareElApiService] getObjectListAndFieldsByUser];
            
            NSMutableArray *allDeviceObj=[NSMutableArray new];
          
           [deviceDic enumerateKeysAndObjectsUsingBlock:^(id key, ELDeviceObject* obj, BOOL *stop) {
               NSMutableDictionary *objectMap=[NSMutableDictionary new];
               unsigned int outCount ,i;
               objc_property_t *props= class_copyPropertyList([obj class],&outCount);
               for (i=0; i<outCount; i++) {
                   
                   objc_property_t prop=*(props+i);
                   NSString *propertyName=[[NSString alloc] initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
                   id propertyValue=[obj valueForKey:propertyName];
                   
                   [objectMap setValue:propertyValue forKey:propertyName];
                   
               }
               
               free(props);
               
               [allDeviceObj addObject:objectMap];
               
           }];
            
            NSLog(@"%@",[allDeviceObj JSONString]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webVIew stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_loadDevicesData(%@)",[allDeviceObj JSONString]]];
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"...%@",sender);
}


@end
