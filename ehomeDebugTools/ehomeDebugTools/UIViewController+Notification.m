//
//  UIViewController+Notification.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/24.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "UIViewController+Notification.h"
#import <objc/runtime.h>
#import <ELNetworkService/ELNetworkService.h>
#import <UIView+Toast.h>
@implementation UIViewController (Notification)

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorWithELAPIService:) name:kErrorAlertNotification object:nil];
    
}


-(void)errorWithELAPIService:(NSNotification *)notification{
    NSString *errorMsg=[notification.userInfo objectForKey:kErrorCodeKey];
    NSLog(@"Error message :%@",errorMsg);
    [self.view makeToast:errorMsg];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kErrorAlertNotification object:nil];
    
    
}


-(void)setKeyboardDelegate:(id<UIViewKeyBoardDelegate>)delegate{
    objc_setAssociatedObject(self,@selector(keyboardDelegate), delegate, OBJC_ASSOCIATION_ASSIGN);
    
}
-(id<UIViewKeyBoardDelegate>)keyboardDelegate{
    return objc_getAssociatedObject(self, @selector(keyboardDelegate));
}

-(void)keyboardWillShow:(NSNotification *)notification{
    
    [self.keyboardDelegate keyBoardShow];
    
}
-(void)keyboardWillHide:(NSNotification *)notification{
    [self.keyboardDelegate keyBoardHide];
}

@end
