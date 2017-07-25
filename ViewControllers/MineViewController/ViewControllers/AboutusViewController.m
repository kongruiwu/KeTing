//
//  AboutusViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/7/5.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AboutusViewController.h"
#import "SettingListCell.h"
#import "WKWebViewController.h"
@interface AboutusViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UITableView * tabview;

@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSArray * descs;
@end

@implementation AboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUnAlpha];
    [self drawBackButtonWithType:BackImgTypeBlack];
    [self setNavTitle:@"关于我们" color:KTColor_MainBlack];
    [self creatUI];
}
- (void)creatUI{
    self.titles = @[@"客服微信",@"意见反馈邮箱",@"服务使用协议"];
    self.descs = @[[UserManager manager].serviceWeChat,[UserManager manager].serviceMail,@""];
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(90);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(500);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    header.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(500));
    UIView * grayView = [KTFactory creatViewWithColor:KTColor_BackGround];
    grayView.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(30));
    [header addSubview:grayView];
    
    UIImageView * imageView = [KTFactory creatImageViewWithImage:@""];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[UserManager manager].logo]];
    [header addSubview:imageView];
    UILabel * label = [KTFactory creatLabelWithText:[NSString stringWithFormat:@"版本号 v%@",[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]]
                                          fontValue:font750(24)
                                          textColor:KTColor_darkGray
                                      textAlignment:NSTextAlignmentLeft];
    [header addSubview:label];
    UIView * line = [KTFactory creatLineView];
    [header addSubview:line];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(grayView.mas_bottom).offset(Anno750(60));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(imageView.mas_bottom).offset(Anno750(20));
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"SettingListCell";
    SettingListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[SettingListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    BOOL rec = YES;
    if (indexPath.row == 2) {
        rec = NO;
    }
    [cell updateWithName:self.titles[indexPath.row] desc:self.descs[indexPath.row] hiddenArrow:rec];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        WKWebViewController * vc = [[WKWebViewController alloc]init];
        vc.isFromNav = YES;
        vc.webType = PROTOCOLTYPEAGREE;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
