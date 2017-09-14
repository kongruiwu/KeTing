//
//  HotRankViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/8/7.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HotRankViewController.h"
#import "RankHeaderView.h"
#import "HotSortViewController.h"
@interface HotRankViewController ()<UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView * mainScroll;
@property (nonatomic, strong) RankHeaderView * header;


@end

@implementation HotRankViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setNavUnAlpha];
    [self checkNetStatus];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButtonWithType:BackImgTypeBlack];
    if (self.isHot) {
        [self setNavTitle:@"热门排行" color:KTColor_MainBlack];
    }else{
        [self setNavTitle:@"限免" color:KTColor_MainBlack];
    }
    [self creatUI];
}

- (void)creatUI{
    
    self.header = [[RankHeaderView alloc]initWithFrame:CGRectMake(0, 64, UI_WIDTH, Anno750(80))];
    [self.view addSubview:self.header];
    
    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Anno750(80) + 64, UI_WIDTH, UI_HEGIHT - Anno750(80) - 64)];
    self.mainScroll.contentSize = CGSizeMake(UI_WIDTH * 2, 0);
    [self.mainScroll autoresizingMask];
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    self.mainScroll.showsHorizontalScrollIndicator = NO;
    self.mainScroll.backgroundColor = KTColor_BackGround;
    self.mainScroll.delegate = self;
    [self.view addSubview:self.mainScroll];
    
    HotSortViewController * listen = [[HotSortViewController alloc]init];
    listen.isHot = self.isHot;
    listen.isBook = YES;
    listen.view.frame = CGRectMake(UI_WIDTH, 0, UI_WIDTH, UI_HEGIHT);
    [self addChildViewController:listen];
    [self.mainScroll addSubview:listen.view];
    
    HotSortViewController * voice = [[HotSortViewController alloc]init];
    voice.isHot = self.isHot;
    voice.isBook = NO;
    voice.view.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT);
    [self addChildViewController:voice];
    [self.mainScroll addSubview:voice.view];
    
    __weak HotRankViewController * weakself = self;
    [self.header.hmsgControl setIndexChangeBlock:^(NSInteger index) {
        CGPoint point = weakself.mainScroll.contentOffset;
        [UIView animateWithDuration:0.3f animations:^{
            weakself.mainScroll.contentOffset = CGPointMake(UI_WIDTH * index,point.y);
        }];
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x / UI_WIDTH;
    [self.header.hmsgControl setSelectedSegmentIndex:index animated:YES];
}
@end
