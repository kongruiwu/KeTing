//
//  VoiceDetailViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/12.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "VoiceDetailViewController.h"
#import "VoiceDetailHeader.h"
#import "ShareView.h"
#import "VoiceSummaryCell.h"
#import "VoiceUpdateListCell.h"
#import "HomeListenModel.h"
@interface VoiceDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) ShareView * shareView;
@property (nonatomic, strong) HomeListenModel * listenModel;
@property (nonatomic, strong) VoiceDetailHeader * header;

@end

@implementation VoiceDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, 20)];
    [self.view addSubview:clearView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self getData];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)creatUI{
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT  ) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.header  = [[VoiceDetailHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(485))];
    [self.header.backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.header.shareBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    self.tabview.tableHeaderView = self.header;
    
    self.shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) hasNav:NO];
    [self.view addSubview:self.shareView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView * header = [KTFactory creatViewWithColor:[UIColor whiteColor]];
        header.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(80));
        UILabel * nameLabel = [KTFactory creatLabelWithText:@"最新更新"
                                                  fontValue:font750(32)
                                                  textColor:KTColor_MainBlack
                                              textAlignment:NSTextAlignmentLeft];
        UIView * bottomLine = [KTFactory creatLineView];
        [header addSubview:nameLabel];
        [header addSubview:bottomLine];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(24)));
            make.centerY.equalTo(@0);
        }];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(24)));
            make.right.equalTo(@(-Anno750(24)));
            make.height.equalTo(@0.5);
            make.bottom.equalTo(@0);
        }];
        return header;
    }
    UIView * headView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    headView.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(120));
    UIButton * likeBtn = [KTFactory creatButtonWithTitle:[NSString stringWithFormat:@"  %@",self.listenModel.praseNum]
                                         backGroundColor:[UIColor clearColor]
                                               textColor:KTColor_MainOrange
                                                textSize:font750(30)];
    [likeBtn setImage:[UIImage imageNamed:@"listen_like"] forState:UIControlStateNormal];
//    [likeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    UIButton * buyBtn = [KTFactory creatButtonWithTitle:[NSString stringWithFormat:@"订阅：%@",self.listenModel.timePrice]
                                        backGroundColor:KTColor_MainOrange
                                              textColor:[UIColor whiteColor]
                                               textSize:font750(30)];
    [headView addSubview:likeBtn];
    [headView addSubview:buyBtn];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@10);
        make.width.equalTo(@(Anno750(321)));
        make.height.equalTo(@(Anno750(68)));
    }];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@10);
        make.width.equalTo(@(Anno750(321)));
        make.height.equalTo(@(Anno750(68)));
    }];
    likeBtn.layer.borderColor = KTColor_MainOrange.CGColor;
    likeBtn.layer.borderWidth = 1.0f;
    likeBtn.layer.cornerRadius= 2.0f;
    buyBtn.layer.cornerRadius = 2.0f;
    
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return Anno750(120);
    }
    return Anno750(80);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.listenModel.audio.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        CGSize size = [KTFactory getSize:[KTFactory changeHtmlString:self.listenModel.descString withFont:font750(28)] maxSize:CGSizeMake(font750(702), 99999)];
        return Anno750(80)+ size.height;
    }
    return Anno750(175);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * cellid = @"summaryCell";
        VoiceSummaryCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[VoiceSummaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateWithDescString:self.listenModel.descString count:self.listenModel.orderNum];
        return cell;
    }else{
        static NSString * cellid = @"updateCell";
        VoiceUpdateListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[VoiceUpdateListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateWithHomeListenModel:self.listenModel.audio[indexPath.row]];
        return cell;
    }
}
- (void)showShareView{
    [self.shareView show];
}
- (void)getData{
    [[NetWorkManager manager] GETRequest:@{} pageUrl:[NSString stringWithFormat:@"%@/%@",Page_VoiceDetail,self.voiceID] complete:^(id result) {
        NSDictionary * dic = (NSDictionary *)result;
        self.listenModel = [[HomeListenModel alloc]initWithDictionary:dic];
        [self.header updateWithImage:self.listenModel.thumb title:self.listenModel.name];
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:2.0f];
    }];
}
@end
