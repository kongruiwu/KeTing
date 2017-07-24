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

//@property (nonatomic, strong) UITableView * tabview;
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
    [self getMessageCount];
    [self getUserBalance];
    [self getShopCarCount];
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
    if(indexPath.section == 1 && indexPath.row == 2){
        [self.navigationController pushViewController:[DownLoadViewController new] animated:YES];
    }else if(indexPath.section == 2 && indexPath.row == 1){
        [self.navigationController pushViewController:[SettingViewController new] animated:YES];
    }else if ([UserManager manager].isLogin) {
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
            }
        }else if(indexPath.section == 2){
            if (indexPath.row == 0) {
                [self readMessage];
                [self.navigationController pushViewController:[MessageViewController new] animated:YES];
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
- (void)getMessageCount{
    if (![UserManager manager].isLogin) {
        NSArray * datas = self.viewModel.dataArray[2];
        MineListModel * model = datas[0];
        model.desc = @"0";
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.tabview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_MessageCount complete:^(id result) {
        if (result[@"count"]) {
            NSArray * datas = self.viewModel.dataArray[2];
            MineListModel * model = datas[0];
            model.desc = [NSString stringWithFormat:@"%@",result[@"count"]];
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
            [self.tabview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        }
        if (result[@"list"]) {
            self.viewModel.msgStr = result[@"list"];
        }
    } errorBlock:^(KTError *error) {
        
    }];
}
- (void)readMessage{
    if (![UserManager manager].isLogin) {
        return;
    }
    if (self.viewModel.msgStr.length == 0) {
        return;
    }
    NSDictionary * params = @{
                             @"messageIdStr":self.viewModel.msgStr
                              };
    [[NetWorkManager manager] POSTRequest:params pageUrl:Page_MessageStatus complete:^(id result) {
        
    } errorBlock:^(KTError *error) {
        NSLog(@"%@",error.message);
    }];
}
- (void)getUserBalance{
    if (![UserManager manager].isLogin) {
        NSArray * datas = self.viewModel.dataArray[0];
        MineListModel * model = datas[0];
        model.desc = @"0";
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tabview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    NSDictionary * params = @{};
    [[NetWorkManager manager] GETRequest:params pageUrl:Page_UserAccount complete:^(id result) {
        NSDictionary * dic = result[@"list"];
        if (dic[@"accountBalance"]) {
            NSArray * datas = self.viewModel.dataArray[0];
            MineListModel * model = datas[0];
            [UserManager manager].balance = dic[@"accountBalance"];
            model.desc = [NSString stringWithFormat:@"¥%.2f",[[UserManager manager].balance floatValue]];
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tabview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } errorBlock:^(KTError *error) {
        
    }];
}
- (void)getShopCarCount{
    if (![UserManager manager].isLogin) {
        NSArray * datas = self.viewModel.dataArray[0];
        MineListModel * model = datas[2];
        model.desc = @"0";
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tabview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_ShopCarCount complete:^(id result) {
        if (result) {
            NSArray * datas = self.viewModel.dataArray[0];
            MineListModel * model = datas[2];
            model.desc = [NSString stringWithFormat:@"%@",result];
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.tabview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } errorBlock:^(KTError *error) {
        
    }];
}

//设置头部拉伸效果
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //图片高度
    CGFloat imageHeight = self.header.frame.size.height;
    //图片宽度
    CGFloat imageWidth = UI_WIDTH;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    
    
    //上移
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat f = totalOffset / imageHeight;
        
        self.header.groundImg.frame = CGRectMake(-(imageWidth * f - imageWidth) * 0.5, imageOffsetY, imageWidth * f, totalOffset);
    }
    
}

@end
