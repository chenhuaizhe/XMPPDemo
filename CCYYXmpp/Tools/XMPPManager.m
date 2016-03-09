//
//  XMPPManager.m
//  myXmpp
//
//  Created by ccyy on 15/8/4.
//  Copyright (c) 2015年 ccyy. All rights reserved.
//

#import "XMPPManager.h"
typedef NS_ENUM(NSInteger, ConnectServerPurpose)
{
    ConnectServerPurposeLogin,    //登录
    ConnectServerPurposeRegister   //注册
};
@interface XMPPManager()
//用来记录用户输入的密码
@property(nonatomic,strong)NSString *password;
@property(nonatomic)ConnectServerPurpose connectServerPurposeType;//用来标记连接服务器目的的属性
@end

@implementation XMPPManager

#pragma mark 单例方法的实现
+(XMPPManager *)defaultManager{
    static XMPPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XMPPManager alloc]init];
    });
    return manager;
}

#pragma mark init方法重写
/**
 *  重写初始化方法是因为在manager一创建就要使用一些功能，
 *    把这些功能放在初始化方法里面
 */
-(instancetype)init{
    if ([super init]){
   //1.初始化xmppStream，登录和注册的时候都会用到它
    self.xmppStream = [[XMPPStream alloc]init];
     //设置服务器地址,这里用的是本地地址（可换成公司具体地址）
    self.xmppStream.hostName = @"127.0.0.1";
//    设置端口号
    self.xmppStream.hostPort = 5222;
//    设置代理
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

-(void)loginwithName:(NSString *)userName andPassword:(NSString *)password
{
    //标记连接服务器的目的
    self.connectServerPurposeType = ConnectServerPurposeLogin;
    //这里记录用户输入的密码，在登录（注册）的方法里面使用
    self.password = password;
    /**
     *  1.初始化一个xmppStream
        2.连接服务器（成功或者失败）
        3.成功的基础上，服务器验证（成功或者失败）
        4.成功的基础上，发送上线消息
     */
    
    
    // *  创建xmppjid（用户）
    // *  @param NSString 用户名，域名，登录服务器的方式（苹果，安卓等）
   
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:@"chenyuan" resource:@"iPhone8"];
    self.xmppStream.myJID = jid;
    //连接到服务器
    [self connectToServer];

    //有可能成功或者失败，所以有相对应的代理方法
    
}

#pragma mark xmppStream的代理方法
//连接服务器失败的方法
-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"连接服务器失败的方法，请检查网络是否正常");
}
//连接服务器成功的方法
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接服务器成功的方法");
//登录
    if (self.connectServerPurposeType == ConnectServerPurposeLogin) {
        NSError *error = nil;
//        向服务器发送密码验证 //验证可能失败或者成功
        [sender authenticateWithPassword:self.password error:&error];
//        NSLog(@"-----%@",self.password);
    }
//注册
    else{
        //向服务器发送一个密码注册（成功或者失败）
        [sender registerWithPassword:self.password error:nil];
    }
}


//验证成功的方法
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"验证成功的方法");
    /**
     *  unavailable 离线
       available  上线
       away  离开
       do not disturb 忙碌
     */
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [self.xmppStream sendElement:presence];
}
//验证失败的方法
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"验证失败的方法,请检查你的用户名或密码是否正确,%@",error);
}


#pragma mark 注册
-(void)registerWithName:(NSString *)userName andPassword:(NSString *)password{
    self.password = password;
    //0.标记连接服务器的目的
    self.connectServerPurposeType = ConnectServerPurposeRegister;
    //1. 创建一个jid
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:@"chenyuan" resource:@"iPhone8"];
    //2.将jid绑定到xmppStream
    self.xmppStream.myJID = jid;
    //3.连接到服务器
    [self connectToServer];
    
}

#pragma mark 注册成功的方法
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功的方法");
    
}
#pragma mark 注册失败的方法
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"注册失败执行的方法");
}

#pragma mark 连接到服务器的方法
-(void)connectToServer{
    //如果已经存在一个连接，需要将当前的连接断开，然后再开始新的连接
    if ([self.xmppStream isConnected]) {
        [self logout];
    }
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:30.0f error:&error];
    if (error) {
        NSLog(@"error = %@",error);
    }
}


#pragma mark 注销方法的实现
-(void)logout{
    //表示离线不可用
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
//    向服务器发送离线消息
    [self.xmppStream sendElement:presence];
    //断开链接
    [self.xmppStream disconnect];
}
@end
