//
//  HYLSysConfigViewController.m
//  ehomeDebugTools
//
//  Created by admin on 15/7/9.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLSysConfigViewController.h"
#import <ELNetworkService/ELNetworkService.h>
#import "RegUtil.h"
#import <UIView+Toast.h>
#import "HYLRoutes.h"
#import "UINavigationController+barTheme.h"
#import "HYLVersionInfoUtils.h"

NSString *const key_storeIPAddress=@"ip_address_store_key";

@interface HYLSysConfigViewController ()
@property (strong, nonatomic) IBOutlet UITextField *serverAddressTextField;
@property (strong, nonatomic) IBOutlet UILabel *mineResourceStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *sysVersionLabel;

@property (strong, nonatomic) IBOutlet UILabel *systemResouceStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *sysBuildVersionLabel;
- (IBAction)manualUpdateMineResource:(id)sender;
- (IBAction)reset:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation HYLSysConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo) name:kNotificationUpdateUI object:nil];
    
    
    _serverAddressTextField.delegate=self;
    
    _serverAddressTextField.text=[ElApiService currentIPAddress];
    
    _sysVersionLabel.text=[HYLVersionInfoUtils appVersion];
    _sysBuildVersionLabel.text=[HYLVersionInfoUtils appBuildVersion];
    
    
    [self updateInfo];
   
    
}
-(void)updateInfo{
    if([HYLRoutes isSystemResouces]){
        _systemResouceStatusLabel.text=@"正在使用";
        _mineResourceStatusLabel.text=@"未使用";
        [_resetBtn setEnabled:NO];
    }else{
        _systemResouceStatusLabel.text=@"未使用";
        _mineResourceStatusLabel.text=@"正在使用";
        [_resetBtn setEnabled:YES];
    }
}


- (IBAction)manualUpdateMineResource:(id)sender {
    [HYLRoutes enableDownload];
}

- (IBAction)reset:(id)sender {
    [HYLRoutes resetToSystemResource];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateUI object:nil];
     [[[UIApplication sharedApplication] keyWindow] makeToast:@"已还原"];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUpdateUI object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField;{
    NSString* ipAddr=textField.text;
    if([RegUtil isIPAddress:ipAddr]){
        //NSLog(@"是IP地址  %@",ipAddr);
        
        [[NSUserDefaults standardUserDefaults] setObject:ipAddr forKey:key_storeIPAddress];
        
        
        [ElApiService setCurrentIPAddress:ipAddr];
    }else{
        [[[UIApplication sharedApplication] keyWindow] makeToast:[NSString stringWithFormat:@"不是IP地址  %@",ipAddr]];;
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
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


@end
