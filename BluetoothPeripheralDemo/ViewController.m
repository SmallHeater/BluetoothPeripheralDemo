//
//  ViewController.m
//  BluetoothPeripheralDemo
//
//  Created by xianjunwang on 2017/12/8.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define SERVICE_UUID @"CDD1"
#define CHARACTERISTIC_UUID @"CDD2"

@interface ViewController ()<CBPeripheralManagerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBMutableCharacteristic *characteristic;

@property (nonatomic,strong) UITextField * textField;
//发送
@property (nonatomic,strong) UIButton * sendBtn;
//收到的数据展示
@property (nonatomic,strong) UITextView * textView;

@end

@implementation ViewController

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.titleLabel.text = @"蓝牙外设工程";
    // 创建外设管理器，会回调peripheralManagerDidUpdateState方法
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.textView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  代理
#pragma mark  ----  CBPeripheralManagerDelegate

/** 设备的蓝牙状态
 CBManagerStateUnknown = 0,  未知
 CBManagerStateResetting,    重置中
 CBManagerStateUnsupported,  不支持
 CBManagerStateUnauthorized, 未验证
 CBManagerStatePoweredOff,   未启动
 CBManagerStatePoweredOn,    可用
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBManagerStatePoweredOn) {
        // 创建Service（服务）和Characteristics（特征）
        [self setupServiceAndCharacteristics];
        // 根据服务的UUID开始广播
        [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[[CBUUID UUIDWithString:SERVICE_UUID]]}];
    }
}

/** 创建服务和特征 */
- (void)setupServiceAndCharacteristics {
    // 创建服务
    CBUUID *serviceID = [CBUUID UUIDWithString:SERVICE_UUID];
    CBMutableService *service = [[CBMutableService alloc] initWithType:serviceID primary:YES];
    // 创建服务中的特征
    CBUUID *characteristicID = [CBUUID UUIDWithString:CHARACTERISTIC_UUID];
    CBMutableCharacteristic *characteristic = [
                                               [CBMutableCharacteristic alloc]
                                               initWithType:characteristicID
                                               properties:
                                               CBCharacteristicPropertyRead |
                                               CBCharacteristicPropertyWrite |
                                               CBCharacteristicPropertyNotify
                                               value:nil
                                               permissions:CBAttributePermissionsReadable |
                                               CBAttributePermissionsWriteable
                                               ];
    // 特征添加进服务
    service.characteristics = @[characteristic];
    // 服务加入管理
    [self.peripheralManager addService:service];
    
    // 为了手动给中心设备发送数据
    self.characteristic = characteristic;
}

/** 中心设备读取数据的时候回调 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    // 请求中的数据，这里把文本框中的数据发给中心设备
    request.value = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
    // 成功响应请求
    [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
    
    NSLog(@"中心设备读取数据");
}

/** 中心设备写入数据的时候回调 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
    // 写入数据的请求
    CBATTRequest *request = requests.lastObject;
    // 把写入的数据显示在文本框中
    NSString * receiveText = [[NSString alloc] initWithData:request.value encoding:NSUTF8StringEncoding];
    NSString * text = [[NSString alloc] initWithFormat:@"\n%@",receiveText];
    
    NSString * showText = [self.textView.text stringByAppendingString:text];
    self.textView.text = showText;
    
    NSLog(@"中心设备写入数据");
    NSString * value = [[NSString alloc] initWithFormat:@"%@已接收到",text];
    BOOL sendSuccess = [self.peripheralManager updateValue:[value dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.characteristic onSubscribedCentrals:nil];
    if (sendSuccess) {
        NSLog(@"回调发送成功");
    }else {
        NSLog(@"回调发送失败");
    }
}

/** 订阅成功回调 */
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"%s",__FUNCTION__);
}

/** 取消订阅回调 */
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark  ----  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark  ----  自定义函数
-(void)sendBtnClicked:(UIButton *)btn{
    
    BOOL sendSuccess = [self.peripheralManager updateValue:[self.textField.text dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.characteristic onSubscribedCentrals:nil];
    if (sendSuccess) {
        NSLog(@"数据发送成功");
    }else {
        NSLog(@"数据发送失败");
    }
}

#pragma mark  ----  懒加载
-(UITextField *)textField{
    
    if (!_textField) {
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, SCREENWIDTH - 90, 40)];
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.placeholder = @"输入";
        _textField.delegate = self;
    }
    return _textField;
}

-(UIButton *)sendBtn{
    
    if (!_sendBtn) {
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(CGRectGetMaxX(self.textField.frame) + 5, CGRectGetMinY(self.textField.frame), 40, 40);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
-(UITextView *)textView{
    
    if (!_textView) {
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField.frame) + 20, SCREENWIDTH - 40, 200)];
        _textView.text = @"接收到的数据：";
    }
    return _textView;
}

@end
