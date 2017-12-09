//
//  BaseNavViewController.m
//  Home
//
//  Created by xianjunwang on 2017/10/21.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "BaseNavViewController.h"

@implementation BaseNavViewController

#pragma mark  ----  生命周期函数
-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBar];
    [self.navigationBar.backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //隐藏系统默认导航条
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark  ----  自定义函数
-(void)backBtnClicked:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  ----  懒加载
-(CustomizedNavigationBar *)navigationBar{
    
    if (!_navigationBar) {
        
        _navigationBar = [[CustomizedNavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    }
    return _navigationBar;
}

@end
