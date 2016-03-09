//
//  XMPPManager.h
//  myXmpp
//
//  Created by ccyy on 15/8/4.
//  Copyright (c) 2015年 ccyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
/**
 *  该类主要封装了xmpp的常用方法
 */
@interface XMPPManager : NSObject<XMPPStreamDelegate>
//通信管道，输入输出流
@property(nonatomic,strong)XMPPStream *xmppStream;
//单例方法
+(XMPPManager *)defaultManager;
//登录的方法
-(void)loginwithName:(NSString *)userName andPassword:(NSString *)password;
//注册
-(void)registerWithName:(NSString *)userName andPassword:(NSString *)password;
-(void)logout;
@end
