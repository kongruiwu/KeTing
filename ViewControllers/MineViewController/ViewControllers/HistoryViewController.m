//
//  HistoryViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/30.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HistoryViewController.h"
#import "TopHeaderView.h"
#import "HistoryListCell.h"
#import "HistoryModel.h"
@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TopHeaderView * header;
@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"收听历史" color:KTColor_MainBlack];
    [self creatUI];
    self.page = 1;
    [self getData];
}
- (void)creatUI{
    self.dataArray = [NSMutableArray new];
    self.header = [[TopHeaderView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(90))];
    [self.header updateWithImages:@[@"my_play",@"my_ delete"] titles:@[@"    播放全部",@"    全部清空"]];
    [self.header.downLoadBtn addTarget:self action:@selector(deleteAllHistory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.header];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, Anno750(90), UI_WIDTH, UI_HEGIHT - Anno750(90) - 64) style:UITableViewStyleGrouped];
    self.tabview.delegate =self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.tabview.mj_header = self.refreshHeader;
    self.tabview.mj_footer = self.refreshFooter;
    
}

//设置cell为可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteHistoryatIndex:indexPath.row];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tabview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(160);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(2);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(2));
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"HistoryListCell";
    HistoryListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[HistoryListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithHistoryModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)refreshData{
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self getData];
}
- (void)getMoreData{
    self.page += 1;
    [self getData];
}

- (void)getData{
    NSDictionary * params = @{
                              @"page":@(self.page),
                              @"pagesize":@"10"
                              };
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_History complete:^(id result) {
        NSArray * datas = (NSArray *)result;
        if (self.dataArray.count != 0 && datas.count< 10) {
            if (datas.count == 0) {
                self.page -= 1;
            }
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"没有更多了" duration:1.0f];
        }
        for (int i = 0; i<datas.count; i++) {
            HistoryModel * model = [[HistoryModel alloc]initWithDictionary:datas[i]];
            [self.dataArray addObject:model];
        }
        
        [self.tabview reloadData];
        [self.refreshHeader endRefreshing];
        if (datas.count<9) {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }else{
            [self.refreshFooter endRefreshing];
        }
        if (self.dataArray.count == 0 && datas.count == 0) {
            [self showNullViewWithNullViewType:NullTypeNoneListen];
        }
    } errorBlock:^(KTError *error) {
        if (self.page > 1) {
            self.page -= 1;
        }
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
}
- (void)deleteHistoryatIndex:(NSInteger)index{
    HistoryModel * model = self.dataArray[index];
    NSDictionary * params = @{
                              @"idStr":model.audioId
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_DelHistory complete:^(id result) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"删除成功" duration:1.0f];
    } errorBlock:^(KTError *error) {

    }];
}
- (void)deleteAllHistory{
    NSDictionary * params = @{};
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_DelHistory complete:^(id result) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"删除成功" duration:1.0f];
    } errorBlock:^(KTError *error) {
        
    }];
}
@end
