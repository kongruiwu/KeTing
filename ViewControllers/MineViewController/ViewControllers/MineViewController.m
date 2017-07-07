//
//  MineViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MineViewController.h"
#import "MineViewModel.h"
#import "MineListCell.h"
#import "MineHeader.h"
#import "UserInfoViewController.h"
#import "LoginViewController.h"
#import "MoneyViewController.h"
#import "MyShopedViewController.h"
#import "ShopCarViewController.h"
#import "HistoryViewController.h"
#import "MyLikeViewController.h"
#import "DownLoadViewController.h"
#import "MessageViewController.h"
#import "SettingViewController.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UserManagerDelegate>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) MineViewModel * viewModel;
@property (nonatomic, strong) MineHeader * header;
@property (nonatomic, strong) UIView * clearView;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, 20)];
    [self.view addSubview:clearView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UserManager manager] getUserInfo];
    [[UserManager manager] registerDelgate:self];
    [self.header updateDatas];
}
- (void)getUserInfoSucess{
    [self.header updateDatas];
    [self.tabview reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"我的" color:[UIColor whiteColor]];
    [self drawBackButtonWithType:BackImgTypeWhite];
    [self creatUI];
}
- (void)creatUI{
    self.viewModel = [[MineViewModel alloc]init];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.header = [[MineHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(440))];
    [self.header.backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.header.clearButton addTarget:self action:@selector(userInfoClick) forControlEvents:UIControlEventTouchUpInside];
    self.tabview.tableHeaderView = self.header;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = self.viewModel.dataArray[section];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(100);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(20);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"listCell";
    MineListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[MineListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSArray<MineListModel *> * datas = self.viewModel.dataArray[indexPath.section];
    [cell updateWithListModel:datas[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([UserManager manager].isLogin) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[MoneyViewController new] animated:YES];
            }else if(indexPath.row == 1){
                [self.navigationController pushViewController:[MyShopedViewController new] animated:YES];
            }else if(indexPath.row == 2){
                [self.navigationController pushViewController:[ShopCarViewController new] animated:YES];
            }
        }else if(indexPath.section == 1){
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[HistoryViewController new] animated:YES];
            }else if(indexPath.row == 1){
                [self.navigationController pushViewController:[MyLikeViewController new] animated:YES];
            }else if(indexPath.row == 2){
                [self.navigationController pushViewController:[DownLoadViewController new] animated:YES];
            }
        
        }else if(indexPath.section == 2){
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[MessageViewController new] animated:YES];
            }else if(indexPath.row == 1){
                [self.navigationController pushViewController:[SettingViewController new] animated:YES];
            }
        }
    }else{
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
        [self presentViewController:nav animated:YES completion:nil];
    }

    
    
}

- (void)userInfoClick{
    if ([UserManager manager].isLogin) {
        [self.navigationController pushViewController:[UserInfoViewController new] animated:YES];
    }else{
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
@end
