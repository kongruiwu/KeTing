//
//  ListenDetailViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ListenDetailViewController.h"
#import "VoiceDetailHeader.h"
#import "ShareView.h"
#import "VoiceSummaryCell.h"
#import "VoiceUpdateListCell.h"
#import "ListenAnchorCell.h"
#import "AnchorDetailViewController.h"
@interface ListenDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) ShareView * shareView;
@property (nonatomic, strong) VoiceDetailHeader * header;
@property (nonatomic, strong) HomeListenModel * listenModel;

@end

@implementation ListenDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, 20)];
    [self.view addSubview:clearView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self getData];
}
- (void)creatUI{
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT  ) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.header  = [[VoiceDetailHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(485))];
    self.header.shopCar.hidden = NO;
    [self.header.backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.header.shareBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    self.tabview.tableHeaderView = self.header;
    
    self.shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) hasNav:NO];
    [self.view addSubview:self.shareView];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * headView = [KTFactory creatViewWithColor:[UIColor whiteColor]];
    headView.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(120));
    UIButton * likeBtn = [KTFactory creatButtonWithTitle:[NSString stringWithFormat:@"  %@",self.listenModel.praseNum]
                                         backGroundColor:[UIColor clearColor]
                                               textColor:KTColor_MainOrange
                                                textSize:font750(30)];
    [likeBtn setImage:[UIImage imageNamed:@"listen_like"] forState:UIControlStateNormal];
    //    [likeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    
    UIButton * shopCar = [KTFactory creatButtonWithTitle:@"  购物车"
                                         backGroundColor:[UIColor clearColor]
                                               textColor:KTColor_MainOrange
                                                textSize:font750(30)];
    [shopCar setImage:[UIImage imageNamed:@"shopcar"] forState:UIControlStateNormal];
    
    UIButton * buyBtn = [KTFactory creatButtonWithTitle:[NSString stringWithFormat:@"购买：%@",self.listenModel.timePrice]
                                        backGroundColor:KTColor_MainOrange
                                              textColor:[UIColor whiteColor]
                                               textSize:font750(30)];
    [headView addSubview:likeBtn];
    [headView addSubview:shopCar];
    [headView addSubview:buyBtn];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@10);
        make.width.equalTo(@(Anno750(220)));
        make.height.equalTo(@(Anno750(68)));
    }];
    [shopCar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.equalTo(@(Anno750(220)));
        make.height.equalTo(@(Anno750(68)));
        make.centerY.equalTo(@10);
    }];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@10);
        make.width.equalTo(@(Anno750(220)));
        make.height.equalTo(@(Anno750(68)));
    }];
    likeBtn.layer.borderColor = KTColor_MainOrange.CGColor;
    likeBtn.layer.borderWidth = 1.0f;
    likeBtn.layer.cornerRadius= 2.0f;
    shopCar.layer.borderColor = KTColor_MainOrange.CGColor;
    shopCar.layer.borderWidth = 1.0f;
    shopCar.layer.cornerRadius= 2.0f;
    buyBtn.layer.cornerRadius = 2.0f;
    
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(120);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return Anno750(128);
    }
    CGSize size = [KTFactory getSize:[KTFactory changeHtmlString:self.listenModel.descString withFont:font750(28)] maxSize:CGSizeMake(font750(702), 99999)];
    return Anno750(80)+ size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString * cellid = @"ListenAnchorCell";
        ListenAnchorCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ListenAnchorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell updateWithIcon:self.listenModel.anchorFace name:self.listenModel.anchorName];
        return cell;
    }
    
    static NSString * cellid = @"summaryCell";
    VoiceSummaryCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[VoiceSummaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithDescString:self.listenModel.descString time:self.listenModel.audioModel.audioLong];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AnchorDetailViewController * vc = [AnchorDetailViewController new];
        vc.anchorID = self.listenModel.anchorId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)showShareView{
    [self.shareView show];
}
- (void)doBack{
    [super doBack];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)getData{
    NSString * listenid ;
    if (self.listenModel) {
        listenid = self.listenModel.listenId;
    }else{
        listenid = self.listenID;
    }
    [[NetWorkManager manager] GETRequest:@{} pageUrl:[NSString stringWithFormat:@"%@/%@",Page_ListenDetail,listenid] complete:^(id result) {
        NSDictionary * dic = (NSDictionary *)result;
        self.listenModel = [[HomeListenModel alloc]initWithDictionary:dic];
        [self.header updateWithImage:self.listenModel.thumb title:self.listenModel.name];
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:2.0f];
    }];
}


@end
