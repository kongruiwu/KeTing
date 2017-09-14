//
//  VoiceListViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "VoiceListViewController.h"
#import "HomeVoiceCell.h"
#import "HomeListenModel.h"
#import "VoiceDetailViewController.h"
@interface VoiceListViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic) int page;
@end

@implementation VoiceListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [self checkNetStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"声度" color:KTColor_MainBlack];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self creatUI];
    [self refreshData];
}

- (void)creatUI{
    self.page = 1;
    self.dataArray = [NSMutableArray new];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 64, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.tabview.mj_header = self.refreshHeader;
    self.tabview.mj_footer = self.refreshFooter;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(190);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"cellid";
    HomeVoiceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[HomeVoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.updateTime.hidden = NO;
    [cell updateWithVoiceModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeListenModel * model = self.dataArray[indexPath.row];
    VoiceDetailViewController * vc = [VoiceDetailViewController new];
    vc.voiceID = model.listenId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getMoreData{
    [self showLoadingCantTouchAndClear];
    self.page += 1;
    [self getData];
}
- (void)refreshData{
    [self showLoadingCantTouchAndClear];
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self getData];
}
- (void)getData{
    NSDictionary * dic = @{
                           @"pagesize":@"10",
                           @"page":@(self.page)
                           };
    [[NetWorkManager manager] GETRequest:dic pageUrl:Page_VoiceList complete:^(id result) {
        NSArray * arr = (NSArray * )result;
        if (self.dataArray.count != 0 && arr.count< 10) {
            if (arr.count == 0) {
                self.page -= 1;
            }
        }
        for (int i = 0; i<arr.count; i++) {
            HomeListenModel * model = [[HomeListenModel alloc]initWithDictionary:arr[i]];
            [self.dataArray addObject:model];
        }
        [self.tabview reloadData];
        [self.refreshHeader endRefreshing];
        if (arr.count<10) {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }else{
            [self.refreshFooter endRefreshing];
        }
        [self hiddenNullView];
        [self dismissLoadingView];
    } errorBlock:^(KTError *error) {
        if (self.page > 1) {
            self.page -= 1;
        }
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        [self dismissLoadingView];
        [self showNullViewWithNullViewType:NullTypeNetError];
    }];
}

@end
