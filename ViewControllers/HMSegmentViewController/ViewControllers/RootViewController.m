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
@interface RootViewController ()

@property (nonatomic, strong) PlayListView * listView;

@end

@implementation RootViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateFootView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFootView) name:AudioReadyPlaying object:nil];
    
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

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
    [RACObserve([AVQueenManager Manager], showFoot) subscribeNext:^(NSNumber * x) {
        self.playFoot.hidden = ![x boolValue];
    }];
    [self.view addSubview:self.playFoot];
    [self.playFoot.listBtn addTarget:self action:@selector(showPlayList) forControlEvents:UIControlEventTouchUpInside];
    [self.playFoot.clearButton addTarget:self action:@selector(pushToAudioPlayViewController) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.listView = [[PlayListView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT)];
    [self.view addSubview:self.listView];
    
    self.shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) hasNav:NO];
    [self.view addSubview:self.shareView];
    
}
- (void)pushToAudioPlayViewController{
    AudioPlayerViewController * vc = [AudioPlayerViewController new];
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}
- (void)showPlayList{
    
    [self.listView show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showOrHiddenFoot{
    if ([AVQueenManager Manager].showFoot) {
        self.playFoot.hidden = !self.playFoot.hidden;
    }
    
}

- (void)updateFootView{
    [self.playFoot changePlayStatus];
}

#pragma mark - 接收方法的设置
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    [super remoteControlReceivedWithEvent:event];
    if (event.type == UIEventTypeRemoteControl) {  //判断是否为远程控制
        switch (event.subtype) {
            case  UIEventSubtypeRemoteControlPlay:
            {
                [[AVQueenManager Manager] resume];
            }
                break;
            case UIEventSubtypeRemoteControlPause:
            {
                [[AVQueenManager Manager] pause];
            }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
            {
                [[AVQueenManager Manager] playNextAudio];
            }
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
            {
                [[AVQueenManager Manager] playUpForwardAudio];
            }
                break;
            default:
                break;
        }
    }
}



@end
