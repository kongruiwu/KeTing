//
//  ListenListViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ListenListViewController.h"
#import "HomeListenModel.h"
#import "ListenListCell.h"
#import "ListenDetailViewController.h"
#import "ShopCarViewController.h"
#import "SetAccoutViewController.h"
@interface ListenListViewController ()<UITableViewDelegate,UITableViewDataSource,ListenListDelegate>
//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic) int page;
@end

@implementation ListenListViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavUnAlpha];
    [self refreshData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"听书" color:KTColor_MainBlack];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self creatUI];
}
- (void)creatUI{
    self.page = 1;
    self.dataArray = [NSMutableArray new];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64) style:UITableViewStylePlain];
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
    return Anno750(250);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"ListenListCell";
    ListenListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ListenListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithListenModel:self.dataArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeListenModel * model = self.dataArray[indexPath.row];
    ListenDetailViewController * vc = [ListenDetailViewController new];
    vc.listenID = model.listenId;
    [self.navigationController pushViewController:vc animated:YES];
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
    NSDictionary * dic = @{
                           @"pagesize":@"10",
                           @"page":@(self.page)
                           };
    [[NetWorkManager manager] GETRequest:dic pageUrl:Page_ListenList complete:^(id result) {
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
    } errorBlock:^(KTError *error) {
        if (self.page > 1) {
            self.page -= 1;
        }
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
}
#pragma mark - listenlistcell代理 加入购物车 购买 等
- (void)buyThisBook:(UIButton *)btn{
    
    UITableViewCell * cell = (UITableViewCell *)[btn superview];
    NSIndexPath * indexpath = [self.tabview indexPathForCell:cell];
    HomeListenModel * model = self.dataArray[indexpath.row];
    SetAccoutViewController * vc = [[SetAccoutViewController alloc]init];
    vc.isBook = YES;
    vc.money = model.PRICE;
    vc.products = @[model];
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)addToShopCar:(UIButton *)btn{
    UITableViewCell * cell = (UITableViewCell *)[btn superview];
    NSIndexPath * indexpath = [self.tabview indexPathForCell:cell];
    HomeListenModel * model = self.dataArray[indexpath.row];
    NSDictionary * params = @{
                              @"userId":[UserManager manager].userid,
                              @"relationId":model.listenId,
                              @"relationType":@2
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_AddCar complete:^(id result) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"添加成功" duration:1.0f];
        btn.selected = !btn.selected;
    } errorBlock:^(KTError *error) {
        
    }];
}
- (void)checkShopCar{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    ShopCarViewController * vc = [ShopCarViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
