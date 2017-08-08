//
//  AppDelegate.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <WXApi.h>
@protocol WXLoingDelegate <NSObject>

@optional
- (void)loginWithResq:(BaseResp *)resp;
- (void)bindAccouht:(BaseResp *)resp;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) AFNetworkReachabilityManager * netManager;
@property (nonatomic, assign) id<WXLoingDelegate> wxDelegate;
@end

