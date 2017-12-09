//
//  CustomizedNavigationBar.m
//  Home
//
//  Created by xianjunwang on 2017/10/21.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "CustomizedNavigationBar.h"



@implementation CustomizedNavigationBar

#pragma mark  ----  生命周期函数

-(instancetype)init{
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    if (self) {
        
        self.backgroundColor = [UIColor greenColor];
        [self addSubview:self.backBtn];
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor greenColor];
        [self addSubview:self.backBtn];
        [self addSubview:self.titleLabel];
    }
    return self;
}


#pragma mark  ----  懒加载
-(UIButton *)backBtn{
    
    if (!_backBtn) {
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"HomeSource.bundle/back.tiff"] forState:UIControlStateNormal];
        _backBtn.frame = CGRectMake(10, 20, 44, 44);
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(13.5, 0, 13.5, 26)];
    }
    return _backBtn;
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, SCREENWIDTH - 160, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
