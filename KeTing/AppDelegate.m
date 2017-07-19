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

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[SqlManager manager] openDB];
    
    [self IQKeyBoardSetting];
    [self audioPlayerSetting];
    [self netNotificationCenterSetting];
    [self UmengSetting];
    [[UserManager manager] getUserInfo];
    [[UserManager manager] getDataModel];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.hmvc = [[HMSegmentViewController alloc]init];
    UINavigationController * rootVC = [[UINavigationController alloc]initWithRootViewController:self.hmvc];
    [self.window setRootViewController:rootVC];
    
    
    
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
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    //开始监听，会启动一个run loop
    [self.hostReach startNotifier];
}
-(void)reachabilityChanged:(NSNotification *)note

{
    
    Reachability *currReach = [note object];
    
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    
    self.netStatus = [currReach currentReachabilityStatus];
    if (self.netStatus == ReachableViaWiFi) {
        //开始下载
        
    }else{
        //暂停下载 与暂停播放
        
        
    }
//    //如果没有连接到网络就弹出提醒实况
//    
//    self.isReachable = YES;
//    
//    if(status == NotReachable)
//        
//    {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        
//        [alert show];
//        
//        [alert release];
//        
//        self.isReachable = NO;
//        
//        return;
//        
//    }
//    
//    if (status==kReachableViaWiFi||status==kReachableViaWWAN) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接信息" message:@"网络连接正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        
//        //        [alert show];
//        [alert release];
//        self.isReachable = YES;
//    }
}

- (void)UmengSetting{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengKey];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WxAppID appSecret:WxAppSecret redirectURL:@"keting"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];

}
// Umeng 分享回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//应用进入后台之后 停止下载 已保证下载可以正常进行
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[AudioDownLoader loader] cancelDownLoading];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //当进入前台时  且开启自动下载功能时 调用
    if (self.netStatus == ReachableViaWiFi && [AudioDownLoader loader].autoDownLoad) {
        [[AudioDownLoader loader] resumeDownLoading];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
