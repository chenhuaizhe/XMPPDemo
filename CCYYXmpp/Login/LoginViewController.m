
//
//  LoginViewController.m
//  myXmpp
//
//  Created by ccyy on 15/8/4.
//  Copyright (c) 2015年 ccyy. All rights reserved.
//

#import "LoginViewController.h"
#import "XMPPManager.h"
#import "RosterViewController.h"

@interface LoginViewController ()<XMPPStreamDelegate>
//用户名
@property (weak, nonatomic) IBOutlet UITextField *usernameTf;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;

@end

@implementation LoginViewController
//点击登陆执行的方法
- (IBAction)loginAction:(id)sender {
    NSLog(@"点击登陆了");
    if (self.usernameTf.text.length==0 || self.passwordTf.text.length==0) {
        NSLog(@"用户名和密码不能为空");
    }
    [[XMPPManager defaultManager]loginwithName:self.usernameTf.text andPassword:self.passwordTf.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置代理
    [[XMPPManager defaultManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
#pragma mark 验证成功的方法
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    RosterViewController *rvc = [[RosterViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
    
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
