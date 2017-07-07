//
//  DownLoadViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/3.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "DownLoadViewController.h"
#import "TopHeaderView.h"
#import "DownLoadSubViewController.h"
@interface DownLoadViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UISegmentedControl * segmentbtn;
@property (nonatomic, strong) UIScrollView * mainScroll;
@property (nonatomic, strong) TopHeaderView * header;

@end

@implementation DownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
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
    [UIView animateWithDuration:0.3f animations:^{
        self.mainScroll.contentOffset = CGPointMake(UI_WIDTH * segembtn.selectedSegmentIndex, 0);
    }];
}
- (void)creatUI{
    
    self.header = [[TopHeaderView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(90))];
    [self.header updateWithImages:@[@"my_ stop",@"my_ delete"] titles:@[@"    全部暂停",@"    全部清空"]];
    [self.view addSubview:self.header];
    
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Anno750(90), UI_WIDTH,  UI_HEGIHT - 64 - Anno750(90))];
    self.mainScroll.contentSize = CGSizeMake(2 * UI_WIDTH, UI_HEGIHT -Anno750(90)- 64);
    [self.mainScroll autoresizingMask];
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    self.mainScroll.showsHorizontalScrollIndicator = NO;
    self.mainScroll.backgroundColor = KTColor_BackGround;
    self.mainScroll.delegate = self;
    [self.view addSubview:self.mainScroll];
    
    DownLoadSubViewController * leftvc = [[DownLoadSubViewController alloc]init];
    leftvc.view.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - Anno750(90) - 64);
    leftvc.isDownLoading = NO;
    [self.mainScroll addSubview:leftvc.view];
    [self addChildViewController:leftvc];
    DownLoadSubViewController * rightvc = [[DownLoadSubViewController alloc]init];
    rightvc.view.frame = CGRectMake(UI_WIDTH, 0, UI_WIDTH, UI_HEGIHT - Anno750(90) - 64);
    rightvc.isDownLoading = YES;
    [self.mainScroll addSubview:rightvc.view];
    [self addChildViewController:rightvc];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / UI_WIDTH;
    [self.segmentbtn setSelectedSegmentIndex:index];
}

@end
