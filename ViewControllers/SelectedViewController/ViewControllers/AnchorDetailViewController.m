//
//  AnchorDetailViewController.m
//  KeTing
//
//  Created by 吴孔锐 on 2017/6/13.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AnchorDetailViewController.h"
#import "ListenDetailViewController.h"
#import "ListenListCell.h"
#import "AnchorHeader.h"
#import "AnchorModel.h"
#import "ShopCarViewController.h"
#import "SetAccoutViewController.h"
#import "LoginViewController.h"
#import "RootViewController.h"
@interface AnchorDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ListenListDelegate>

//@property (nonatomic, strong)UITableView * tabview;
@property (nonatomic, strong) AnchorHeader * anchorHeader;
@property (nonatomic, strong) AnchorModel * anchor;
@property (nonatomic) int page;
@end

@implementation AnchorDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, 20)];
    [self.view addSubview:clearView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getData];
    
    [self checkNetStatus];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];    
}
- (void)creatUI{
    self.page = 1;
    self.tabview = [KTFactory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT ) style:UITableViewStylePlain];
    self.tabview.delegate =self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    self.anchorHeader = [[AnchorHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(440))];
    [self.anchorHeader.backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self.anchorHeader.shareBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.anchorHeader.shopCar addTarget:self action:@selector(goShopCar) forControlEvents:UIControlEventTouchUpInside];
    self.tabview.tableHeaderView = self.anchorHeader;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.anchor.listenVolice.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(250);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(75);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [KTFactory creatViewWithColor:KTColor_BackGround];
    view.frame = CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT);
    UILabel * label = [KTFactory creatLabelWithText:[NSString stringWithFormat:@"他的音频(%ld)",self.anchor.listenVolice.count]
                                          fontValue:font750(30)
                                          textColor:KTColor_lightGray
                                      textAlignment:NSTextAlignmentLeft];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"ListenListCell";
    ListenListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell ) {
        cell = [[ListenListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithListenModel:self.anchor.listenVolice[indexPath.row]];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListenDetailViewController * vc = [ListenDetailViewController new];
    HomeListenModel * model = self.anchor.listenVolice[indexPath.row];
    vc.isFromAnchor = YES;
    vc.listenID = model.listenId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getData{
    [self showLoadingCantTouchAndClear];
    [[NetWorkManager manager] GETRequest:@{} pageUrl:[NSString stringWithFormat:@"%@/%@",Page_AnchorDetail,self.anchorID] complete:^(id result) {
        [self dismissLoadingView];
        NSDictionary * dic = (NSDictionary *)result;
        self.anchor = [[AnchorModel alloc]initWithDictionary:dic];
        [self.anchorHeader updateWithAnchorModel:self.anchor];
        [self.tabview reloadData];
    } errorBlock:^(KTError *error) {
        [self dismissLoadingView];
    }];
    
    [[NetWorkManager manager] GETRequest:@{} pageUrl:Page_ShopCarCount complete:^(id result) {
        NSString * count = [NSString stringWithFormat:@"%@",result];
        [self.anchorHeader updateShopCarCount:count];
    } errorBlock:^(KTError *error) {
        
    }];
}
#pragma mark - 分享
- (void)showShareView{
    ShareModel * model = [[ShareModel alloc]init];
    model.shareTitle = [NSString stringWithFormat:@"我在听%@讲述的音频，推荐给你。",self.anchor.name];
    model.shareDesc = self.anchor.summary;
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.anchor.face]]];
    model.image = image;
    model.targeturl = [NSString stringWithFormat:@"%@%@%@",Base_Url,Page_ShareAnchor,self.anchor.anchorId];
    RootViewController * tbc = (RootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [tbc.shareView updateWithShareModel:model];
    [tbc.shareView show];
}
#pragma mark - 查看购物车
- (void)goShopCar{
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

#pragma mark - listenlistcell代理 加入购物车 购买 等
- (void)buyThisBook:(UIButton *)btn{
    if (![UserManager manager].isLogin) {
        LoginViewController * vc = [LoginViewController new];
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        UITableViewCell * cell = (UITableViewCell *)[btn superview];
        NSIndexPath * indexpath = [self.tabview indexPathForCell:cell];
        HomeListenModel * model = self.anchor.listenVolice[indexpath.row];
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
        HomeListenModel * model = self.anchor.listenVolice[indexpath.row];
        NSDictionary * params = @{
                                  @"userId":[UserManager manager].userid,
                                  @"relationId":model.listenId,
                                  @"relationType":@2
                                  };
        [self showLoadingCantTouchAndClear];
        [[NetWorkManager manager] POSTRequest:params pageUrl:Page_AddCar complete:^(id result) {
            [self dismissLoadingView];
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"添加成功" duration:1.0f];
            int count = [self.anchorHeader.countLabel.text intValue] + 1;
            [self.anchorHeader updateShopCarCount:[NSString stringWithFormat:@"%d",count]];
            btn.selected = !btn.selected;
        } errorBlock:^(KTError *error) {
            [self dismissLoadingView];
            
        }];
    }
}
- (void)checkShopCar{
    [self goShopCar];
}

//设置头部拉伸效果
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //图片高度
    CGFloat imageHeight = self.anchorHeader.frame.size.height;
    //图片宽度
    CGFloat imageWidth = UI_WIDTH;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    //上移
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat f = totalOffset / imageHeight;
        
        self.anchorHeader.groundImg.frame = CGRectMake(-(imageWidth * f - imageWidth) * 0.5, imageOffsetY, imageWidth * f, totalOffset);
    }
    
}

@end
