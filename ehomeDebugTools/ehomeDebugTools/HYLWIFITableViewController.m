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
@interface HYLWIFITableViewController ()
- (IBAction)toSystemSetting:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *willConntectWifiSSID;
@property (strong, nonatomic) IBOutlet UITextField *willConnectWifiPassword;
- (IBAction)configWillConnectWifi:(id)sender;
- (IBAction)configServer:(id)sender;
- (IBAction)wifiInfoQuery:(id)sender;

@end

@implementation HYLWIFITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.willConntectWifiSSID.delegate=self;
    self.willConnectWifiPassword.delegate=self;
    
    self.willConntectWifiSSID.text=[HYLCache shareHylCache].availableWIFISSID;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)toSystemSetting:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
    
//    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//    }else{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
//    }
    
}
- (IBAction)configWillConnectWifi:(id)sender {
    //[HYLWifiUtils fetchSSIDInfo];
    
    NSString *ssid=self.willConntectWifiSSID.text;
    NSString *password=self.willConnectWifiPassword.text;
    
    NSLog(@"ssid :%@ ,password :%@ ",ssid,password);
    
    [HYLWifiUtils reqConfigWifiSSID:ssid password:password];
}

- (IBAction)configServer:(id)sender {
    [HYLWifiUtils reqConfigServer];
}

- (IBAction)wifiInfoQuery:(id)sender {
     [HYLWifiUtils reqWIFIInformation];
}
@end
