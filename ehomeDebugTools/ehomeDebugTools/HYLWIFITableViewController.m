//
//  HYLWIFITableViewController.m
//  ehomeDebugTools
//
//  Created by admin on 15/7/8.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLWIFITableViewController.h"
#import "HYLWifiUtils.h"
#import "HYLCache.h"
#import "HYLReachabilityUtils.h"
#import "RegUtil.h"
#import <UIView+Toast.h>
NSString *const kNotificationWIFIPageLogic=@"kNotificationWIFIPageLogic";
@interface HYLWIFITableViewController ()
- (IBAction)toSystemSetting:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *willConntectWifiSSID;
@property (strong, nonatomic) IBOutlet UITextField *willConnectWifiPassword;
- (IBAction)configWillConnectWifi:(id)sender;


@end

@implementation HYLWIFITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiPageLogic) name:kNotificationWIFIPageLogic object:nil];
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.willConntectWifiSSID.delegate=self;
    self.willConnectWifiPassword.delegate=self;
    
    self.willConntectWifiSSID.text=[HYLCache shareHylCache].availableWIFISSID;
   
    [self hideItemsYN:YES];
    
}
-(void)wifiPageLogic{
    
    if(![[HYLCache shareHylCache].availableWIFISSID isEqual:[HYLWifiUtils fetchSSIDInfo]]){
        self.willConntectWifiSSID.text=[HYLCache shareHylCache].availableWIFISSID;
        [self hideItemsYN:NO];
    }else{
        [self hideItemsYN:YES];
    }
    
}

-(void)hideItemsYN:(BOOL)isYN{
    
    for (int i=1;i<=3;i++) {
         [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]] setHidden:isYN];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWIFIPageLogic object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toSystemSetting:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    
}
- (IBAction)configWillConnectWifi:(id)sender {
    //[HYLWifiUtils fetchSSIDInfo];
    
    NSString *ssid=self.willConntectWifiSSID.text;
    NSString *password=self.willConnectWifiPassword.text;
    
    NSLog(@"ssid :%@ ,password :%@ ",ssid,password);
    if([RegUtil isEmpty:ssid]||[RegUtil isEmpty:password]){
        [[[UIApplication sharedApplication] keyWindow] makeToast:@"wifi名称与密码不能为空"];
        
    }else{
       [HYLWifiUtils reqConfigWifiSSID:ssid password:password];
    }
}

- (IBAction)configServer:(id)sender {
    [HYLWifiUtils reqConfigServer];
}

- (IBAction)wifiInfoQuery:(id)sender {
     [HYLWifiUtils reqWIFIInformation];
}
@end
