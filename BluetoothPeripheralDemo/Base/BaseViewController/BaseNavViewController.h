//
//  BaseNavViewController.h
//  Home
//
//  Created by xianjunwang on 2017/10/21.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//  带导航的base页面

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomizedNavigationBar.h"



@interface BaseNavViewController : BaseViewController
@property (nonatomic,strong) CustomizedNavigationBar * navigationBar;

//返回按钮的响应
-(void)backBtnClicked:(UIButton *)btn;
@end
