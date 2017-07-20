//
//  AccountSafeViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/4.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AccountSafeViewController.h"
#import "SettingListCell.h"
#import "CheckPhoneViewController.h"
#import "ChangePhoneViewController.h"
#import "ChangeMinepwdViewController.h"
@interface AccountSafeViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSArray * titles;
@end

@implementation AccountSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"帐号与安全" color:KTColor_MainBlack];
    
    [self creatUI];
}
- (void)creatUI{
    self.titles = @[@"手机",@"微信",@"QQ",@"微博",@"密码设置"];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(100);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(30);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(30));
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"SettingListCell";
    SettingListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SettingListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithName:self.titles[indexPath.row] desc:@""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[ChangePhoneViewController new] animated:YES];
//        [self.navigationController pushViewController:[CheckPhoneViewController new] animated:YES];
    }else if(indexPath.row == 4){
        [self.navigationController pushViewController:[ChangeMinepwdViewController new] animated:YES];
    }
}

@end
