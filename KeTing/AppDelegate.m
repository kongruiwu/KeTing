//
//  AppDelegate.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AppDelegate.h"

#import <IQKeyboardManager.h>
#import <UMSocialCore/UMSocialCore.h>
//测试
#import <AVFoundation/AVFoundation.h>
#import "AudioDownLoader.h"
#import "RootViewController.h"
#import "HistorySql.h"
#import "AudioPlayer.h"
#import "FristViewController.h"
#import <Growing.h>
#import <MLTransition.h>

@interface AppDelegate ()<AVAudioSessionDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self netNotificationCenterSetting];
    [[SqlManager manager] openDB];
    [[HistorySql sql] openDB];
    [MLTransition validatePanBackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    [Growing startWithAccountId:GrowingID];
    
    [self IQKeyBoardSetting];
    [self audioPlayerSetting];
    [self UmengSetting];
    [[UserManager manager] getUserInfo];
    [[UserManager manager] getDataModel];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Frist"]) {
        [self.window setRootViewController:[FristViewController new]];
    }else{
        [self.window setRootViewController:[RootViewController new]];
    }


    
    return YES;
}

- (void)audioPlayerSetting{
    //1 初始化苹果播放器，用到一些播放模式。
    NSError * error ;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
}
- (void)IQKeyBoardSetting{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
}
- (void)netNotificationCenterSetting{
    //1.创建网络监听管理者
    self.netManager = [AFNetworkReachabilityManager sharedManager];
    __weak AppDelegate * weakSelf = self;
    [self.netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                if ([AudioPlayer instance].audioPlayer.state == STKAudioPlayerStatePlaying ) {
                    [[AudioPlayer instance].audioPlayer pause];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络已切换，确定继续播放么？" preferredStyle:(UIAlertControllerStyleAlert)];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        [[AudioPlayer instance].audioPlayer resume];
                    }];
                    [alertController addAction:action];
                    
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:action1];
                    [[weakSelf getCurrentVC] presentViewController:alertController animated:YES completion:nil];
                }
            }
                break;
            default:
                break;
        }
    }];
    [self.netManager startMonitoring];
}
- (void)UmengSetting{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengKey];
    [WXApi registerApp:WxAppID];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WxAppID appSecret:WxAppSecret redirectURL:@"keting"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAPPID/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"keting"];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if([WXApi handleOpenURL:url delegate:self]){
        if ([self.wxDelegate respondsToSelector:@selector(loginWithResq:)]) {
            return YES;
        }
    }
    if ([Growing handleUrl:url]) // 请务必确保该函数被调用
    {
        return YES;
    }
    return NO;
}


// Umeng 分享回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([WXApi handleOpenURL:url delegate:self]) {
        if ([self.wxDelegate respondsToSelector:@selector(loginWithResq:)]) {
            return YES;
        }
    }
    
    if ([Growing handleUrl:url]) // 请务必确保该函数被调用
    {
        return YES;
    }
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (result) {
        return  YES;
    }
    return NO;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//应用进入后台之后 停止下载 已保证下载可以正常进行
- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([AudioPlayer instance].currentAudio) {
        [[HistorySql sql] updatePlayLong:@([[AudioPlayer instance] audioProgress]) withAudioID:[AudioPlayer instance].currentAudio.audioId];
    }
    [[AudioDownLoader loader] cancelDownLoading];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //当进入前台时  且开启自动下载功能时 调用
    if (self.netManager) {
        [self.netManager startMonitoring];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.netManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi && [AudioDownLoader loader].autoDownLoad) {
            [[AudioDownLoader loader] resumeDownLoading];
        }
    });
    
    
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 获取当前界面
- (UIViewController *)getCurrentVC
{
    UITabBarController *tbc = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    UINavigationController  *nvc = tbc.selectedViewController;
    UIViewController *vc = nvc.visibleViewController;
    return vc;
}
#pragma mark - 微信代理
- (void)onReq:(BaseReq *)req{

}
- (void)onResp:(BaseResp *)resp{
//接收code 继续登录
    if ([self.wxDelegate respondsToSelector:@selector(loginWithResq:)]) {
        [self.wxDelegate loginWithResq:resp];
    }

}

@end
