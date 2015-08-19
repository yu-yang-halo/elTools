//
//  ViewController.h
//  ehomeDebugTools
//
//  Created by admin on 15/5/4.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
extern const NSString *kloginUserName;
@interface ViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

