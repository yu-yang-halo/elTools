//
//  HYLDeviceDetailController.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/17.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLDeviceDetailController.h"
#import <ELNetworkService/ELNetworkService.h>
@interface HYLDeviceDetailController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HYLDeviceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=self.device.name;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
