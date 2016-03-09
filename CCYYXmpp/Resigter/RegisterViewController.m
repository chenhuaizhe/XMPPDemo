//
//  RegisterViewController.m
//  myXmpp
//
//  Created by ccyy on 15/8/4.
//  Copyright (c) 2015年 ccyy. All rights reserved.
//

#import "RegisterViewController.h"
#import "XMPPManager.h"

@interface RegisterViewController ()<XMPPStreamDelegate>
//注册用户名
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//注册密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation RegisterViewController
#pragma mark 点击注册执行的方法
- (IBAction)register:(id)sender {
    
    [[XMPPManager defaultManager] registerWithName:self.nameTextField.text andPassword:self.passwordTextField.text];
    
}
#pragma mark 点击取消执行的方法
- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置代理
    [[XMPPManager defaultManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark 注册成功执行的方法
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
