//
//  RootViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "RootViewController.h"
#import <ReactiveObjC.h>
#import "HMSegmentViewController.h"
#import "PlayListView.h"
#import "AudioPlayerViewController.h"
#import "LoginViewController.h"

@interface RootViewController ()

@property (nonatomic, strong) PlayListView * listView;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrHiddenFoot) name:@"CANHIDDENFOOT" object:nil];
}
- (void)creatUI{
    
    HMSegmentViewController * vc = [[HMSegmentViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    self.viewControllers = @[nav];
    self.tabBar.hidden = YES;
    
    self.playFoot = [[PlayFootView alloc]initWithFrame:CGRectMake(0, UI_HEGIHT- Anno750(100), UI_WIDTH, Anno750(100))];
    [RACObserve([AudioPlayer instance], showFoot) subscribeNext:^(NSNumber * x) {
        self.playFoot.hidden = ![x boolValue];
    }];
    [self.view addSubview:self.playFoot];
    [self.playFoot.listBtn addTarget:self action:@selector(showPlayList) forControlEvents:UIControlEventTouchUpInside];
    [self.playFoot.clearButton addTarget:self action:@selector(pushToAudioPlayViewController) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.listView = [[PlayListView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT)];
    [self.view addSubview:self.listView];
    
    self.shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) hasNav:NO];
    [self.view addSubview:self.shareView];
    
    self.loginView = [[LoginMessageView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT)];
    [self.loginView.loginBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.deviceBtn addTarget:self action:@selector(dismissLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginView];
    
}
- (void)userLogin{
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
    [self presentViewController:nav animated:YES completion:nil];
    [self.loginView dismiss];
}

- (void)pushToAudioPlayViewController{
    AudioPlayerViewController * vc = [AudioPlayerViewController new];
    vc.isFromRoot = YES;
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}
- (void)showPlayList{
    [self.listView show];
}
- (void)dismissLogin{
    [self.loginView dismiss];
    if (self.deviceclick) {
        self.deviceclick();
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showOrHiddenFoot{
    if ([AudioPlayer instance].showFoot) {
        self.playFoot.hidden = !self.playFoot.hidden;
    }
    
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
