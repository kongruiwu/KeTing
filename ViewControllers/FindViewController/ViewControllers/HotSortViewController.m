//
//  HotSortViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/14.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HotSortViewController.h"
#import "HomeVoiceCell.h"
#import "ListenDetailViewController.h"
#import "VoiceDetailViewController.h"
#import "ListenListCell.h"

@interface HotSortViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray<HomeListenModel *> * dataArray;
@property (nonatomic) int page;



@end

@implementation HotSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self getData];
}
- (void)creatUI{
    self.page = 1;
    
    self.dataArray = [NSMutableArray new];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0,0, UI_WIDTH, UI_HEGIHT - 64 - Anno750(80)) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.tabview.mj_header = self.refreshHeader;
    self.tabview.mj_footer = self.refreshFooter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(30);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.isBook ? Anno750(250) : Anno750(190);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isBook) {
        static NSString * cellid = @"ListenListCell";
        ListenListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ListenListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        if (self.isHot) {
            [cell updateWithListenModel:self.dataArray[indexPath.row]];
            [cell updateWithNum:indexPath.row];
        }else{
            [cell updateWithListenModel:self.dataArray[indexPath.row]];
        }
        cell.timeLabel.hidden = YES;
        return cell;
    }
    
    static NSString * cellid = @"voiceCell";
    HomeVoiceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[HomeVoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (self.isHot) {
        [cell updateWithVoiceModel:self.dataArray[indexPath.row] andSortNum:indexPath.row];
    }else{
        [cell updateWithVoiceModel:self.dataArray[indexPath.row]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeListenModel * model = self.dataArray[indexPath.row];
    if ([model.catId integerValue] == 2) {
        ListenDetailViewController * vc = [ListenDetailViewController new];
        vc.listenID = model.listenId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([model.catId integerValue] == 3){
        VoiceDetailViewController * vc = [VoiceDetailViewController new];
        vc.voiceID = model.listenId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
- (void)getMoreData{
    self.page += 1;
    [self getData];
}
- (void)refreshData{
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self getData];
}
- (void)getData{
    NSString * pageUrl ;
    if (self.isHot) {
        pageUrl = Page_Hots;
    }else{
        pageUrl = Page_Free;
    }
    NSDictionary * dic = @{
                           @"type":self.isBook ? @"2" :@"3",
                           @"pagesize":@"10",
                           @"page":@(self.page)
                           };
    [[NetWorkManager manager] GETRequest:dic pageUrl:pageUrl complete:^(id result) {
        NSArray * arr;
        if (self.isHot) {
            arr = (NSArray * )result;
        }else{
            NSDictionary * dic = (NSDictionary *)result;
            arr = dic[@"list"];
        }
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
    } errorBlock:^(KTError *error) {
        if (self.page > 1) {
            self.page -= 1;
        }
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
}





@end
