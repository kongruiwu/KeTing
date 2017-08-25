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
#import <UMSocialCore/UMSocialCore.h>
@interface AccountSafeViewController ()<UITableViewDelegate,UITableViewDataSource>

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
//    self.titles = @[@"手机",@"微信",@"QQ",@"微博",@"密码设置"];
    self.titles = @[@"手机",@"密码设置"];
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
    if (indexPath.row == 0) {
        if ([UserManager manager].info.MOBILE && [UserManager manager].info.MOBILE.length>0) {
            NSMutableString * phoneNumber = [NSMutableString stringWithFormat:@"%@",[UserManager manager].info.MOBILE];
            [phoneNumber replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            [cell updateWithName:self.titles[indexPath.row] desc:phoneNumber];
        }else{
            [cell updateWithName:self.titles[indexPath.row] desc:@"未绑定"];
        }
    }
//    else if(indexPath.row == 1){
//        if ([[UserManager manager].info.V_STATE boolValue]) {
//            [cell updateWithName:self.titles[indexPath.row] desc:@"已绑定"];
//        }else{
//            [cell updateWithName:self.titles[indexPath.row] desc:@"未绑定"];
//        }
//    }
    else{
        [cell updateWithName:self.titles[indexPath.row] desc:@""];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if ([UserManager manager].info.MOBILE && [UserManager manager].info.MOBILE.length>0) {
            [self.navigationController pushViewController:[ChangePhoneViewController new] animated:YES];
        }else{
            [self.navigationController pushViewController:[CheckPhoneViewController new] animated:YES];
        }
    }else if(indexPath.row == 1){
        [self.navigationController pushViewController:[ChangeMinepwdViewController new] animated:YES];
    }
//    else if(indexPath.row == 1){
//        [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
//    }
}
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.description duration:1.0f];
            return ;
        }
        UMSocialUserInfoResponse *resp = result;
        NSDictionary * params = @{
                                  @"userid":[UserManager manager].info.USERID,
                                  @"Unionid":resp.unionId,
                                  @"openid":resp.openid,
                                  @"token":resp.accessToken,
                                  @"type":@"6",
                                  @"nickname":resp.name,
                                  @"icon":resp.iconurl,
                                  };
        [[NetWorkManager manager] POSTRequest:params pageUrl:Page_ThirdBind complete:^(id result) {
            NSLog(@"222");
        } errorBlock:^(KTError *error) {
            NSLog(@"123");
        }];
    }];
}



@end
