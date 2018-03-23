//
//  AppDelegate.m
//  ThirdSDK
//
//  Created by He on 2018/3/21.
//  Copyright © 2018年 He. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  //  [WXApi registerApp:@"wx81971c35613779b1"];//支付
    [WXApi registerApp:@"wx35c6c77293983275"];//登录
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {//支付宝
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"%@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"pay"] || [url.host isEqualToString:@"oauth"]) {//微信
        return [WXApi handleOpenURL:url delegate:self];
    }
   
    return YES;
}
//微信支付回调
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp* pp = (PayResp*)resp;
        switch (pp.errCode) {
            case WXSuccess:
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败");
                break;
        }
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp* respp = (SendAuthResp*)resp;
        switch (respp.errCode) {
            case WXSuccess://https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
                NSLog(@"登录成功,code:%@",respp.code);//将appid,secret,code拼接至上面url,获得登录信息
                break;
            
            default:
                NSLog(@"登录失败");
                break;
        }
    }
}

@end
