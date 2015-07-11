//
//  LaunchViewController.m
//  ehomeDebugTools
//
//  Created by admin on 15/7/6.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "LaunchViewController.h"
#import "HYLRoutes.h"
@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UIImage *image=[UIImage imageNamed:@"launchLogo"];
    
    UIImage *launchImage=[[UIImage alloc] initWithContentsOfFile:[[HYLRoutes uiResourcePath] stringByAppendingPathComponent:@"img/launchLogo.png"]];
    
    if(launchImage==nil){
        launchImage=[UIImage imageNamed:@"launchLogo"];
    }
    
    self.view.layer.contents=(__bridge id)launchImage.CGImage;
    self.view.layer.contentsScale=launchImage.scale;
    self.view.layer.contentsGravity=kCAGravityResizeAspectFill;
    
    
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(poplaunchImage) userInfo:nil repeats:NO];
    
}
-(void)poplaunchImage{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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

@end
