//
//  SettingViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/4.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingListCell.h"
#import "WI-FISettingCell.h"
#import "PushSettingViewController.h"
#import "AccountSafeViewController.h"
#import "AboutusViewController.h"
#import "ShareView.h"
#import "LoginViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) ShareView * shareView;
//@property (nonatomic, strong) NSArray * descs;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"设置" color:KTColor_MainBlack];
    
    [self creatUI];
}
- (void)creatUI{
    self.titles = @[@"推送消息设置",@"WI-FI时自动下载音频",@"推荐给好友",@"给软件打分",@"意见反馈",@"清除缓存",@"帐号与安全",@"关于我们"];
    
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];

    self.shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) hasNav:YES];
    [self.view addSubview:self.shareView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.titles.count - 1;
    }else{
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        return Anno750(140);
    }else{
        return Anno750(100);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(30);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return Anno750(130);
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView * footer = [KTFactory creatViewWithColor:[UIColor clearColor]];
        footer.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(130));
        UIButton * button = [KTFactory creatButtonWithTitle:@"退出"
                                            backGroundColor:[UIColor clearColor]
                                                  textColor:KTColor_MainOrange
                                                   textSize:font750(32)];
        button.layer.borderColor = KTColor_MainOrange.CGColor;
        button.layer.borderWidth = 1.0f;
        button.layer.cornerRadius = 4.0f;
        [footer addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(24)));
            make.right.equalTo(@(Anno750(-24)));
            make.bottom.equalTo(@0);
            make.height.equalTo(@(Anno750(90)));
        }];
        [button addTarget:self action:@selector(userLogOut) forControlEvents:UIControlEventTouchUpInside];
        return footer;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(30));
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        static NSString * cellid = @"WI-FISettingCell";
        WI_FISettingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[WI_FISettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        return cell;
    }
    static NSString * cellid = @"SettingListCell";
    SettingListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SettingListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSString * title = self.titles[0];
    if (indexPath.section == 1) {
        title = self.titles[indexPath.row +1];
    }
    NSString * desc = @"";
    BOOL rec = NO;
    if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            desc = [NSString stringWithFormat:@"客服微信：%@",[UserManager manager].serviceWeChat];
            rec = YES;
        }else if(indexPath.row == 4){
            CGFloat folderSize =[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
            desc = [NSString stringWithFormat:@"%.2fM",folderSize];
        }
    }
    [cell updateWithName:title desc:desc hiddenArrow:rec];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:[PushSettingViewController new] animated:YES];
    }else if(indexPath.section == 1){
        if (indexPath.row == 1) {
            [self.shareView show];
        }else if(indexPath.row == 2){
            NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", APPID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }else if(indexPath.row == 4){
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定清除缓存" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[SDImageCache sharedImageCache] clearMemory];
                SettingListCell * cell = [self.tabview cellForRowAtIndexPath:indexPath];
                cell.descLabel.text = @"0K";
                [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"已清除缓存" duration:1.0f];
            }];
            [alert addAction:action];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
        }else if (indexPath.row == 5) {
            if ([UserManager manager].isLogin) {
                [self.navigationController pushViewController:[AccountSafeViewController new] animated:YES];
            }else{
                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }else if(indexPath.row == 6){
            [self.navigationController pushViewController:[AboutusViewController new] animated:YES];
        }
    }
}
- (void)userLogOut{
    [[UserManager manager] userLogout];
    [self doBack];
}
@end
