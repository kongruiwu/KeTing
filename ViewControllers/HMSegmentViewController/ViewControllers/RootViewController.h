//
//  RootViewController.h
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayFootView.h"
#import "ShareView.h"
#import "LoginMessageView.h"

typedef void(^deviceClick)();

@interface RootViewController : UITabBarController

@property (nonatomic, strong) PlayFootView * playFoot;

@property (nonatomic, strong) ShareView * shareView;

@property (nonatomic, strong) LoginMessageView * loginView;
@property (nonatomic,copy) deviceClick deviceclick;
@end
