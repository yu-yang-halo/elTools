//
//  UIViewController+Notification.h
//  ehomeDebugTools
//
//  Created by admin on 15/6/24.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UIViewKeyBoardDelegate <NSObject>

-(void)keyBoardShow;
-(void)keyBoardHide;

@end

@interface UIViewController(Notification)
@property(nonatomic,assign)  id<UIViewKeyBoardDelegate> keyboardDelegate;

//-(void)setKeyboardDelegate:(id<UIViewKeyBoardDelegate>)delegate;
//-(id<UIViewKeyBoardDelegate>)keyboardDelegate;

@end
