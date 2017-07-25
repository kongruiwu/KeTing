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
#import "LoginViewController.h"
@interface ListenListViewController ()<UITableViewDelegate,UITableViewDataSource,ListenListDelegate>
//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic) int page;
@property (nonatomic, strong) UILabel * countLabel;
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
    [self drawRightShopCar];
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
- (void)drawRightShopCar{    
    UIButton * button = [KTFactory creatButtonWithNormalImage:@"shopcar" selectImage:nil];
    button.frame = CGRectMake(0, 0, Anno750(64), Anno750(64));
    self.countLabel = [KTFactory creatLabelWithText:@"0"
                                          fontValue:font750(20)
                                          textColor:[UIColor whiteColor]
                                      textAlignment:NSTextAlignmentCenter];
    self.countLabel.backgroundColor = KTColor_IconOrange;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = Anno750(15);
    self.countLabel.hidden = YES;
    [button addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_centerX).offset(Anno750(5));
        make.bottom.equalTo(button.mas_centerY).offset(Anno750(-5));
        make.height.equalTo(@(Anno750(30)));
        make.width.equalTo(@(Anno750(30)));
    }];
    [button addTarget:self action:@selector(checkShopCar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)updateCountLabel:(NSString *)count{
    self.countLabel.text = count;
    self.countLabel.hidden = [count intValue]>0 ? NO:YES;
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
    
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_ShopCarCount complete:^(id result) {
        NSString * count = [NSString stringWithFormat:@"%@",result];
        [self updateCountLabel:count];
    } errorBlock:^(KTError *error) {
        
    }];
}
#pragma mark - listenlistcell代理 加入购物车 购买 等
- (void)buyThisBook:(UIButton *)btn{
    if (![UserManager manager].isLogin) {
        LoginViewController * vc = [LoginViewController new];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        UITableViewCell * cell = (UITableViewCell *)[btn superview];
        NSIndexPath * indexpath = [self.tabview indexPathForCell:cell];
        HomeListenModel * model = self.dataArray[indexpath.row];
        SetAccoutViewController * vc = [[SetAccoutViewController alloc]init];
        vc.isBook = YES;
        vc.money = model.PRICE;
        vc.products = @[model];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)addToShopCar:(UIButton *)btn{
    if (![UserManager manager].isLogin) {
        LoginViewController * vc = [LoginViewController new];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        UITableViewCell * cell = (UITableViewCell *)[btn superview];
        NSIndexPath * indexpath = [self.tabview indexPathForCell:cell];
        HomeListenModel * model = self.dataArray[indexpath.row];
        NSDictionary * params = @{
                                  @"userId":[UserManager manager].userid,
                                  @"relationId":model.listenId,
                                  @"relationType":@2
                                  };
        [self showLoadingCantTouchAndClear];
        [[NetWorkManager manager] POSTRequest:params pageUrl:Page_AddCar complete:^(id result) {
            [self dismissLoadingView];
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"添加成功" duration:1.0f];
            btn.selected = !btn.selected;
            int count = [self.countLabel.text intValue] + 1;
            [self updateCountLabel:[NSString stringWithFormat:@"%d",count]];
        } errorBlock:^(KTError *error) {
            [self dismissLoadingView];
        }];
    }
}
- (void)checkShopCar{
    if (![UserManager manager].isLogin) {
        LoginViewController * vc = [LoginViewController new];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        ShopCarViewController * vc = [ShopCarViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
