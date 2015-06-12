//
//  HYLDevicesController.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLDevicesController.h"
#import "HYLResourceUtil.h"
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
    
    [HYLResourceUtil downloadWebResource:@"http://download.alipay.com/mobilecsprod/alipay.mobile/20130601021432806/xlarge/10000011.amr"  block:^(BOOL isfinished,id data) {
        
        if(isfinished){
           
            data=[data stringByAppendingPathComponent:@"www/demo/index-alipay-native.html"];
             NSLog(@"finished %@",data);
            [self.webVIew loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:data]]];
            
            
        }
        
        
    }];

    
    
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
