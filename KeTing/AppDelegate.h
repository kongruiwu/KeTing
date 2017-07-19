//
//  AppDelegate.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentViewController.h"

#import <Reachability.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) HMSegmentViewController * hmvc;

@property (nonatomic, strong) Reachability * hostReach;
@property (nonatomic, assign) NetworkStatus netStatus;
@end

