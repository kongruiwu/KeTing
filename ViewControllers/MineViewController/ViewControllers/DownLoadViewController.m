//
//  DownLoadViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "DownLoadViewController.h"
#import "DownLoadSubViewController.h"
#import "WaitDownLoadViewController.h"
#import "AudioDownLoader.h"
@interface DownLoadViewController ()<UIScrollViewDelegate,AudioDownLoadDelegate>

@property (nonatomic, strong) UISegmentedControl * segmentbtn;
@property (nonatomic, strong) UIScrollView * mainScroll;
@property (nonatomic, strong) DownLoadSubViewController * leftvc;
@property (nonatomic, strong) WaitDownLoadViewController * rightvc;
@end

@implementation DownLoadViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AudioDownLoader loader].delegate = nil;
    [self setNavUnAlpha];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AudioDownLoader loader].delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self drawNavSelectView];
    [self creatUI];
}
- (void)drawNavSelectView{
    self.segmentbtn = [[UISegmentedControl alloc]initWithItems:@[@"已下载",@"下载中"]];
    self.segmentbtn.frame = CGRectMake(0, 0, Anno750(360), Anno750(60));
    self.segmentbtn.backgroundColor = [UIColor whiteColor];
    self.segmentbtn.layer.borderColor = KTColor_MainOrange.CGColor;
    self.segmentbtn.layer.cornerRadius = 5.0f;
    self.segmentbtn.tintColor = KTColor_MainOrange;
    [self.segmentbtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    [self.segmentbtn setTitleTextAttributes:@{NSForegroundColorAttributeName:KTColor_MainOrange} forState:UIControlStateNormal];
    self.segmentbtn.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segmentbtn;
    [self.segmentbtn addTarget:self action:@selector(navSelectBtnChoose:) forControlEvents:UIControlEventValueChanged];
}
- (void)navSelectBtnChoose:(UISegmentedControl *)segembtn{
    if (segembtn.selectedSegmentIndex == 0) {
        [self.leftvc getData];
    }else{
        [self.rightvc getData];
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.mainScroll.contentOffset = CGPointMake(UI_WIDTH * segembtn.selectedSegmentIndex, 0);
    }];
}
- (void)creatUI{
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH,  UI_HEGIHT - 64)];
    self.mainScroll.contentSize = CGSizeMake(2 * UI_WIDTH, UI_HEGIHT -Anno750(90)- 64);
    [self.mainScroll autoresizingMask];
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    self.mainScroll.showsHorizontalScrollIndicator = NO;
    self.mainScroll.backgroundColor = KTColor_BackGround;
    self.mainScroll.delegate = self;
    [self.view addSubview:self.mainScroll];
    
    self.leftvc = [[DownLoadSubViewController alloc]init];
    self.leftvc.view.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64);
    [self.mainScroll addSubview:self.leftvc.view];
    [self addChildViewController:self.leftvc];
    self.rightvc = [[WaitDownLoadViewController alloc]init];
    self.rightvc.view.frame = CGRectMake(UI_WIDTH, 0, UI_WIDTH, UI_HEGIHT - 64);
    [self.mainScroll addSubview:self.rightvc.view];
    [self addChildViewController:self.rightvc];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / UI_WIDTH;
    [self.segmentbtn setSelectedSegmentIndex:index];
    if (index == 0) {
        [self.leftvc getData];
    }else{
        [self.rightvc getData];
    }
}
- (void)audioDownLoadOver{
    int index = self.mainScroll.contentOffset.x / UI_WIDTH;
    if (index == 0) {
        [self.leftvc refreshData];
    }else{
        [self.rightvc refreshData];
    }
}
@end
