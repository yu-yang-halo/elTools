//
//  HYLDeviceDetailController.h
//  ehomeDebugTools
//
//  Created by admin on 15/6/17.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Notification.h"

@class ELDeviceObject;
@interface HYLDeviceDetailController : UIViewController<UIScrollViewDelegate,UIViewKeyBoardDelegate>
@property(nonatomic,retain) ELDeviceObject *device;
@end
